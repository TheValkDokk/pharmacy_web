import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/constant.dart';
import '../services/global.dart';
import 'app_bar_action.dart';

class HomeAppBar extends StatelessWidget with PreferredSizeWidget {
  const HomeAppBar({
    Key? key,
  }) : super(key: key);
  static double appBarHeight = 100;
  @override
  Widget build(BuildContext context) {
    final title = GestureDetector(
      onTap: () => toMain(),
      child: Center(
        child: Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Hero(
                  tag: Const.logoTag,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      height: 100,
                      color: Colors.white,
                      child: Image.asset(
                        Const.logo,
                        fit: BoxFit.fill,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ),
              ),
              if (authController.isLogged.value)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Hero(
                    tag: Const.titleTag,
                    child: Text(
                      Const.title,
                      style: TextStyle(
                          fontSize: 40, letterSpacing: 2, color: Colors.white),
                    ),
                  ),
                ),
              if (!authController.isLogged.value)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    Const.title,
                    style: TextStyle(
                      fontSize: 40,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              const SizedBox(width: 20),
            ],
          );
        }),
      ),
    );
    return AppBar(
      backgroundColor: const Color(0xFF0F62F9),
      automaticallyImplyLeading: false,
      toolbarHeight: appBarHeight,
      actions: [AppBarAction(title)],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);
}
