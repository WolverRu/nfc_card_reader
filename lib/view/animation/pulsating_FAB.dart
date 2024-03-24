import 'package:flutter/material.dart';
import 'package:nfc_card_reader/model/read_record.dart';
import 'package:nfc_card_reader/view/common/nfc_session.dart';
import 'package:nfc_manager/nfc_manager.dart';

class PulsatingFAB extends StatefulWidget {
  const PulsatingFAB({
    super.key,
    required this.handleTag,
  });

  final Future<ReadRecord?> Function(NfcTag tag, BuildContext context)
      handleTag;

  @override
  State<PulsatingFAB> createState() => _PulsatingFABState();
}

class _PulsatingFABState extends State<PulsatingFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween(begin: 35.0, end: 40.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FloatingActionButton(
          onPressed: () => startSession(
            context: context,
            handleTag: (tag) => widget.handleTag(tag, context),
          ),
          backgroundColor: Colors.blue,
          tooltip: 'СТАРТ',
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              CustomPaint(
                painter: PulsatingCirclePainter(_animation.value),
              ),
              const Center(
                child: Text(
                  'СТАРТ',
                  style: TextStyle(
                    color: Color.fromRGBO(254, 249, 230, 1),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PulsatingCirclePainter extends CustomPainter {
  final double radius;

  PulsatingCirclePainter(this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
  }

  @override
  bool shouldRepaint(PulsatingCirclePainter oldDelegate) {
    return oldDelegate.radius != radius;
  }
}
