import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmacy_web/constant/constant.dart';
import 'package:pharmacy_web/widgets/on_hover_fly.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/category.dart';

class ButtonDrug extends StatefulWidget {
  const ButtonDrug(this.cat);

  final Category cat;

  @override
  State<ButtonDrug> createState() => _ButtonDrugState();
}

class _ButtonDrugState extends State<ButtonDrug> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  bool isHover = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void goWhere(String route) {
    switch (route) {
      case 'A1':
        Get.toNamed('/more/A1');
        break;
      case 'A2':
        Get.toNamed('/more/A2');
        break;
      case 'camera':
        authController.checkSignin(() => Get.toNamed('/prescription'));
        break;
      case 'A4':
        launchUrl(
          Uri.parse(
              'https://www.google.com/maps/search/?api=1&query=Pharmacity'),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color = Colors.lightBlue;
    switch (widget.cat.type) {
      case 'A1':
        color = Colors.teal;
        break;
      case 'A2':
        color = Colors.lightBlue;
        break;
      case 'camera':
        color = Colors.deepPurple;
        break;
      case 'A4':
        color = Colors.pink;
        break;
    }
    return OnHoverFly(
      onTap: () => goWhere(widget.cat.type),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Container(
          width: 200,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 200,
                  width: 200,
                  child: Icon(
                    widget.cat.iconUrl,
                    size: 80,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  alignment: Alignment.center,
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.1),
                        color.withOpacity(0.4),
                        color.withOpacity(1),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Text(
                    widget.cat.title,
                    style: GoogleFonts.kanit(
                      wordSpacing: 3,
                      letterSpacing: 2,
                      color: Colors.tealAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
