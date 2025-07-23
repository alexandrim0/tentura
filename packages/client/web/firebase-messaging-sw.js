// Please see this file for the latest firebase-js-sdk version:
// https://github.com/firebase/flutterfire/blob/main/packages/firebase_core/firebase_core_web/lib/src/firebase_sdk_version.dart
importScripts("https://www.gstatic.com/firebasejs/11.9.1/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/11.9.1/firebase-messaging-compat.js");

firebase.initializeApp({
  appId: "{*os.getenv'FB_APP_ID'*}",
  apiKey: "{*os.getenv'FB_API_KEY'*}",
  projectId: "{*os.getenv'FB_PROJECT_ID'*}",
  authDomain: "{*os.getenv'FB_AUTH_DOMAIN'*}",
  storageBucket: "{*os.getenv'FB_STORAGE_BUCKET'*}",
  messagingSenderId: "{*os.getenv'FB_SENDER_ID'*}",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  self.registration.showNotification(
    payload.notification.title,
    {
      body: payload.notification.body,
    },
  );
});
