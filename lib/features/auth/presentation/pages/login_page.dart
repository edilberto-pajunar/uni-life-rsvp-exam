import 'package:flutter/material.dart';
import 'package:uni_life_rsvp_exam/presentation/atoms/app_scaffold.dart';

class LoginPage extends StatelessWidget {
  static const String routeName = '/login';
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(body: Column(children: [Text('Login')]));
  }
}
