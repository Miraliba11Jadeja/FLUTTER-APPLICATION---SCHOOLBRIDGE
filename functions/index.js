const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.deleteExpiredEvents = functions.pubsub.schedule('every 24 hours').onRun(async (context) => {
  const now = new Date();
  const cutoffDate = now.toISOString();  // Current date and time in ISO format
  
  try {
    // Get all events from Firestore
    const eventsSnapshot = await admin.firestore().collection('events').get();
    
    const batch = admin.firestore().batch();

    eventsSnapshot.forEach((doc) => {
      const event = doc.data();
      if (event.date && event.date < cutoffDate) {
        // If event date is in the past, delete the event
        batch.delete(doc.ref);
      }
    });

    // Commit batch delete
    await batch.commit();
    console.log('Expired events deleted successfully');
  } catch (error) {
    console.error('Error deleting expired events: ', error);
  }
});
