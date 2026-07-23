import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:testu_cl/services/auth_service.dart';
import '../models/topic.dart';
import '../models/tutor_channel.dart';
import '../models/tutorial.dart';

class TopicService {
  final http.Client _client;
  final String siteRoot;

  TopicService({
    http.Client? client,
    this.siteRoot = 'http://localhost.com:8080/site',
  }) : _client = client ?? http.Client();

  Future<List<Topic>> fetchTopics({bool fallbackToMock = true}) async {
    final targetUrl = "$siteRoot/mediadb/services/topic/topics.json";
    final uri = Uri.parse(targetUrl);

    try {
      final Map<String, String> credentials =
          await AuthService.getCredentials();
      final String token = credentials['entermediakey']!;
      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-tokentype': 'entermedia',
          'X-token': token,
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        List<dynamic> jsonList;

        if (decoded is Map<String, dynamic>) {
          jsonList = decoded['topics'] as List<dynamic>? ?? [];
        } else {
          throw FormatException('Unexpected response format from $targetUrl');
        }

        return jsonList
            .map((item) => Topic.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Failed to fetch topics. Server returned HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('TopicService error fetching from $targetUrl: $e');
      }
      rethrow;
    }
  }

  Future<List<Tutorial>> fetchTutorialsForTopic(String topicId) async {
    final targetUrl =
        "$siteRoot/mediadb/services/topic/tutorials.json?entitytopic=$topicId";
    final uri = Uri.parse(targetUrl);

    try {
      final Map<String, String> credentials =
          await AuthService.getCredentials();
      final String token = credentials['entermediakey']!;
      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-tokentype': 'entermedia',
          'X-token': token,
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        List<dynamic> jsonList;

        if (decoded is List) {
          jsonList = decoded;
        } else if (decoded is Map<String, dynamic>) {
          jsonList =
              decoded['tutorials'] as List<dynamic>? ??
              decoded['data'] as List<dynamic>? ??
              [];
        } else {
          throw FormatException('Unexpected response format from $targetUrl');
        }

        return jsonList
            .map((item) => Tutorial.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Failed to fetch tutorials. Server returned HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('TopicService error fetching tutorials from $targetUrl: $e');
      }
      rethrow;
    }
  }

  Future<TutorialDetail> fetchTutorialDetail(String tutorialId) async {
    final targetUrl =
        "$siteRoot/mediadb/services/topic/tutorial.json?entitytutorial=$tutorialId";
    final uri = Uri.parse(targetUrl);

    try {
      final Map<String, String> credentials =
          await AuthService.getCredentials();
      final String token = credentials['entermediakey']!;
      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-tokentype': 'entermedia',
          'X-token': token,
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) {
          return TutorialDetail.fromJson(decoded);
        } else {
          throw FormatException('Unexpected response format from $targetUrl');
        }
      } else {
        throw Exception(
          'Failed to fetch tutorial details. Server returned HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(
          'TopicService error fetching tutorial detail from $targetUrl: $e',
        );
      }
      rethrow;
    }
  }

  Future<List<TutorChannel>> fetchTutorChannels(String tutorialId) async {
    final targetUrl =
        "$siteRoot/find/views/modules/entitytutorial/editors/aichatsearch/tutorsessions.json?tutorialid=$tutorialId";
    final uri = Uri.parse(targetUrl);

    try {
      final Map<String, String> credentials =
          await AuthService.getCredentials();
      final String token = credentials['entermediakey']!;
      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-tokentype': 'entermedia',
          'X-token': token,
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) {
          final channelsList = decoded['channels'] as List<dynamic>? ?? [];
          return channelsList
              .map(
                (item) => TutorChannel.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        } else {
          throw FormatException('Unexpected response format from $targetUrl');
        }
      } else {
        throw Exception(
          'Failed to fetch tutor channels. Server returned HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('TopicService error fetching tutor channels from $targetUrl: $e');
      }
      rethrow;
    }
  }

  Future<void> startTutorial(String tutorialId, String channel) async {
    final targetUrl =
        "$siteRoot/find/views/modules/entitytutorial/editors/aichatsearch/index.html";
    final uri = Uri.parse(targetUrl);

    try {
      final Map<String, String> credentials =
          await AuthService.getCredentials();
      final String token = credentials['entermediakey']!;
      final response = await _client.post(
        uri,
        body:
            'context_tutorialid=$tutorialId&functionname=chat_tutor_welcome&currentscenario=chat_tutor',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          'X-tokentype': 'entermedia',
          'X-token': token,
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch tutor channels. Server returned HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('TopicService error fetching tutor channels from $targetUrl: $e');
      }
      rethrow;
    }
  }

  Future<void> submitAnswer({
    required String channel,
    required String questionId,
    required String selectedOption,
    required String confidence,
  }) async {
    final targetUrl =
        "$siteRoot/find/views/modules/entitytutorial/editors/aichatsearch/index.html";
    final uri = Uri.parse(targetUrl);
    try {
      final Map<String, String> credentials =
          await AuthService.getCredentials();
      final String token = credentials['entermediakey']!;

      String body = 'currentscenario=chat_tutor&functionname=chat_tutor_answer';
      body += '&context_channelid=$channel';
      body += '&context_questionid=$questionId';
      body += '&context_selectedoption=$selectedOption';
      body += '&context_confidence=$confidence';

      final response = await _client.post(
        uri,
        body: body,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          'X-tokentype': 'entermedia',
          'X-token': token,
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch tutor channels. Server returned HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('TopicService error fetching tutor channels from $targetUrl: $e');
      }
      rethrow;
    }
  }
}
