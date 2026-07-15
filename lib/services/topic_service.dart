import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:testu_cl/services/auth_service.dart';
import '../models/topic.dart';
import '../models/tutorial.dart';

class TopicService {
  final http.Client _client;
  final String baseUrl;

  TopicService({
    http.Client? client,
    this.baseUrl = 'http://localhost.com:8080/mediadb/services/topic',
  }) : _client = client ?? http.Client();

  /// Fetches topics and nested tutorials from the specified API endpoint.
  /// If [endpointUrl] is provided, it overrides [baseUrl].
  /// If fetching fails and [fallbackToMock] is true, [mockTopics] will be returned.
  Future<List<Topic>> fetchTopics({bool fallbackToMock = true}) async {
    final targetUrl = "$baseUrl/topics.json";
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

  /// Fetches tutorials for a given [topicId].
  /// URL: $baseUrl/tutorials.json?entitytopic=$topicId
  Future<List<Tutorial>> fetchTutorialsForTopic(String topicId) async {
    final targetUrl = "$baseUrl/tutorials.json?entitytopic=$topicId";
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

  /// Fetches detailed sections, contents, and questions for a given tutorial ID.
  /// URL: $baseUrl/tutorial.json?entitytutorial=$tutorialId
  Future<TutorialDetail> fetchTutorialDetail(String tutorialId) async {
    final targetUrl = "$baseUrl/tutorial.json?entitytutorial=$tutorialId";
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
        print('TopicService error fetching tutorial detail from $targetUrl: $e');
      }
      rethrow;
    }
  }
}

