import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pharmacy_web/addons/loading.dart';
import 'package:pharmacy_web/constant/constant.dart';

import '../../addons/fade_route.dart';
import '../../main.dart';
import '../../services/auth_service.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
        title: Const.title,
        logo: const AssetImage(Const.logo),
        titleTag: Const.titleTag,
        logoTag: Const.logoTag,
        navigateBackAfterRecovery: true,
        onConfirmRecover: AuthService().signupConfirm,
        onConfirmSignup: AuthService().signupConfirm,
        loginProviders: [
          LoginProvider(
            button: Buttons.google,
            label: 'Sign in with Google',
            callback: () async {
              showLoading('Signing in...');
              await AuthService()
                  .loginWithGoogle()
                  .then((value) => dissmissLoading());
              return null;
            },
            providerNeedsSignUpCallback: () {
              return Future.value(true);
            },
          ),
          LoginProvider(
            icon: FontAwesomeIcons.instagram,
            label: 'Instagram',
            callback: () async {
              await Future.delayed(const Duration(seconds: 1));
              return null;
            },
          ),
          LoginProvider(
            icon: FontAwesomeIcons.facebookF,
            label: 'Facebook',
            callback: () async {
              await Future.delayed(const Duration(seconds: 1));
              return null;
            },
          ),
        ],
        theme: LoginTheme(
          pageColorDark: const Color(0xFF0F62F9),
          pageColorLight: const Color(0xFF0F62F9).withOpacity(0.1),
        ),
        onLogin: (data) {
          return AuthService().loginUser(data);
        },
        onRecoverPassword: AuthService().recoverPassword,
        onSignup: (data) {
          return AuthService().signupUser(data);
        },
        userValidator: (value) {
          if (value!.isEmpty) {
            return "Can not be empty";
          }
          return null;
        },
        passwordValidator: (value) {
          if (value!.isEmpty) {
            return 'Password is empty';
          }
          return null;
        },
        onSubmitAnimationCompleted: () {
          Navigator.pushReplacement(
            context,
            FadeInRoute(
              routeName: MainPage.routeName,
              page: const MainPage(),
            ),
          );
        },
      ),
    );
  }
}
