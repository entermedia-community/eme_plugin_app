import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testu_cl/models/topic.dart';
import 'package:transparent_image/transparent_image.dart';

import '../screens/topic_tutorials_screen.dart';
import '../utils/language_helper.dart';

class TopicsCard extends StatelessWidget {
  final Topic topic;

  const TopicsCard({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    final mainColor = const Color(0xFF38B6FF);
    final double expirationProgress = (topic.expiresIn / topic.validityPeriod)
        .clamp(0.0, 1.0);
    final Color progressColor;
    if (expirationProgress < 0.5) {
      progressColor =
          Color.lerp(
            const Color(0xFFE94057),
            const Color(0xFFF27121),
            expirationProgress * 2.0,
          ) ??
          const Color(0xFFF27121);
    } else {
      progressColor =
          Color.lerp(
            const Color(0xFFF27121),
            const Color(0xFF38EF7D),
            (expirationProgress - 0.5) * 2.0,
          ) ??
          const Color(0xFF38EF7D);
    }

    return ValueListenableBuilder<String>(
      valueListenable: LanguageHelper.languageNotifier,
      builder: (context, currentLanguage, _) {
        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TopicTutorialsScreen(topic: topic),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            splashColor: mainColor.withValues(alpha: 0.1),
            highlightColor: mainColor.withValues(alpha: 0.05),
            child: Ink(
              decoration: BoxDecoration(
                color: const Color(0xFF161C24).withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.06),
                  width: 1.2,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Thumbnail on the left
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          width: 120,
                          height: 120,
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: topic.thumbnail,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey,
                                child: const Icon(
                                  Icons.error,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Title, Subtitle, Progress and Stat
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              topic.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              LanguageHelper.translate(
                                'tutorials_count',
                                placeholders: {
                                  'count': topic.tutorial.length.toString(),
                                },
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white60,
                              ),
                            ),

                            const SizedBox(height: 10),
                            // Progress Bar
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: LinearProgressIndicator(
                                      value: topic.progress,
                                      minHeight: 5,
                                      backgroundColor: Colors.white.withValues(
                                        alpha: 0.06,
                                      ),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        mainColor,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "${(topic.progress * 100).toInt()}%",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white60,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${topic.expiresIn.toInt()}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: progressColor,
                                  ),
                                ),
                                Text(
                                  LanguageHelper.translate('days_to_go'),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white60,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                // Round progressbar
                                const Icon(Icons.signal_cellular_alt_2_bar),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      LanguageHelper.translate('moderate'),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      LanguageHelper.translate('efficiency'),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white60,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              LanguageHelper.translate(
                                'last_updated',
                                placeholders: {
                                  'date': DateFormat.yMMMMd().format(
                                    topic.lastUpdated,
                                  ),
                                },
                              ),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white38,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
