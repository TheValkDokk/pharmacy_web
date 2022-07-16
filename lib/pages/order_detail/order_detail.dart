import 'package:flutter/material.dart';
import 'package:pharmacy_web/widgets/app_bar.dart';

class OrderDetail extends StatelessWidget {
  const OrderDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeAppBar(),
      body: Text('OrderDetail'),
    );
  }
}
