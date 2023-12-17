import 'package:flutter/material.dart';
import 'package:imnabbo/globals.dart' as globals;

class BigNabboCard extends StatefulWidget {
  const BigNabboCard(this.index, this.show, {super.key});

  final int index;
  final bool show;

  @override
  State<BigNabboCard> createState() => _BigNabboCardState();
}

class _BigNabboCardState extends State<BigNabboCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Start the animation when the widget is first built
    if (widget.show) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(BigNabboCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.show) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      color: globals.bgColor,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: const Offset(0, 0),
          ).animate(
            CurvedAnimation(
              curve: Curves.easeInOut,
              parent: _animationController,
            ),
          ),
          child: Image(
            image: AssetImage(
              globals.cardsList[widget.index].path,
            ),
          ),
        ),
      ),
    );
  }
}
