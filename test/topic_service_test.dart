import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:testu_cl/models/topic.dart';
import 'package:testu_cl/models/tutorial.dart';
import 'package:testu_cl/services/topic_service.dart';

void main() {
  group('Topic & Tutorial Models JSON Parsing', () {
    test('TutorialProgress.fromJson parses correctly', () {
      final jsonMap = {
        'beginnerProgress': 0.8,
        'competentProgress': 0.6,
        'expertProgress': 0.4,
      };

      final progress = TutorialProgress.fromJson(jsonMap);

      expect(progress.beginnerProgress, equals(0.8));
      expect(progress.competentProgress, equals(0.6));
      expect(progress.expertProgress, equals(0.4));
      expect(progress.getAverageProgress(), closeTo(0.6, 0.001));
      expect(progress.getEfficiency(), equals(Efficiency.competent));
    });

    test('Tutorial.fromJson parses correctly', () {
      final jsonMap = {
        'title': 'Test Tutorial',
        'category': 'Testing',
        'progress': {
          'beginnerProgress': 1.0,
          'competentProgress': 1.0,
          'expertProgress': 1.0,
        },
        'answersForgotten': 0.1,
        'lastReviewed': '2026-07-01T12:00:00.000Z',
      };

      final tutorial = Tutorial.fromJson(jsonMap);

      expect(tutorial.title, equals('Test Tutorial'));
      expect(tutorial.category, equals('Testing'));
      expect(tutorial.answersForgotten, equals(0.1));
      expect(tutorial.progress.getEfficiency(), equals(Efficiency.expert));
    });

    test('Topic.fromJson parses correctly with nested tutorials', () {
      final jsonMap = {
        'title': 'Test Topic',
        'thumbnail': 'https://example.com/thumb.png',
        'completedTutorials': 3,
        'tutorial': [
          {
            'title': 'Sub Tutorial 1',
            'category': 'Test Topic',
            'progress': {
              'beginnerProgress': 0.5,
              'competentProgress': 0.5,
              'expertProgress': 0.5,
            },
            'answersForgotten': 0.2,
            'lastReviewed': '2026-07-10T00:00:00.000',
          },
        ],
      };

      final topic = Topic.fromJson(jsonMap);

      expect(topic.title, equals('Test Topic'));
      expect(topic.thumbnail, equals('https://example.com/thumb.png'));
      expect(topic.completedTutorials, equals(3));
      expect(topic.tutorial.length, equals(1));
      expect(topic.tutorial.first.title, equals('Sub Tutorial 1'));
    });
  });

  group('TopicService API Fetching', () {
    test(
      'fetchTopics returns parsed topics on HTTP 200 list response',
      () async {
        final mockResponseData = [
          {
            'title': 'API Topic',
            'thumbnail': 'https://example.com/img.png',
            'completedTutorials': 5,
            'tutorial': [],
          },
        ];

        final mockClient = MockClient((request) async {
          return http.Response(
            json.encode(mockResponseData),
            200,
            headers: {'content-type': 'application/json'},
          );
        });

        final service = TopicService(client: mockClient);
        final topics = await service.fetchTopics(fallbackToMock: false);

        expect(topics.length, equals(1));
        expect(topics.first.title, equals('API Topic'));
        expect(topics.first.completedTutorials, equals(5));
      },
    );

    test(
      'fetchTopics returns parsed topics on HTTP 200 map envelope response',
      () async {
        final mockResponseData = {
          'topics': [
            {
              'title': 'Enveloped Topic',
              'thumbnail': 'https://example.com/env.png',
              'completedTutorials': 2,
              'tutorial': [],
            },
          ],
        };

        final mockClient = MockClient((request) async {
          return http.Response(
            json.encode(mockResponseData),
            200,
            headers: {'content-type': 'application/json'},
          );
        });

        final service = TopicService(client: mockClient);
        final topics = await service.fetchTopics(fallbackToMock: false);

        expect(topics.length, equals(1));
        expect(topics.first.title, equals('Enveloped Topic'));
      },
    );

    test(
      'fetchTopics falls back to mockTopics on HTTP 500 when fallbackToMock is true',
      () async {
        final mockClient = MockClient((request) async {
          return http.Response('Server Error', 500);
        });

        final service = TopicService(client: mockClient);
        final topics = await service.fetchTopics(fallbackToMock: true);

        expect(topics, equals(mockTopics));
      },
    );

    test(
      'fetchTopics rethrows exception on error when fallbackToMock is false',
      () async {
        final mockClient = MockClient((request) async {
          return http.Response('Server Error', 500);
        });

        final service = TopicService(client: mockClient);

        expect(
          () async => await service.fetchTopics(fallbackToMock: false),
          throwsA(isA<Exception>()),
        );
      },
    );
  });
}
