import 'dart:async';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:tentura/ui/utils/ui_utils.dart';

class QRScanDialog extends StatefulWidget {
  static Future<String?> show(BuildContext context) => showDialog<String>(
        context: context,
        useSafeArea: false,
        useRootNavigator: false,
        builder: (context) => const QRScanDialog(),
      );

  const QRScanDialog({super.key});

  @override
  State<QRScanDialog> createState() => _QRScanDialogState();
}

class _QRScanDialogState extends State<QRScanDialog>
    with WidgetsBindingObserver {
  final _controller = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
  );

  StreamSubscription<BarcodeCapture>? _subscription;

  bool _torchEnabled = false;
  bool _hasResult = false;

  late Rect _scanWindow;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _subscription = _controller.barcodes.listen(_handleBarcode);
    unawaited(_controller.start());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_controller.value.isInitialized) return;

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;

      case AppLifecycleState.resumed:
        _subscription = _controller.barcodes.listen(_handleBarcode);
        unawaited(_controller.start());

      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(_controller.stop());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scanWindow = _getScanWindow(context);
    unawaited(_controller.updateScanWindow(_scanWindow));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    unawaited(_controller.dispose());
    _subscription = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Scan the QR Code'),
            actions: [
              IconButton(
                icon: _torchEnabled
                    ? const Icon(Icons.flashlight_off_outlined)
                    : const Icon(Icons.flashlight_on_outlined),
                onPressed: () async {
                  await _controller.toggleTorch();
                  setState(() => _torchEnabled = !_torchEnabled);
                },
              ),
            ],
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
          ),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              MobileScanner(
                controller: _controller,
                scanWindow: _scanWindow,
              ),
              CustomPaint(
                painter: _ScannerOverlay(frame: _scanWindow),
              ),
            ],
          ),
        ),
      );

  Rect _getScanWindow(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scanAreaSize = switch (ScreenSize.get(size)) {
      ScreenSmall _ => size.width * 0.75,
      ScreenMedium _ => size.width * 0.7,
      ScreenLarge _ => size.width * 0.6,
      ScreenBig _ => size.width * 0.5,
    };
    return Rect.fromCenter(
      center: size.center(Offset.zero),
      width: scanAreaSize,
      height: scanAreaSize,
    );
  }

  void _handleBarcode(BarcodeCapture captured) {
    if (_hasResult || captured.barcodes.isEmpty) return;
    if (context.mounted) {
      _hasResult = true;
      context.maybePop(captured.barcodes.first.rawValue);
    }
  }
}

class _ScannerOverlay extends CustomPainter {
  _ScannerOverlay({required this.frame});

  final Rect frame;

  final _framePaint = Paint()
    ..color = Colors.white
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 8;

  final _maskPaint = Paint()
    ..color = Colors.deepPurple.withOpacity(0.5)
    ..style = PaintingStyle.fill
    ..blendMode = BlendMode.dstOut;

  late final _maskPath = Path.combine(
    PathOperation.difference,
    Path()..addRect(Rect.largest),
    Path()..addRect(frame),
  );

  late final _frameSize = frame.height / 5;

  late final _leftTop = Offset(frame.left, frame.top);
  late final _leftTopH = Offset(frame.left + _frameSize, frame.top);
  late final _leftTopV = Offset(frame.left, frame.top + _frameSize);

  late final _rightTop = Offset(frame.right, frame.top);
  late final _rightTopH = Offset(frame.right - _frameSize, frame.top);
  late final _rightTopV = Offset(frame.right, frame.top + _frameSize);

  late final _leftBottom = Offset(frame.left, frame.bottom);
  late final _leftBottomH = Offset(frame.left + _frameSize, frame.bottom);
  late final _leftBottomV = Offset(frame.left, frame.bottom - _frameSize);

  late final _rightBottom = Offset(frame.right, frame.bottom);
  late final _rightBottomH = Offset(frame.right - _frameSize, frame.bottom);
  late final _rightBottomV = Offset(frame.right, frame.bottom - _frameSize);

  @override
  bool shouldRepaint(_) => false;

  @override
  void paint(Canvas canvas, Size size) => canvas
    ..drawPath(_maskPath, _maskPaint)
    ..drawLine(_leftTop, _leftTopH, _framePaint)
    ..drawLine(_leftTop, _leftTopV, _framePaint)
    ..drawLine(_rightTop, _rightTopH, _framePaint)
    ..drawLine(_rightTop, _rightTopV, _framePaint)
    ..drawLine(_leftBottom, _leftBottomH, _framePaint)
    ..drawLine(_leftBottom, _leftBottomV, _framePaint)
    ..drawLine(_rightBottom, _rightBottomH, _framePaint)
    ..drawLine(_rightBottom, _rightBottomV, _framePaint);
}
