import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'app_icon.dart';

class CachedOrAssetImage extends StatelessWidget {
  const CachedOrAssetImage(this.image, {super.key});
  final String image;

  @override
  Widget build(BuildContext context) {
    return image.contains('http')
        ? CachedNetworkImage(
            imageUrl: image,
            progressIndicatorBuilder: (_, __, downloadProgress) =>
                CircularProgressIndicator(
              value: downloadProgress.progress,
            ),
            errorWidget: (_, __, ___) => const AppIcon(radius: 18),
            height: 36,
          )
        : Image.asset(image, height: 36);
  }
}
