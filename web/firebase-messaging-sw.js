// Register before Firebase's listener so a click reaches the Flutter router.
self.addEventListener('notificationclick', (event) => {
  event.stopImmediatePropagation();
  event.notification.close();
  const stored = event.notification.data || {};
  const payload = stored.FCM_MSG || stored.FCM_PAYLOAD || { data: stored };
  event.waitUntil(clients.matchAll({ type: 'window', includeUncontrolled: true })
    .then(async (windows) => {
      const scope = new URL(self.registration.scope);
      const target = windows.find((client) =>
        new URL(client.url).origin === scope.origin && client.url.startsWith(scope.href));
      if (target) {
        await target.focus();
        target.postMessage({ type: 'SUN_NOTIFICATION_CLICK', payload });
      } else {
        scope.searchParams.set('notificationClick', JSON.stringify(payload));
        await clients.openWindow(scope.href);
      }
    }));
});

importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js");

if (!firebase.apps.length) {
  firebase.initializeApp({
    apiKey: "AIzaSyB8Lixy-XF0V_UCTGCzUz0AEBzLgIP-7ik",
    appId: "1:567407553652:web:d510db5fa139b829b7b521",
    messagingSenderId: "567407553652",
    projectId: "sun-app-6c6af",
    authDomain: "sun-app-6c6af.firebaseapp.com",
    storageBucket: "sun-app-6c6af.firebasestorage.app",
    measurementId: "G-R3BVP1XBXZ",
  });
}

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log("[firebase-messaging-sw.js] Received background message ", payload);

  // If payload already has a notification block, Firebase Web SDK displays it automatically
  if (payload.notification && (payload.notification.title || payload.notification.body)) {
    return;
  }

  const notificationTitle =
      payload.data?.title || payload.data?.latintitle || "San Provider System";
  const notificationOptions = {
    body:
        payload.data?.body ||
        payload.data?.description ||
        payload.data?.message ||
        "",
    icon: "/favicon.png",
    data: { FCM_PAYLOAD: payload },
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
