import 'package:firebase_auth_app/controllers/auth_controller.dart';
import 'package:get/get.dart';

class InitDependencies extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
  }
}
