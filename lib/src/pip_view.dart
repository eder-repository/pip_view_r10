import 'package:flutter/material.dart';

import 'dismiss_keyboard.dart';
import 'raw_pip_view.dart';

class PIPView extends StatefulWidget {
  final PIPViewCorner initialCorner;
  final double? floatingWidth;
  final double? floatingHeight;
  final bool avoidKeyboard;
  final VoidCallback onPlay;
  final bool isPlaying;
  final Color colorIcon;
  final double sizeIconPlay;
  final double sizeIconExtend;

  final Widget Function(
    BuildContext context,
    bool isFloating,
  ) builder;

  const PIPView({
    Key? key,
    required this.builder,
    this.initialCorner = PIPViewCorner.topRight,
    this.floatingWidth,
    this.floatingHeight,
    this.avoidKeyboard = true,
    required this.onPlay,
    this.isPlaying = false,
    this.colorIcon = Colors.white,
    this.sizeIconPlay = 50,
    this.sizeIconExtend = 30,
  }) : super(key: key);

  @override
  PIPViewState createState() => PIPViewState();

  static PIPViewState? of(BuildContext context) {
    return context.findAncestorStateOfType<PIPViewState>();
  }
}

class PIPViewState extends State<PIPView> with TickerProviderStateMixin {
  Widget? _bottomWidget;
  late bool click = false;

  void presentBelow(Widget widget) {
    dismissKeyboard(context);
    setState(() => _bottomWidget = widget);
  }

  void stopFloating() {
    dismissKeyboard(context);
    setState(() => _bottomWidget = null);
  }

  @override
  Widget build(BuildContext context) {
    final isFloating = _bottomWidget != null;
    return RawPIPView(
      extend: () {
        stopFloating();
        click = !click;
      },
      showOptions: click,
      avoidKeyboard: widget.avoidKeyboard,
      bottomWidget: isFloating
          ? Navigator(
              onGenerateInitialRoutes: (navigator, initialRoute) => [
                MaterialPageRoute(builder: (context) => _bottomWidget!),
              ],
            )
          : null,
      onTapTopWidget: () {
        if (isFloating) {
          click = !click;
          print(click);
          setState(() {});
          if (click)
            Future.delayed(Duration(seconds: 2)).then((value) {
              click = false;
              setState(() {});
            });
        }

        // click = !click;
      },
      topWidget: IgnorePointer(
        ignoring: isFloating,
        child: Builder(
          builder: (context) => widget.builder(context, isFloating),
        ),
      ),
      floatingHeight: widget.floatingHeight,
      floatingWidth: widget.floatingWidth,
      initialCorner: widget.initialCorner,
      onPlay: widget.onPlay,
      isPlaying: widget.isPlaying,
      colorIcon: widget.colorIcon,
      sizeIconPlay: widget.sizeIconPlay,
      sizeIconExtend: widget.sizeIconExtend,
    );
  }
}
