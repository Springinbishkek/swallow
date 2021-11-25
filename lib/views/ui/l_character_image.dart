import 'dart:math';

import 'package:flutter/material.dart';

class LCharacterImage extends StatefulWidget {
  final List<String> images;
  final List<ImageProvider> photoImages;
  final double sign;
  final bool needTransition;

  const LCharacterImage({
    Key key,
    bool isMain = false,
    this.images,
    this.photoImages,
    this.needTransition,
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
    double begin = widget.sign * 2;
    double end = widget.sign * 1;
    return TweenAnimationBuilder(
        tween: Tween<double>(begin: begin, end: end),
        duration: Duration(milliseconds: 300),
        onEnd: () => controller.forward(),
        builder: (BuildContext context, double size, Widget child) {
          double position = widget.needTransition ? -size : -end;
          return Align(
            alignment: Alignment(position, 0),
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

class MyCurve extends Curve {
  final double strength;

  const MyCurve(this.strength) : super();

  @override
  double transformInternal(double t) {
    return pow(1 - pow(1 - t, strength), 1 / strength);
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
    // debugPrint('$opacity');

    return Stack(
      children: [
        Opacity(
          opacity: 1 - opacity * opacity,
          child: buildImage(photoImages.first),
        ),
        Opacity(
          opacity: const MyCurve(1.5).transform(opacity),
          child: buildImage(photoImages.last),
        )
      ],
    );
  }

  Widget buildImage(ImageProvider photo) {
    if (photo == null) {
      return photoPlaceholder;
    }
    return Image(
      image: photo,
      width: 220,
      height: 205,
      errorBuilder: (context, error, stackTrace) => photoPlaceholder,
    );
  }

  Widget get photoPlaceholder {
    return SizedBox(
      width: 220,
      height: 205,
      child: Placeholder(),
    );
  }
}
