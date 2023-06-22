import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({super.key, required this.imageUrl, this.borderRadius});
  final String imageUrl;
  final double? borderRadius;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 0.0),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) {
          return Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: Colors.grey,
              child: Container());
        },
      ),
    );
  }
}
