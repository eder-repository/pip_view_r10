import 'package:flutter/material.dart';

import 'dismiss_keyboard.dart';
import 'raw_pip_view.dart';

class PIPView extends StatefulWidget {
  final PIPViewCorner initialCorner;
  final double? floatingWidth;
  final double? floatingHeight;
  final bool avoidKeyboard;

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
        click = !click;
        print(click);
        setState(() {});
        if (click)
          Future.delayed(Duration(seconds: 2)).then((value) {
            click = false;
            setState(() {});
          });

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
    );
  }
}
