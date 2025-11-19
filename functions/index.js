const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendChatNotification = functions.firestore
  .document("chats/{chatId}/messages/{messageId}")
  .onCreate(async (snap, context) => {
    const message = snap.data();

    const senderId = message.senderId;
    const receiverId = message.receiverId;
    const text = message.message;

    // Get receiver's FCM token
    const userDoc = await admin.firestore()
      .collection("users")
      .doc(receiverId)
      .get();

    if (!userDoc.exists) {
      console.log("Receiver user not found.");
      return;
    }

    const fcmToken = userDoc.data().fcmToken;

    if (!fcmToken) {
      console.log("No FCM token for receiver.");
      return;
    }

    const payload = {
      notification: {
        title: "New Message",
        body: text,
      },
      data: {
        senderId: senderId,
        click_action: "FLUTTER_NOTIFICATION_CLICK",
      }
    };

    try {
      await admin.messaging().sendToDevice(fcmToken, payload);
      console.log("Notification sent to:", receiverId);
    } catch (error) {
      console.error("Error sending notification:", error);
    }
  });
