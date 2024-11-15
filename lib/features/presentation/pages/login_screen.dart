import 'package:dairy_track_admin/features/presentation/getx/log_in_auth.dart';
import 'package:dairy_track_admin/features/presentation/pages/home/home.dart';
import 'package:dairy_track_admin/features/presentation/themes/themes.dart';
import 'package:dairy_track_admin/features/presentation/widgets/custom_text_button.dart';
import 'package:dairy_track_admin/features/presentation/widgets/custom_textformfiled.dart';
import 'package:dairy_track_admin/features/presentation/widgets/elevated_container.dart';
import 'package:dairy_track_admin/features/presentation/widgets/gap.dart';
import 'package:dairy_track_admin/features/presentation/widgets/text/bold_title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LogInAuth authController = Get.put(LogInAuth());

  @override
  Widget build(BuildContext context) {
    var width = Get.mediaQuery.size.width;
    return Scaffold(
      body: Obx(
        () {
          if (authController.isLoggedIn.value) {
            Future.microtask(
              () => Get.off(const Home()),
            );
          }
          return Container(
            decoration: Themes.linearGradiantDecoration,
            child: _loginForm(width),
          );
        },
      ),
    );
  }

  Center _loginForm(double width) {
    return Center(
      child: ElevatedContainer(
          child: SizedBox(
        width: width * .9,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BoldTitleText(text: 'Sign In'),
              const Gap(),
              CustomTextFormField(
                controller: userNameController,
                labelText: 'UserName',
              ),
              const Gap(),
              CustomTextFormField(
                controller: passwordController,
                labelText: 'Password',
                password: true,
              ),
              const Gap(),
              CustomTextButton(
                text: 'Sign In',
                onPressed: () {
                  authController.login(
                    userNameController.text.trim(),
                    passwordController.text.trim(),
                  );
                },
              )
            ],
          ),
        ),
      )),
    );
  }
}
