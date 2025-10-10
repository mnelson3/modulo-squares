import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _scoresCollection =
      _firestore.collection('modulo_leaderboard');

  /// Submit a score for a player. Overwrites if player already exists.
  static Future<void> submitScore(BuildContext context, String playerName, int score) async {
    try {
      await _scoresCollection.doc(playerName).set({
        'score': score,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit score: $e')),
      );
    }
  }

  /// Get a stream of top scores, ordered descending.
  static Stream<List<Map<String, dynamic>>> getTopScores(int limit) {
    return _scoresCollection
        .orderBy('score', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return {
                'name': doc.id,
                'score': data['score'] ?? 0,
              };
            }).toList());
  }
}
