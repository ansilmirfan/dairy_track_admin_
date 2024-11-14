import 'package:dairy_track_admin/presentation/widgets/custom_snackbar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class LogInAuth extends GetxController {
  var isLoggedIn = false.obs;

  void login(String user, String pass) {
    String admin = dotenv.env['USER_NAME'] ?? '';
    String passWord = dotenv.env['PASSWORD'] ?? '';
    if (user.trim().isEmpty && pass.trim().isEmpty) {
      showCustomSnackbar(
        title: "Login Failed",
        message: "Username and password are required.",
        isSuccess: false,
      );
    } else if (user == admin && pass == passWord) {
      isLoggedIn.value = true;

      showCustomSnackbar(
        title: "Login Successful",
        message: "Welcome back",
        isSuccess: true,
      );
    } else {
      isLoggedIn.value = false;
      showCustomSnackbar(
          title: "Login Failed",
          message: "Incorrect username or password.",
          isSuccess: false);
    }
  }
}
