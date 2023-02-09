import 'package:casbin/casbin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rbac_casbin/core.dart';
import 'package:rbac_casbin/state_util.dart';
import '../view/login_view.dart';
import '../../../backend.dart';

class LoginController extends State<LoginView> implements MvcController {
  static late LoginController instance;
  late LoginView view;

  String username = '';
  String password = '';

  doLogin(String username, String password) async {
    var response = await Dio().post(
      "http://192.168.99.14:8080/api/login",
      options: Options(
        headers: {
          "Content-Type": "application/json",
        },
      ),
      data: {
        "username": username,
        "password": password,
      },
    );
    Map obj = response.data;
    if (obj["success"]) {
      final model = Model()..loadModelFromText(getModel());
      final enforcer = Enforcer.fromModelAndAdapter(model);

      getPolicy().split('\n').forEach((element) {
        final user = element.split(',')[1].trim();
        final permission = element.split(',').sublist(2);

        enforcer.addPermissionForUser(user, permission);
      });

      String namaRole = obj["data"]["data_role"]["nm_role"]
          .toLowerCase()
          .trim()
          .replaceAll(RegExp(r"\s+"), "");

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeView(
            namaRole: namaRole,
            enforcer: enforcer,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incorrect username or password'),
        ),
      );
    }
  }

  @override
  void initState() {
    instance = this;
    super.initState();
  }

  @override
  void dispose() => super.dispose();

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}
