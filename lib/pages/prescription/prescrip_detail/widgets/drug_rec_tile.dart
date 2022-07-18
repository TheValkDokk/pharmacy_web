import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../icons/icon.dart';
import '../../../../models/drug.dart';

class DrugRecTile extends StatelessWidget {
  const DrugRecTile(this.drug);
  final Drug drug;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CachedNetworkImage(
        height: 100,
        width: 80,
        memCacheHeight: 500,
        imageUrl: drug.imgUrl,
        placeholder: (_, url) => const Icon(MyFlutterApp.capsules),
        errorWidget: (_, url, er) => const Icon(MyFlutterApp.capsules),
      ),
      title: Text(
        drug.fullName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text('${drug.price.toStringAsFixed(3)} VND'),
    );
  }
}
