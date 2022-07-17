import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_web/pages/prescription/prescription.dart';

import 'controllers/app_controller.dart';
import 'controllers/auth_controller.dart';
import 'controllers/drug_controller.dart';
import 'controllers/order_controller.dart';
import 'controllers/page_controller.dart';
import 'firebase_options.dart';
import 'pages/drug_detail/drug_detail.dart';
import 'pages/login/login.dart';
import 'pages/order_detail/detail_order_page/detail_order.dart';
import 'pages/order_detail/order_detail.dart';
import 'pages/payment/payment.dart';
import 'widgets/app_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(CurrentOrderController());
  Get.put(AuthController());
  Get.put(AppController());
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
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const MainPage(),
        ),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(
          name: '/details/:drugId',
          page: () => const DrugDetail(),
          transition: Transition.downToUp,
        ),
        GetPage(
          name: '/orderHistory',
          page: () => const OrderHistoryList(),
          transition: Transition.downToUp,
        ),
        GetPage(
          name: '/checkout',
          page: () => const PaymentPage(),
          transition: Transition.cupertino,
        ),
        GetPage(
          name: '/orderDetail',
          page: () => const DetailOrder(),
          transition: Transition.cupertino,
        ),
        GetPage(
          name: '/prescription',
          page: () => const PrescriptionScreen(),
          transition: Transition.cupertino,
        ),
      ],
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
