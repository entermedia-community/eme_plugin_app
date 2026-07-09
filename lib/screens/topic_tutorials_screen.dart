import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:testu_cl/widgets/common_widgets.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models/topic.dart';
import '../utils/language_helper.dart';
import '../widgets/tutorial_card.dart';

class TopicTutorialsScreen extends StatelessWidget {
  final Topic topic;

  const TopicTutorialsScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;
    final mainColor = const Color(0xFF38B6FF);

    return ValueListenableBuilder<String>(
      valueListenable: LanguageHelper.languageNotifier,
      builder: (context, currentLanguage, _) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0B0F13),
                  Color(0xFF141923),
                  Color(0xFF0F1319),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Row with Back Button
                  _buildHeader(context, mainColor),

                  // Scrollable list of tutorials
                  Expanded(
                    child: SingleChildScrollView(
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 40 : 20,
                            vertical: 24,
                          ),
                          width: min(700, size.width),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Topic Overview Details
                              _buildTopicBanner(context, mainColor),
                              const SizedBox(height: 32),

                              // Section Title
                              Text(
                                LanguageHelper.translate('tutorials'),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: mainColor,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // List of tutorials
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: topic.tutorial.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 16),
                                itemBuilder: (context, index) {
                                  final tutorial = topic.tutorial[index];
                                  // We render the TutorialCard widget
                                  return TutorialCard(
                                    tutorial: tutorial,
                                    isListMode: true,
                                  );
                                },
                              ),

                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
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

  Widget _buildHeader(BuildContext context, Color mainColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161C24).withValues(alpha: 0.4),
        border: const Border(
          bottom: BorderSide(color: Color(0xFF263238), width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white70,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              topic.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicBanner(BuildContext context, Color mainColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF161C24).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120,
                height: 120,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: topic.thumbnail,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey,
                      child: const Icon(Icons.error, color: Colors.white),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  topic.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    LanguageHelper.translate('average_rank').toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CommonWidgets.buildCompetenceBadge(
                    efficiency: topic.progress.getEfficiency(),
                  ),
                ],
              ),
              Row(
                children: [
                  CommonWidgets.buildProgressColumn(
                    topic.progress,
                    Efficiency.beginner,
                  ),
                  const SizedBox(width: 24),
                  CommonWidgets.buildProgressColumn(
                    topic.progress,
                    Efficiency.competent,
                  ),
                  const SizedBox(width: 24),
                  CommonWidgets.buildProgressColumn(
                    topic.progress,
                    Efficiency.expert,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),
          Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.7),
              ),
              children: [
                TextSpan(text: 'An average of '),
                TextSpan(
                  text: '${topic.answersForgotten.toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                TextSpan(text: ' answers forgotten over '),
                TextSpan(
                  text: topic.forgottenPeriod.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                TextSpan(text: ' days'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
