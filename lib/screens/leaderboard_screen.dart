import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('leaderboard')
            .orderBy('score', descending: true)
            .limit(10)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final scores = snapshot.data!.docs;

          if (scores.isEmpty) {
            return Center(child: Text('No scores yet.'));
          }

          return ListView.builder(
            itemCount: scores.length,
            itemBuilder: (context, index) {
              final data = scores[index].data() as Map<String, dynamic>;
              final timestamp = data['timestamp'] != null
                  ? (data['timestamp'] as Timestamp).toDate()
                  : null;

              return ListTile(
                leading: Text('#${index + 1}'),
                title: Text('Score: ${data['score']}'),
                subtitle: timestamp != null
                    ? Text('Achieved: ${timestamp.toLocal()}')
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
