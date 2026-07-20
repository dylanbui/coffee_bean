import 'package:db_core/db_core.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notify_message.g.dart';

@JsonSerializable()
class NotifyMessage extends Equatable {
  final int id;
  final int userId;
  final String userType;
  final int templateId;
  final String templateCode;
  final String templateNickname;
  final String templateContent;
  final int templateType;
  final Dictionary templateParams;
  final bool readStatus;
  final int? readTime;
  final int createTime;

  const NotifyMessage({
    required this.id,
    required this.userId,
    required this.userType,
    required this.templateId,
    required this.templateCode,
    required this.templateNickname,
    required this.templateContent,
    required this.templateType,
    required this.templateParams,
    required this.readStatus,
    this.readTime,
    required this.createTime,
  });

  factory NotifyMessage.fromJson(Map<String, dynamic> json) =>
      _$NotifyMessageFromJson(json);

  Map<String, dynamic> toJson() => _$NotifyMessageToJson(this);

  @override
  List<Object?> get props => [
        id,
        userId,
        userType,
        templateId,
        templateCode,
        templateNickname,
        templateContent,
        templateType,
        templateParams,
        readStatus,
        readTime,
        createTime,
      ];
}
