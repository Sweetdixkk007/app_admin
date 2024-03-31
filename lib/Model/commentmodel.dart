class commentModel {
  String userId;
  String postId;
  String name;
  String image;
  String comment;

  commentModel({
    required this.userId,
    required this.postId,
    required this.name,
    required this.image,
    required this.comment,
  });

  factory commentModel.fromJson(Map<String, dynamic> json) => commentModel(
        userId: json['user_id'] ?? '',
        postId: json['post_id'] ?? '',
        name: json['name'] ?? '',
        image: json['image'] ?? '',
        comment: json['comment'] ?? '',
      );


}