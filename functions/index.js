const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendChatNotification = functions.firestore
    .document("chat/{messageId}")
    .onCreate(async (snapshot) => {
      const message = snapshot.data();

      // 1️⃣ Get receiver user
      const userDoc = await admin
          .firestore()
          .collection("users")
          .doc(message.receiverId)
          .get();

      if (!userDoc.exists) return;

      const fcmToken = userDoc.data().fcmToken;
      if (!fcmToken) return;

      // 2️⃣ Notification payload
      const payload = {
        notification: {
          title: message.username,
          body: message.text,
        },
        android: {
          priority: "high",
          notification: {
            sound: "default",
          },
        },
        token: fcmToken,
      };

      // 3️⃣ Send notification
      await admin.messaging().send(payload);
    });
