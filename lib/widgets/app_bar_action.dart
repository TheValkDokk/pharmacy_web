import 'package:badges/badges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_web/constant/constant.dart';
import 'package:pharmacy_web/services/auth_service.dart';

import '../pages/cart/cart_window.dart';
import '../pages/login/login.dart';

class AppBarAction extends StatelessWidget {
  const AppBarAction(this.title);

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: Get.width * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Obx(() {
                    final isLog = authController.isLogged.value;
                    User? user;
                    if (isLog) {
                      user = authController.firebaseUser.value;
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (isLog)
                          Text(
                            '${user!.displayName.toString()} |',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        TextButton(
                          onPressed: () {
                            isLog
                                ? AuthService().logoutGoogle()
                                : Get.toNamed(LoginPage.routeName);
                          },
                          child: Text(
                            isLog ? 'Logout' : 'Login',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                AppBarActionBar(title: title),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppBarActionBar extends StatelessWidget {
  const AppBarActionBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          title,
          InkWell(
            onTap: () {},
            onHover: (value) {
              if (value) {
                Get.snackbar('Category Hover', 'You hover',
                    snackPosition: SnackPosition.BOTTOM);
              } else {
                Get.closeCurrentSnackbar();
              }
            },
            child: Container(
              width: Get.width * 0.1,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                  Text(
                    'Category',
                    style: TextStyle(color: Colors.black),
                  ),
                  Icon(
                    Icons.arrow_drop_down_outlined,
                    color: Colors.black,
                  )
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            width: Get.width * 0.4,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: const TextField(
              decoration: InputDecoration(
                  fillColor: Colors.red,
                  border: InputBorder.none,
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey),
                  suffixIcon: Icon(Icons.search)),
            ),
          ),
          InkWell(
            onTap: () {
              authController.checkSignin(() {
                Get.defaultDialog(
                  title: 'Cart',
                  content: const CartWindow(),
                );
              });
            },
            child: Obx(() {
              final isLog = authController.isLogged.value;
              final count =
                  isLog ? currentOrderController.cartCount.value.toString() : 0;
              return Badge(
                badgeContent: Text(count.toString()),
                child: Container(
                  alignment: Alignment.center,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFF003CBF),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Text(
                        'Cart',
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(
                        Icons.shopping_bag_rounded,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
