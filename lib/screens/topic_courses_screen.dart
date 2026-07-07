import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../widgets/course_card.dart';

class TopicCoursesScreen extends StatelessWidget {
  final Topic topic;

  const TopicCoursesScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;
    final mainColor = topic.gradientColors.isNotEmpty
        ? topic.gradientColors.first
        : const Color(0xFF38B6FF);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0B0F13), Color(0xFF141923), Color(0xFF0F1319)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Row with Back Button
              _buildHeader(context, mainColor),

              // Scrollable list of courses
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 40 : 20,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Topic Overview Details
                      _buildTopicBanner(context, mainColor),
                      const SizedBox(height: 32),

                      // Section Title
                      Text(
                        'COURSES IN THIS SUBJECT',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: mainColor,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // List of courses
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: topic.courses.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final course = topic.courses[index];
                          // We render the CourseCard widget
                          return CourseCard(course: course, isListMode: true);
                        },
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color mainColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161C24).withOpacity(0.4),
        border: const Border(
          bottom: BorderSide(color: Color(0xFF263238), width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70, size: 20),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: 8),
          Text(
            topic.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
        color: const Color(0xFF161C24).withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: topic.gradientColors,
                  ),
                ),
                child: Icon(
                  topic.icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.category,
                      style: TextStyle(
                        color: mainColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      topic.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TOTAL COURSES',
                      style: TextStyle(color: Colors.white30, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${topic.courses.length} Active Courses',
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 32,
                color: Colors.white.withOpacity(0.08),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TESTS PERFORMANCE',
                      style: TextStyle(color: Colors.white30, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(topic.averageScore * 100).toInt()}% Average Score',
                      style: TextStyle(color: mainColor, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white10),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Overall Topic Progress',
                style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w500),
              ),
              Text(
                '${(topic.progress * 100).toInt()}% Finished',
                style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: topic.progress,
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.06),
              valueColor: AlwaysStoppedAnimation<Color>(mainColor),
            ),
          ),
        ],
      ),
    );
  }
}
