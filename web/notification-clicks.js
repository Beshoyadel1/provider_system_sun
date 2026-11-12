// Keep notification clicks until Flutter has mounted its listener.
(() => {
  let callback = null;
  const pendingMessages = [];
  const storageKey = 'sun.pendingNotificationClick';
  let pendingClick = null;
  try {
    pendingClick = JSON.parse(sessionStorage.getItem(storageKey) || 'null');
  } catch (_) {}

  const launchUrl = new URL(window.location.href);
  const launchClick = launchUrl.searchParams.get('notificationClick');
  if (launchClick) {
    try { pendingClick = JSON.parse(launchClick); } catch (_) {}
    launchUrl.searchParams.delete('notificationClick');
    history.replaceState(history.state, '', launchUrl);
  }

  function deliverClick() {
    if (!callback || !pendingClick) return;
    const payload = pendingClick;
    pendingClick = null;
    try { sessionStorage.removeItem(storageKey); } catch (_) {}
    callback(JSON.stringify({ ...payload, sunOpened: true }));
  }

  function waitForActiveWorker(registration) {
    const worker = registration.active || registration.installing || registration.waiting;
    if (!worker) return Promise.reject(new Error('FCM service worker is missing'));
    return new Promise((resolve, reject) => {
      function checkState() {
        if (worker.state === 'activated') finish();
        else if (worker.state === 'redundant') {
          finish(new Error('FCM service worker installation failed'));
        }
      }
      function finish(error) {
        clearTimeout(timer);
        worker.removeEventListener('statechange', checkState);
        if (error) reject(error);
        else resolve();
      }
      const timer = setTimeout(() => finish(new Error('FCM service worker activation timed out')), 12000);
      worker.addEventListener('statechange', checkState);
      checkState();
    });
  }

  if ('serviceWorker' in navigator) {
    const workerPath = '/firebase-messaging-sw.js';
    const workerUrl = new URL(workerPath, window.location.href).href;
    let workerReady;
    // Firebase's Web SDK uses this same script and scope for getToken().
    window.prepareSunFcmWorker = () => {
      workerReady ??= navigator.serviceWorker.register(workerPath, {
        scope: '/firebase-cloud-messaging-push-scope',
      }).then(waitForActiveWorker).catch((error) => {
        workerReady = null;
        throw error;
      });
      return workerReady;
    };

    navigator.serviceWorker.addEventListener('message', (event) => {
      const packet = event.data;
      const sdkPacket = packet?.isFirebaseMessaging === true;
      if (packet?.type === 'SUN_NOTIFICATION_RECEIVED' ||
          packet?.type === 'SUN_NOTIFICATION_MESSAGE' ||
          (sdkPacket && packet.messageType === 'push-received')) {
        const payload = { ...(sdkPacket ? packet : packet.payload), sunOpened: false };
        if (callback) callback(JSON.stringify(payload));
        else {
          pendingMessages.push(payload);
          if (pendingMessages.length > 100) pendingMessages.shift();
        }
        return;
      }
      if (packet?.type !== 'SUN_NOTIFICATION_CLICK' &&
          !(sdkPacket && packet.messageType === 'notification-clicked')) return;
      pendingClick = sdkPacket ? packet : packet.payload;
      try { sessionStorage.setItem(storageKey, JSON.stringify(pendingClick)); } catch (_) {}
      if (!sdkPacket) event.source?.postMessage({ type: 'SUN_NOTIFICATION_ACK' });
      deliverClick();
    });
    window.prepareSunFcmWorker()
      .then(() => navigator.serviceWorker.getRegistrations())
      .then((registrations) => {
        for (const registration of registrations) {
          if (registration.active?.scriptURL === workerUrl) {
            registration.active.postMessage({ type: 'SUN_NOTIFICATION_READY' });
          }
        }
      })
      .catch(() => {});
  }

  window.listenForSunNotificationClicks = (onNotification) => {
    callback = onNotification;
    for (const payload of pendingMessages.splice(0)) callback(JSON.stringify(payload));
    deliverClick();
    return () => {
      callback = null;
      pendingMessages.length = 0;
      pendingClick = null;
      try { sessionStorage.removeItem(storageKey); } catch (_) {}
    };
  };
})();
