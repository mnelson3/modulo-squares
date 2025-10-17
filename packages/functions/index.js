const functions = require('firebase-functions');
const admin = require('firebase-admin');

// Import shared utilities
const { FunctionsAuthHelpers } = require('@shared/firebase-utils');

admin.initializeApp();

// Cloud Function to validate and process leaderboard submissions
exports.submitScore = functions.https.onCall(async (data, context) => {
  // Verify user is authenticated
  const user = FunctionsAuthHelpers.verifyAuthenticated(context);
  const { uid, email } = user;

  const { score, level } = data;

  // Validate input
  if (typeof score !== 'number' || score < 0) {
    throw new functions.https.HttpsError('invalid-argument', 'Invalid score');
  }

  if (typeof level !== 'number' || level < 1) {
    throw new functions.https.HttpsError('invalid-argument', 'Invalid level');
  }

  try {
    const userId = uid;
    const userEmail = email || 'anonymous';

    // Store score in Firestore
    await admin.firestore().collection('modulo_leaderboard').add({
      userId,
      userEmail,
      score,
      level,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { success: true, message: 'Score submitted successfully' };
  } catch (error) {
    console.error('Error submitting score:', error);
    throw new functions.https.HttpsError('internal', 'Failed to submit score');
  }
});

// Cloud Function to get top scores
exports.getTopScores = functions.https.onCall(async (data, context) => {
  const limit = data.limit || 10;

  try {
    const snapshot = await admin.firestore()
      .collection('modulo_leaderboard')
      .orderBy('score', 'desc')
      .limit(limit)
      .get();

    const scores = snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
    }));

    return { scores };
  } catch (error) {
    console.error('Error getting top scores:', error);
    throw new functions.https.HttpsError('internal', 'Failed to get top scores');
  }
});

// Cloud Function to validate purchases (server-side validation)
exports.validatePurchase = functions.https.onCall(async (data, context) => {
  // Verify user is authenticated
  const user = FunctionsAuthHelpers.verifyAuthenticated(context);
  const { uid } = user;

  const { productId, purchaseToken } = data;

  // In a real implementation, you would validate with the app store
  // For now, we'll just mark the purchase as valid
  try {
    const userId = uid;

    // Store purchase validation in Firestore
    await admin.firestore().collection('purchases').doc(userId).set({
      [productId]: {
        validated: true,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        purchaseToken,
      }
    }, { merge: true });

    return { valid: true, message: 'Purchase validated successfully' };
  } catch (error) {
    console.error('Error validating purchase:', error);
    throw new functions.https.HttpsError('internal', 'Failed to validate purchase');
  }
});