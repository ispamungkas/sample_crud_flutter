import 'dart:convert';

UpdateUserResponse updateUserResponseFromJson(String str) => UpdateUserResponse.fromJson(json.decode(str));

String updateUserResponseToJson(UpdateUserResponse data) => json.encode(data.toJson());

class UpdateUserResponse {
    String name;
    String job;
    DateTime updatedAt;

    UpdateUserResponse({
        required this.name,
        required this.job,
        required this.updatedAt,
    });

    factory UpdateUserResponse.fromJson(Map<String, dynamic> json) => UpdateUserResponse(
        name: json["name"],
        job: json["job"],
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "job": job,
        "updatedAt": updatedAt.toIso8601String(),
    };
}