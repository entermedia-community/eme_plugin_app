import 'dart:convert';
import '../services/auth_service.dart';

enum MessageType {
  welcome,
  text,
  question,
  answer,
  asset,
  questioncontinue,
  usercomment,
  end,
  agentcomment,
}

class ChatMessage {
  final String? messageId;
  final String? channel;
  final String? userId;
  final String? userName;
  final String? topic;
  final String? message;
  final MessageType? messageType;
  final String? command;
  final String? replyToId;
  final String? functionName;
  final String? nextFunctionName;
  final int? createdAt;
  final Map<String, dynamic> rawJson;

  const ChatMessage({
    this.messageId,
    this.channel,
    this.userId,
    this.userName,
    this.topic,
    this.message,
    this.messageType,
    this.command,
    this.replyToId,
    this.functionName,
    this.nextFunctionName,
    this.createdAt,
    this.rawJson = const {},
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    int? parsedCreatedAt;
    final rawCreatedAt = json['createdat'] ?? json['createdAt'];
    if (rawCreatedAt is int) {
      parsedCreatedAt = rawCreatedAt;
    } else if (rawCreatedAt is String) {
      parsedCreatedAt = int.tryParse(rawCreatedAt);
    }

    final rawMessageType = json['messagetype']?.toString().toLowerCase();
    final messageType = MessageType.values.firstWhere(
      (element) => element.name.toLowerCase() == rawMessageType,
      orElse: () => MessageType.text,
    );

    Map<String, dynamic> rawJson;
    if (messageType == MessageType.question ||
        messageType == MessageType.asset) {
      final jsonStr = json['message']?.toString() ?? "{}";
      rawJson = Map<String, dynamic>.from(jsonDecode(jsonStr));
    } else {
      rawJson = Map<String, dynamic>.from(json);
    }

    return ChatMessage(
      messageId: (json['messageid'] ?? json['id'])?.toString(),
      channel: json['channel']?.toString(),
      userId: (json['user'] ?? json['userid'])?.toString(),
      userName: json['name']?.toString(),
      topic: json['topic']?.toString(),
      message: json['message']?.toString(),
      messageType: messageType,
      command: json['command']?.toString(),
      replyToId: (json['replytoid'] ?? json['replyToId'])?.toString(),
      functionName: (json['functionname'] ?? json['functionName'])?.toString(),
      nextFunctionName: (json['nextfunctionname'] ?? json['nextFunctionName'])
          ?.toString(),
      createdAt: parsedCreatedAt,
      rawJson: rawJson,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      if (messageId != null) 'messageid': messageId,
      if (channel != null) 'channel': channel,
      if (userId != null) 'userid': userId,
      if (userName != null) 'name': userName,
      if (topic != null) 'topic': topic,
      if (message != null) 'message': message,
      if (messageType != null) 'messagetype': messageType!.name,
      if (command != null) 'command': command,
      if (replyToId != null) 'replytoid': replyToId,
      if (functionName != null) 'functionname': functionName,
      if (nextFunctionName != null) 'nextfunctionname': nextFunctionName,
      if (createdAt != null) 'createdat': createdAt,
    };
    return map;
  }

  bool get isMessageRemoved => command == 'messageremoved';
  bool get isKeepAlive => command == 'keepalive';

  String get text {
    if (messageType == MessageType.question && message != null) {
      try {
        final decoded = jsonDecode(message!);
        if (decoded is Map<String, dynamic>) {
          return decoded['question']?.toString() ??
              decoded['text']?.toString() ??
              decoded['title']?.toString() ??
              message!;
        }
      } catch (_) {}
    }
    return message ?? '';
  }

  bool get isUser =>
      userId == AuthService.userId ||
      messageType == MessageType.usercomment ||
      messageType == MessageType.answer;

  bool get isAI => !isUser;

  String get sender => isUser ? 'user' : 'ai';

  String? get sectionTitle {
    if (messageType == MessageType.question && message != null) {
      try {
        final decoded = jsonDecode(message!);
        if (decoded is Map<String, dynamic>) {
          return decoded['sectiontitle']?.toString() ??
              decoded['section_title']?.toString();
        }
      } catch (_) {}
    }
    return null;
  }

  String? get sectionContentText {
    if (messageType == MessageType.question && message != null) {
      try {
        final decoded = jsonDecode(message!);
        if (decoded is Map<String, dynamic>) {
          return decoded['sectioncontent']?.toString() ??
              decoded['section_content']?.toString();
        }
      } catch (_) {}
    }
    return null;
  }

  bool? get isCorrect {
    if (rawJson['iscorrect'] is bool) return rawJson['iscorrect'] as bool;
    if (rawJson['correct'] is bool) return rawJson['correct'] as bool;
    if (rawJson['success'] is bool) return rawJson['success'] as bool;
    if (rawJson['is_correct'] is bool) return rawJson['is_correct'] as bool;
    return null;
  }

  String get selectedOptionText {
    if (rawJson['selected_option'] != null) {
      return rawJson['selected_option'].toString();
    }
    if (rawJson['option_text'] != null) {
      return rawJson['option_text'].toString();
    }
    if (message != null) {
      if (message!.startsWith('Selected: ')) {
        final endIdx = message!.indexOf(' (Confidence:');
        if (endIdx != -1) {
          return message!.substring('Selected: '.length, endIdx);
        }
        return message!.substring('Selected: '.length);
      }
      return message!;
    }
    return '';
  }

  String get actionButtonLabel {
    if (rawJson['button_text'] != null) {
      return rawJson['button_text'].toString();
    }
    if (rawJson['label'] != null) {
      return rawJson['label'].toString();
    }
    if (messageType == MessageType.welcome) return 'Start';
    if (messageType == MessageType.questioncontinue) return 'Continue';
    return text.isNotEmpty ? text : 'Action';
  }

  ChatMessage copyWith({
    String? messageId,
    String? channel,
    String? userId,
    String? userName,
    String? topic,
    String? message,
    MessageType? messageType,
    String? command,
    String? replyToId,
    String? functionName,
    String? nextFunctionName,
    int? createdAt,
    Map<String, dynamic>? rawJson,
  }) {
    return ChatMessage(
      messageId: messageId ?? this.messageId,
      channel: channel ?? this.channel,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      topic: topic ?? this.topic,
      message: message ?? this.message,
      messageType: messageType ?? this.messageType,
      command: command ?? this.command,
      replyToId: replyToId ?? this.replyToId,
      functionName: functionName ?? this.functionName,
      nextFunctionName: nextFunctionName ?? this.nextFunctionName,
      createdAt: createdAt ?? this.createdAt,
      rawJson: rawJson ?? this.rawJson,
    );
  }
}
