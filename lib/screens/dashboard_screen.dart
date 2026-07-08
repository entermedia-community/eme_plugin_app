import 'dart:math';

import 'package:flutter/material.dart';
import 'package:testu_cl/models/tag.dart';
import 'package:testu_cl/widgets/topics_card.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/topic.dart';
import '../utils/language_helper.dart';

class DashboardScreen extends StatefulWidget {
  final String username;
  final VoidCallback? onLogout;

  const DashboardScreen({super.key, required this.username, this.onLogout});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _activeWorkSpace = 'DEMO 1';
  String selectedTab = 'Catalog';

  // Compute average stats across all topics
  double get overallProgress {
    if (mockTopics.isEmpty) return 0.0;
    return mockTopics.map((t) => t.progress).reduce((a, b) => a + b) /
        mockTopics.length;
  }

  double get overallAverageScore {
    if (mockTopics.isEmpty) return 0.0;
    return mockTopics.map((t) => t.reliability).reduce((a, b) => a + b) /
        mockTopics.length;
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return ValueListenableBuilder<String>(
      valueListenable: LanguageHelper.languageNotifier,
      builder: (context, currentLanguage, _) {
        return Scaffold(
          key: _scaffoldKey,
          drawer: _buildDrawer(),
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
                  // 1. Sleek Modern Header
                  _buildHeader(context, isDesktop),

                  // 2. Main Content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Center(
                        child: Container(
                          width: min(700, size.width),
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 40 : 20,
                            vertical: 24,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Overall metrics overview card
                              _buildOverviewCard(
                                overallProgress,
                                overallAverageScore,
                              ),
                              const SizedBox(height: 32),

                              // Section Title
                              Text(
                                LanguageHelper.translate('topics'),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF38B6FF),
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Topics List
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: mockTopics.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 16),
                                itemBuilder: (context, index) {
                                  return TopicsCard(topic: mockTopics[index]);
                                },
                              ),
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

  Widget _buildHeader(BuildContext context, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 40 : 20,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF161C24).withValues(alpha: 0.4),
        border: const Border(
          bottom: BorderSide(color: Color(0xFF263238), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu_rounded, color: Colors.white70),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              const SizedBox(width: 8),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF38B6FF).withValues(alpha: 0.2),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Center(
                  child: Image(image: AssetImage('assets/logo.png')),
                ),
              ),
            ],
          ),

          Row(
            children: [
              PopupMenuButton<int>(
                offset: const Offset(0, 48),
                color: const Color(0xFF161C24),
                elevation: 8,
                shadowColor: Colors.black.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.08),
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.04),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.notifications_outlined,
                          size: 18,
                          color: Color(0xFF38B6FF),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE94057),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                  PopupMenuItem<int>(
                    value: -1,
                    enabled: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          LanguageHelper.translate('notifications'),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFE94057,
                            ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            LanguageHelper.translate('new_tutorials'),
                            style: const TextStyle(
                              color: Color(0xFFE94057),
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(height: 1),
                  PopupMenuItem<int>(
                    value: 0,
                    child: _buildNotificationItem(
                      title: LanguageHelper.translate('new_tutorial_title'),
                      body: LanguageHelper.translate('new_tutorial_body'),
                      time: LanguageHelper.translate('time_5m'),
                      isNew: true,
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: _buildNotificationItem(
                      title: LanguageHelper.translate('achievement_title'),
                      body: LanguageHelper.translate('achievement_body'),
                      time: LanguageHelper.translate('time_2h'),
                      isNew: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.analytics_outlined,
                    size: 18,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String body,
    required String time,
    required bool isNew,
  }) {
    return Container(
      width: 280,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isNew)
                Container(
                  margin: const EdgeInsets.only(right: 6),
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF38B6FF),
                    shape: BoxShape.circle,
                  ),
                ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isNew ? Colors.white : Colors.white70,
                    fontWeight: isNew ? FontWeight.bold : FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                time,
                style: const TextStyle(color: Colors.white38, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(double averageProgress, double averageScore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LanguageHelper.translate('profile'),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF38B6FF),
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image:
                            "https://upload.wikimedia.org/wikipedia/commons/4/47/PNG_transparency_demonstration_1.png",
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'John Smith',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${LanguageHelper.translate('topics_you_excel_at')} — ',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildProfileTags(),
                      ],
                    ),
                  ),
                ],
              ),
              // Row(
              //   children: [
              //     _buildMetricCol(
              //       label: LanguageHelper.translate('overall_progress'),
              //       value: '${(averageProgress * 100).toInt()}%',
              //       icon: Icons.donut_large_rounded,
              //       color: const Color(0xFF38B6FF),
              //     ),
              //     const Spacer(),
              //     Center(
              //       child: Container(
              //         width: 1,
              //         height: 40,
              //         color: Colors.white.withValues(alpha: 0.08),
              //       ),
              //     ),
              //     const Spacer(),
              //     _buildMetricCol(
              //       label: LanguageHelper.translate('overall_performance'),
              //       value:
              //           '${(averageScore * 100).toInt()}% ${LanguageHelper.translate('avg_suffix')}',
              //       icon: Icons.stars_rounded,
              //       color: const Color(0xFFE94057),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileTags() {
    final sortedTags = List<Tag>.from(mockTags)
      ..sort((a, b) => b.score.compareTo(a.score));

    final previewTags = sortedTags.take(10).toList();
    final remainingCount = sortedTags.length - previewTags.length;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final tag in previewTags)
          _buildProfileTagItem(
            label: tag.name,
            icon: Icons.emoji_events_rounded,
            onTap: () => _showAchievementsBottomSheet(context),
          ),
        if (remainingCount > 0)
          InkWell(
            onTap: () => _showAchievementsBottomSheet(context),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.blue.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                '+$remainingCount more',
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProfileTagItem({
    required String label,
    IconData? icon,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 130),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.blue.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 12, color: Colors.blue),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                label,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAchievementsBottomSheet(BuildContext context) {
    final sorted = List<Tag>.from(mockTags)
      ..sort((a, b) => b.score.compareTo(a.score));
    final top10 = sorted.take(10).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF141923),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            border: Border(top: BorderSide(color: Colors.white12, width: 1)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Column(
                children: [
                  // Drag indicator
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            LanguageHelper.translate('topics_you_excel_at'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white12, height: 1),
                  // Grid of top 10 topics
                  Expanded(
                    child: GridView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(24),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 400,
                            mainAxisExtent: 90,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: top10.length,
                      itemBuilder: (context, index) {
                        final tag = top10[index];
                        return _buildExcelTopicCard(tag, index + 1);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildExcelTopicCard(Tag tag, int rank) {
    Color rankColor;
    if (rank == 1) {
      rankColor = const Color(0xFFFFD700); // Gold
    } else if (rank == 2) {
      rankColor = const Color(0xFFC0C0C0); // Silver
    } else if (rank == 3) {
      rankColor = const Color(0xFFCD7F32); // Bronze
    } else {
      rankColor = Colors.white54;
    }

    Color scoreColor;
    String scoreLevel;
    if (tag.score < 30) {
      scoreColor = Colors.redAccent;
      scoreLevel = 'Beginner';
    } else if (tag.score < 70) {
      scoreColor = Colors.yellowAccent;
      scoreLevel = 'Intermediate';
    } else {
      scoreColor = Colors.greenAccent;
      scoreLevel = 'Expert';
    }

    Color competenceColor;
    IconData competenceIcon;
    if (tag.score < 30) {
      competenceColor = Colors.green;
      competenceIcon = Icons.local_florist_rounded;
    } else if (tag.score < 70) {
      competenceColor = Colors.yellow;
      competenceIcon = Icons.stars_rounded;
    } else {
      competenceColor = Colors.orange;
      competenceIcon = Icons.emoji_events_rounded;
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1D2633),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Rank Badge
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: rank <= 3
                  ? rankColor.withValues(alpha: 0.15)
                  : Colors.transparent,
              shape: BoxShape.circle,
              border: rank <= 3
                  ? Border.all(color: rankColor, width: 1.5)
                  : null,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  color: rankColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Title & Badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tag.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                // Competence pill
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(competenceIcon, size: 10, color: competenceColor),
                    const SizedBox(width: 4),
                    Text(
                      scoreLevel,
                      style: TextStyle(
                        color: competenceColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Reliability Progress Ring
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  value: tag.score / 100.0,
                  strokeWidth: 3,
                  backgroundColor: Colors.white12,
                  valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                ),
              ),
              Text(
                '${tag.score.toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildMetricCol({
  //   required String label,
  //   required String value,
  //   required IconData icon,
  //   required Color color,
  // }) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       Container(
  //         width: 30,
  //         height: 30,
  //         decoration: BoxDecoration(
  //           shape: BoxShape.circle,
  //           color: color.withValues(alpha: 0.1),
  //         ),
  //         child: Icon(icon, color: color, size: 15),
  //       ),
  //       const SizedBox(width: 12),
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             label,
  //             style: const TextStyle(
  //               color: Colors.white30,
  //               fontSize: 11,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //           const SizedBox(height: 2),
  //           Text(
  //             value,
  //             style: const TextStyle(
  //               color: Colors.white,
  //               fontSize: 15,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF0F1319),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B0F13), Color(0xFF141923)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withValues(alpha: 0.08),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE94057), Color(0xFFF27121)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFE94057,
                                ).withValues(alpha: 0.2),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              widget.username.isNotEmpty
                                  ? widget.username[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.username,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                LanguageHelper.translate('level'),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF38B6FF),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      _buildDrawerItem(
                        icon: Icons.dashboard_rounded,
                        title: LanguageHelper.translate('catalog_dashboard'),
                        selected: selectedTab == 'Catalog',
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withValues(alpha: 0.08),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      LanguageHelper.translate('workspace'),
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2631),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _activeWorkSpace,
                          dropdownColor: const Color(0xFF1E2631),
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.white54,
                          ),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: Colors.white70,
                          ),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _activeWorkSpace = newValue;
                              });
                            }
                          },
                          items: <String>['DEMO 1', 'DEMO 2']
                              .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: value == 'DEMO 1'
                                              ? const Color(0xFF0072FF)
                                              : const Color(0xFF8A2387),
                                        ),
                                        child: const Icon(
                                          Icons.school,
                                          size: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(value),
                                    ],
                                  ),
                                );
                              })
                              .toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      LanguageHelper.translate('language'),
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2631),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: LanguageHelper.currentLanguage,
                          dropdownColor: const Color(0xFF1E2631),
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.white54,
                          ),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: Colors.white70,
                          ),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                LanguageHelper.currentLanguage = newValue;
                              });
                            }
                          },
                          items: <String>['English', 'Español']
                              .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        value == 'English' ? '🇺🇸' : '🇪🇸',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(value),
                                    ],
                                  ),
                                );
                              })
                              .toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        if (widget.onLogout != null) widget.onLogout!();
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.logout_rounded,
                              color: Color(0xFFE94057),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              LanguageHelper.translate('logout'),
                              style: const TextStyle(
                                color: Color(0xFFE94057),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: InkWell(
                        onTap: () async {
                          final url = Uri.parse('https://eme.world');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            debugPrint('Could not launch $url');
                          }
                        },
                        child: Text(
                          LanguageHelper.translate('powered_by'),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white30,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF38B6FF).withValues(alpha: 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected
              ? const Color(0xFF38B6FF).withValues(alpha: 0.15)
              : Colors.transparent,
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: selected ? const Color(0xFF38B6FF) : Colors.white54,
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.white : Colors.white70,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
