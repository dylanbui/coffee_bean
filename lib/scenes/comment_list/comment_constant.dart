enum CommentServerType {
  product,
  hub,
}

enum CommentSource {
  product(0, CommentServerType.product),
  post(1, CommentServerType.hub),
  course(2, CommentServerType.product),
  activity(3, CommentServerType.hub);

  final int value;
  final CommentServerType serverType;
  const CommentSource(this.value, this.serverType);
}

abstract interface class IComment {
  int get id;
  String get userNickname;
  String get userAvatar;
  String get content;
  DateTime? get createTime;
  List<String> get picUrls;
  int get scores;

  // Reply fields
  bool get replyStatus;
  String? get replyContent;
  DateTime? get replyTime;
}
