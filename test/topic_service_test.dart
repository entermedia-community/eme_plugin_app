import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testu_cl/models/topic.dart';
import 'package:testu_cl/models/tutorial.dart';
import 'package:testu_cl/services/topic_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'entermediakey': 'testkey',
      'user': 'testuser',
    });
  });

  group('Topic & Tutorial Models JSON Parsing', () {
    test('TutorialProgress.fromJson parses correctly', () {
      final jsonMap = {
        'beginnerprogress': 0.8,
        'competentprogress': 0.6,
        'expertprogress': 0.4,
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
        'id': 'tut100',
        'title': 'Test Tutorial',
        'entitytopicid': 'topic_test',
        'progress': {
          'beginnerprogress': 1.0,
          'competentprogress': 1.0,
          'expertprogress': 1.0,
        },
        'answersforgotten': 0.1,
        'lastreviewed': '2026-07-01T12:00:00.000Z',
      };

      final tutorial = Tutorial.fromJson(jsonMap);

      expect(tutorial.id, equals('tut100'));
      expect(tutorial.title, equals('Test Tutorial'));
      expect(tutorial.topicId, equals('topic_test'));
      expect(tutorial.answersForgotten, equals(0.1));
      expect(tutorial.progress.getEfficiency(), equals(Efficiency.expert));
    });

    test('Topic.fromJson parses correctly with nested tutorials', () {
      final jsonMap = {
        'id': 'topic1',
        'title': 'Test Topic',
        'thumbnail': 'https://example.com/thumb.png',
        'completed': 3,
        'tutorials': 5,
      };

      final topic = Topic.fromJson(jsonMap);

      expect(topic.id, equals('topic1'));
      expect(topic.title, equals('Test Topic'));
      expect(topic.thumbnail, equals('https://example.com/thumb.png'));
      expect(topic.completedTutorials, equals(3));
      expect(topic.totalTutorials, equals(5));
    });
  });

  group('TopicService API Fetching', () {
    test(
      'fetchTopics returns parsed topics on HTTP 200 list response',
      () async {
        final mockResponseData = {
          'topics': [
            {
              'id': 'topic_api',
              'title': 'API Topic',
              'thumbnail': 'https://example.com/img.png',
              'completed': 5,
              'tutorials': 10,
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

    test(
      'fetchTutorialsForTopic returns parsed tutorials on HTTP 200',
      () async {
        final mockResponseData = {
          'tutorials': [
            {
              'id': 'tut1',
              'title': 'Topic Tutorial 1',
              'entitytopicid': 'topic123',
              'answersforgotten': 0.15,
              'lastreviewed': '2026-07-01T00:00:00.000',
            },
          ],
        };

        final mockClient = MockClient((request) async {
          expect(
            request.url.toString(),
            contains('/tutorials.json?entitytopic=topic123'),
          );
          return http.Response(
            json.encode(mockResponseData),
            200,
            headers: {'content-type': 'application/json'},
          );
        });

        final service = TopicService(client: mockClient);
        final tutorials = await service.fetchTutorialsForTopic('topic123');

        expect(tutorials.length, equals(1));
        expect(tutorials.first.id, equals('tut1'));
        expect(tutorials.first.title, equals('Topic Tutorial 1'));
        expect(tutorials.first.topicId, equals('topic123'));
      },
    );
  });
}
