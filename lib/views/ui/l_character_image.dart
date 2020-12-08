import 'dart:ui';

import 'package:flutter/material.dart';

class LCharacterImage extends StatefulWidget {
  final List<String> images;
  final List<ImageProvider> photoImages;
  final double sign;
  const LCharacterImage({
    Key key,
    this.images,
    this.photoImages,
    bool isMain = false,
  })  : sign = isMain ? 1 : -1,
        super(key: key);

  @override
  _LCharacterImageState createState() => _LCharacterImageState();
}

class _LCharacterImageState extends State<LCharacterImage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint(widget.images.toString());
    return TweenAnimationBuilder(
        tween: Tween<double>(begin: widget.sign * 2, end: widget.sign * 1),
        duration: Duration(milliseconds: 300),
        onEnd: () => controller.forward(),
        builder: (BuildContext context, double size, Widget child) {
          // debugPrint('$size');
          return Align(
            alignment: Alignment(-size, 0),
            child: child,
          );
        },
        child: AnimatedPhoto(
          animation: animation,
          images: widget.images,
          photoImages: widget.photoImages,
        ));
  }
}

class AnimatedPhoto extends AnimatedWidget {
  // Make the Tweens static because they don't change.
  static final _opacityTween = Tween<double>(begin: 0, end: 1);
  final List<String> images;
  final List<ImageProvider> photoImages;

  AnimatedPhoto(
      {Key key, Animation<double> animation, this.images, this.photoImages})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    var opacity = _opacityTween.evaluate(animation);
    debugPrint('$opacity');

    return Stack(
      children: [
        Opacity(
          opacity: 1 - opacity * opacity,
          child: buildImage(photoImages.first),
        ),
        Opacity(
          opacity: opacity,
          child: buildImage(photoImages.last),
        )
      ],
    );
  }

  Image buildImage(ImageProvider photo) {
    return Image(
      image: photo,
      width: 220,
      height: 205,
      errorBuilder: (context, error, stackTrace) => SizedBox(
        width: 220,
        height: 205,
        child: Placeholder(),
      ),
    );
  }
}