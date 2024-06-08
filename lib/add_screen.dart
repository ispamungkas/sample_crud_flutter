import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_crud/PostUserResponse.dart';
import 'package:http/http.dart' as http;

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final namaController = TextEditingController();
  final jobController = TextEditingController();

  Future<PostUserResponse>? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Tanbah Data"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: TextFormField(
                controller: namaController,
                decoration: const InputDecoration(hintText: "Masukan Nama"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: TextFormField(
                controller: jobController,
                decoration: const InputDecoration(hintText: "Masukan Nama"),
              ),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  result = postDataUser();
                });
              },
              child: Text("Tambah"),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: result == null ? Text("null") : setLayout()),
          ],
        ),
      ),
    );
  }

  Future<PostUserResponse> postDataUser() async {
    final body = {"name": namaController.text, "job": jobController.text};
    final uri = Uri.parse("https://reqres.in/api/users");
    final response = await http.post(
      uri,
      body: body,
    );

    if (response.statusCode == 201) {
      var bodyResponse = jsonDecode(response.body);
      var userModel = PostUserResponse.fromJson(bodyResponse);
      return userModel;
    } else {
      throw Exception('Failed to create user.');
    }
  }

  FutureBuilder<PostUserResponse> setLayout() {
    return FutureBuilder(
        future: result,
        builder: (context, snap) {
          if (snap.hasData) {
            return Text("${snap.data!.name} ${snap.data!.job}");
          } else if (snap.hasError) {
            print("error");
            return Text("${snap.error.toString()}");
          }
          return const CircularProgressIndicator();
        });
  }
}
