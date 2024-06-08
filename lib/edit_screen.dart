import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_crud/UpdateUserResponse.dart';
import 'package:http/http.dart' as http;

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final namaController = TextEditingController();
  final jobController = TextEditingController();

  Future<UpdateUserResponse>? result;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Edit Data"),
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
      ),
    );
  }

  Future<UpdateUserResponse> postDataUser() async {
    final body = {"name": namaController.text, "job": jobController.text};
    final uri = Uri.parse("https://reqres.in/api/users/2");
    final response = await http.put(
      uri,
      body: body,
    );

    if (response.statusCode == 200) {
      var bodyResponse = jsonDecode(response.body);
      var userModel = UpdateUserResponse.fromJson(bodyResponse);
      return userModel;
    } else {
      throw Exception('Failed to update user.');
    }
  }

  FutureBuilder<UpdateUserResponse> setLayout() {
    return FutureBuilder(
        future: result,
        builder: (context, snap) {
          if (snap.hasData) {
            return Text("update successfully with data:  ${snap.data!.name} ${snap.data!.job}");
          } else if (snap.hasError) {
            print("error");
            return Text("${snap.error.toString()}");
          }
          return const CircularProgressIndicator();
        });
  }
}