import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../../icons/icon.dart';

class TimeLineOrder extends StatelessWidget {
  const TimeLineOrder(this.status);

  final String status;

  IndicatorStyle current() {
    return IndicatorStyle(
      width: 60,
      color: Colors.transparent,
      padding: const EdgeInsets.all(8),
      iconStyle: IconStyle(
          fontSize: 60,
          color: Colors.green,
          iconData: Icons.chevron_right_sharp),
    );
  }

  IndicatorStyle notHere() {
    return IndicatorStyle(
      width: 60,
      color: Colors.grey,
      padding: const EdgeInsets.all(8),
      iconStyle: IconStyle(
        fontSize: 40,
        color: Colors.grey,
        iconData: Icons.circle_outlined,
      ),
    );
  }

  IndicatorStyle passHere() {
    return IndicatorStyle(
      width: 60,
      color: Colors.transparent,
      padding: const EdgeInsets.all(8),
      iconStyle: IconStyle(
        fontSize: 40,
        color: Colors.green,
        iconData: Icons.check,
      ),
    );
  }

  IndicatorStyle cancel() {
    return IndicatorStyle(
      width: 60,
      color: Colors.transparent,
      padding: const EdgeInsets.all(8),
      iconStyle: IconStyle(
        fontSize: 40,
        color: Colors.grey,
        iconData: Icons.highlight_remove,
      ),
    );
  }

  LineStyle linePass() {
    return const LineStyle(color: Colors.green);
  }

  LineStyle lineNot() {
    return const LineStyle(color: Colors.grey);
  }

  List<Widget> timeLine() {
    List<IndicatorStyle> list;
    List<LineStyle> listLine;
    if (status == 'Accept Order' || status == 'NewOrder') {
      list = [current(), notHere(), notHere()];
      listLine = [lineNot(), lineNot(), lineNot(), lineNot()];
    } else if (status == 'Shipping') {
      list = [passHere(), current(), notHere()];
      listLine = [linePass(), linePass(), lineNot(), lineNot()];
    } else if (status == 'Cancel') {
      list = [cancel(), cancel(), cancel()];
      listLine = [lineNot(), lineNot(), lineNot(), lineNot()];
    } else {
      list = [passHere(), passHere(), passHere()];
      listLine = [linePass(), linePass(), linePass(), linePass()];
    }
    return [
      TimelineTile(
        isFirst: true,
        isLast: false,
        indicatorStyle: list[0],
        afterLineStyle: listLine[0],
        axis: TimelineAxis.horizontal,
        alignment: TimelineAlign.center,
        startChild: const Icon(
          MyFlutterApp.clinicMedical,
          color: Colors.green,
        ),
        endChild: Container(
          constraints: const BoxConstraints(
            minWidth: 120,
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 15),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text('Pending'),
            ),
          ),
        ),
      ),
      TimelineTile(
        isFirst: false,
        isLast: false,
        beforeLineStyle: listLine[1],
        afterLineStyle: listLine[2],
        indicatorStyle: list[1],
        axis: TimelineAxis.horizontal,
        alignment: TimelineAlign.center,
        startChild: const Icon(
          Icons.delivery_dining,
          size: 35,
          color: Colors.green,
        ),
        endChild: Container(
          constraints: const BoxConstraints(
            minWidth: 120,
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 15),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text('Shipping'),
            ),
          ),
        ),
      ),
      TimelineTile(
        isFirst: false,
        beforeLineStyle: listLine[3],
        isLast: true,
        indicatorStyle: list[2],
        axis: TimelineAxis.horizontal,
        alignment: TimelineAlign.center,
        startChild: const Icon(
          Icons.home,
          size: 35,
          color: Colors.green,
        ),
        endChild: Container(
          constraints: const BoxConstraints(
            minWidth: 120,
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 15),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text('Complete'),
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: timeLine(),
    );
  }
}
