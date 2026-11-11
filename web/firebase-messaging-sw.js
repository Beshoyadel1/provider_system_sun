// Firebase's default push scope is not the app URL. Derive the app directory
// from this worker's script so both default and custom registrations work.
const appUrl = new URL('./', self.location.href);
const pendingClicks = new Map();

// Register before Firebase's listener so a click reaches the Flutter router.
self.addEventListener('notificationclick', (event) => {
  event.stopImmediatePropagation();
  event.notification.close();
  const stored = event.notification.data || {};
  const payload = stored.FCM_MSG || stored.FCM_PAYLOAD || stored;
  event.waitUntil((async () => {
    const windows = await clients.matchAll({ type: 'window', includeUncontrolled: true });
    let target = windows.find((client) => client.url.startsWith(appUrl.href));
    if (target) await target.focus();
    else target = await clients.openWindow(appUrl.href);
    if (!target) return;
    pendingClicks.set(target.id, payload);
    target.postMessage({ type: 'SUN_NOTIFICATION_CLICK', payload });
  })());
});

self.addEventListener('message', (event) => {
  const clientId = event.source?.id;
  if (event.data?.type === 'SUN_NOTIFICATION_ACK') pendingClicks.delete(clientId);
  if (event.data?.type === 'SUN_NOTIFICATION_READY' && pendingClicks.has(clientId)) {
    event.source.postMessage({
      type: 'SUN_NOTIFICATION_CLICK',
      payload: pendingClicks.get(clientId),
    });
  }
});

// Match the JavaScript SDK loaded by firebase_core_web 3.12.0.
importScripts("https://www.gstatic.com/firebasejs/12.19.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/12.19.0/firebase-messaging-compat.js");

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

messaging.onBackgroundMessage(async (payload) => {
  const scope = appUrl;
  const windows = await clients.matchAll({ type: 'window', includeUncontrolled: true });
  for (const client of windows) {
    if (new URL(client.url).origin === scope.origin && client.url.startsWith(scope.href)) {
      client.postMessage({ type: 'SUN_NOTIFICATION_RECEIVED', payload });
    }
  }

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
    data: payload,
  };

  await self.registration.showNotification(notificationTitle, notificationOptions);
});
