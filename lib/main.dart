import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_crud/UserModel.dart';
import 'package:test_crud/add_screen.dart';
import 'package:test_crud/edit_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Call Api Session'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<String>? result;

  @override
  Widget build(BuildContext context) {
    showResult(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, datas) {
          if (datas.hasData) {
            return ListView.builder(
              itemCount: datas.data!.data.length,
              itemBuilder: (context, index) {
                var info = datas.data!.data[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    info.avatar,
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text("${info.firstName} ${info.lastName}")
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  result = deleteUser(info.id); 
                                });
                              },
                              child: const Icon(
                                Icons.delete,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Placeholder();
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddUser(),
            ),
          );
        },
        child: Text("Tambah User"),
      ),
    );
  }

  Future<UserModel> getData() async {
    final uri = Uri.parse("https://reqres.in/api/users");
    final response = await http.get(uri);

    var body = jsonDecode(response.body);
    var userModel = UserModel.fromJson(body);
    return userModel;
  }

  Future<String> deleteUser(int id) async {
    final uri = Uri.parse("https://reqres.in/api/users/$id");
    final response = await http.delete(
      uri,
    );

    if (response.statusCode == 204) {
      print("berhasil");
      return "Berhasil Dihapus";
    } else {
      throw Exception('Failed to delete user.');
    }
  }

   void showResult(BuildContext con) async {
      String? ce = await result;
      if (ce != null) {
        _showToast(con, ce);
      } else {
        _showToast(con, "error");
      }
   }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(label: 'Tutup', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
