import 'package:flutter/material.dart';
import 'package:testu_cl/models/topic.dart';

class CommonWidgets {
  static Future<void> showInfoDialog({
    required BuildContext context,
    required String title,
    required String description,
    String? buttonText,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(children: <Widget>[Text(description)]),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(buttonText ?? 'OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Widget buildCompetenceBadge({required Efficiency efficiency}) {
    Color color;
    IconData icon;
    if (efficiency == Efficiency.beginner) {
      color = Colors.green;
      icon = Icons.local_florist;
    } else if (efficiency == Efficiency.learner) {
      color = Colors.yellow;
      icon = Icons.stars;
    } else {
      color = Colors.orange;
      icon = Icons.emoji_events;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'COMPETENCE LEVEL',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white54,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              efficiency.name.replaceFirst(
                efficiency.name[0],
                efficiency.name[0].toUpperCase(),
              ),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget buildCurrentScore({
    required BuildContext context,
    required double score,
  }) {
    Color color;
    if (score < 30) {
      color = Colors.red;
    } else if (score < 70) {
      color = Colors.yellow;
    } else {
      color = Colors.green;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'CURRENT SCORE',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white54,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "${score.toInt()}%",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () {
                showInfoDialog(
                  context: context,
                  title: "Reliability Assessment",
                  description:
                      "The reliability score indicates your current level of competence in this topic. It goes down with time, so you need to review the topic regularly to keep it high.",
                );
              },
              child: Icon(
                Icons.info_outline,
                color: Colors.white.withValues(alpha: 0.5),
                size: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
