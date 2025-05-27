
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _scoresCollection =
      _firestore.collection('modulo_leaderboard');

  static Future<void> submitScore(String playerName, int score) async {
    try {
      await _scoresCollection.doc(playerName).set({
        'score': score,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error submitting score: \$e');
    }
  }

  static Widget buildLeaderboardWidget() {
    return StreamBuilder<QuerySnapshot>(
      stream: _scoresCollection.orderBy('score', descending: true).limit(10).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error loading leaderboard');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Text('No scores yet');
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: docs.length,
          itemBuilder: (context, index) {
            var data = docs[index].data()! as Map<String, dynamic>;
            String player = docs[index].id;
            int score = data['score'] ?? 0;
            return ListTile(
              leading: const Text('#\${index + 1}'),
              title: Text(player),
              trailing: Text(score.toString()),
            );
          },
        );
      },
    );
  }
}
