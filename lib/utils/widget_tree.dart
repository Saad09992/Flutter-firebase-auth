import 'package:firebase_auth_app/controllers/auth_controller.dart';
import 'package:firebase_auth_app/pages/home_page.dart';
import 'package:firebase_auth_app/pages/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<AuthController>(
      builder: (controller) {
        if (controller.isLoading.value) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (controller.currentUser != null) {
          return const HomePage();
        } else {
          return const SignInPage();
        }
      },
    );
  }
}
