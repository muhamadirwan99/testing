import 'package:casbin/casbin.dart';
import 'package:flutter/material.dart';
import 'package:rbac_casbin/core.dart';
import '../controller/home_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatefulWidget {
  final String namaRole;
  final Enforcer enforcer;

  HomeView({Key? key, required this.namaRole, required this.enforcer})
      : super(key: key);

  Widget build(context, HomeController controller) {
    controller.view = this;

    print(namaRole);
    print(enforcer);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              enforcer.enforce([namaRole, '3', 'read'])
                  ? Text('Menu verifikator')
                  : Container(),
              enforcer.enforce([namaRole, '2', 'read'])
                  ? Text('Menu progresif kolektif')
                  : Container(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                ),
                onPressed: () {
                  _launchUrl(Uri.parse(
                      "https://ebook.bapenda.jabarprov.go.id/jip122022/"));
                },
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchUrl(_url) async {
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  @override
  State<HomeView> createState() => HomeController();
}
