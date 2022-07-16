import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/auth_controller.dart';
import 'controllers/drug_controller.dart';
import 'controllers/order_controller.dart';
import 'controllers/page_controller.dart';
import 'firebase_options.dart';
import 'pages/drug_detail/drug_detail.dart';
import 'pages/login/login.dart';
import 'widgets/app_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(CurrentOrderController());
  Get.put(AuthController());
  Get.put(DrugController(), permanent: true);
  Get.put(PageViewController(), permanent: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(fontFamily: 'Kanit'),
      title: 'Material App',
      routes: {
        MainPage.routeName: (context) => const MainPage(),
        LoginPage.routeName: (context) => const LoginPage(),
        DrugDetail.routeName: (context) => const DrugDetail(),
      },
      initialRoute: MainPage.routeName,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final PageViewController page = Get.find();
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Obx(
        () => Center(
          child: SizedBox(
            width: Get.width * 0.8,
            child: page.getScreenWidget(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          int i = page.pageIndex.value;
          if (i < 3) {
            page.pageIndex.value++;
          } else {
            page.pageIndex.value = 0;
          }
        },
        child: const Icon(Icons.ad_units),
      ),
    );
  }
}
