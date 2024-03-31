class postModel {
    String userId;
    String postId;
    String image;
    String topic;
    String descrip;

    postModel({
        required this.userId,
        required this.postId,
        required this.image,
        required this.topic,
        required this.descrip,
    });

    factory postModel.fromJson(Map<String, dynamic> json) => postModel(
        userId: json["user_id"],
        postId: json["post_id"],
        image: json["image"],
        topic: json["topic"],
        descrip: json["descrip"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "post_id": postId,
        "image": image,
        "topic": topic,
        "descrip": descrip,
    };
}