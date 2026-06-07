import 'package:flutter/material.dart';
import 'package:uni_life_rsvp_exam/presentation/atoms/app_scaffold.dart';

class SignUpPage extends StatelessWidget {
  static const String routeName = '/sign-up';
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(body: Column(children: [Text('Sign Up')]));
  }
}
