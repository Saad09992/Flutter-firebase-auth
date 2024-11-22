import 'package:firebase_auth_app/pages/home_page.dart';
import 'package:firebase_auth_app/pages/register_page.dart';
import 'package:firebase_auth_app/pages/sign_in_page.dart';
import 'package:firebase_auth_app/utils/widget_tree.dart';
import 'package:flutter/material.dart';
import './routes_name.dart';

class Routes {
  // generateRoute method
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // the settings contain the route and displays the page accrdingly
    switch (settings.name) {
      case RoutesName.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomePage());
      case RoutesName.signup:
        return MaterialPageRoute(
            builder: (BuildContext context) => const RegisterPage());
      case RoutesName.widgetTree:
        return MaterialPageRoute(
            builder: (BuildContext context) => const WidgetTree());
      case RoutesName.signin:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SignInPage());
      // display this if route is invalid
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text("No route defined"),
            ),
          );
        });
    }
  }
}
