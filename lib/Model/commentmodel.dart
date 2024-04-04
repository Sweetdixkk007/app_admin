class commentModel {
  String userId;
  String postId;
  String name;
  String userimage;
  String comment;

  commentModel({
    required this.userId,
    required this.postId,
    required this.name,
    required this.userimage,
    required this.comment,
  });

  factory commentModel.fromJson(Map<String, dynamic> json) => commentModel(
        userId: json['user_id'] ?? '',
        postId: json['post_id'] ?? '',
        name: json['name'] ?? '',
        userimage: json['image'] ?? '',
        comment: json['comment'] ?? '',
      );


}