import 'dart:convert';

PostUserResponse postUserResponseFromJson(String str) => PostUserResponse.fromJson(json.decode(str));

String postUserResponseToJson(PostUserResponse data) => json.encode(data.toJson());

class PostUserResponse {
    String name;
    String job;
    String id;
    DateTime createdAt;

    PostUserResponse({
        required this.name,
        required this.job,
        required this.id,
        required this.createdAt,
    });

    factory PostUserResponse.fromJson(Map<String, dynamic> json) => PostUserResponse(
        name: json["name"],
        job: json["job"],
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "job": job,
        "id": id,
        "createdAt": createdAt.toIso8601String(),
    };
}
