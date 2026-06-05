import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/nutrimove_button.dart';
import '../../../../shared/widgets/nutrimove_snackbar.dart';
import '../providers/scanner_provider.dart';
 
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});
 
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}
 
class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _hasCameraPermission = true;
 
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }
 
  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        debugPrint("No cameras found");
        return;
      }
 
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
 
      final controller = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );
 
      _controller = controller;
 
      await controller.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint("Camera initialization error: $e");
      if (mounted) {
        setState(() {
          _hasCameraPermission = false;
        });
      }
    }
  }
 
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }
 
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;
 
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
 
    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }
 
  Future<void> _captureAndProcess() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_controller!.value.isTakingPicture) return;
 
    try {
      final image = await _controller!.takePicture();
      if (mounted) {
        final scanner = context.read<ScannerProvider>();
        scanner.startScanning();
        await scanner.processImage(image.path);
        if (mounted) {
          if (scanner.errorMessage != null) {
            NutriMoveSnackbar.show(
              context,
              message: scanner.errorMessage!,
              type: SnackbarType.error,
              title: 'Pemindaian Gagal',
            );
          } else if (scanner.scanResult != null) {
            context.push('/scan/result');
          }
        }
      }
    } catch (e) {
      debugPrint("Error capturing picture: $e");
    }
  }
 
  Future<void> _pickFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (image != null && mounted) {
        final scanner = context.read<ScannerProvider>();
        scanner.startScanning();
        await scanner.processImage(image.path);
        if (mounted) {
          if (scanner.errorMessage != null) {
            NutriMoveSnackbar.show(
              context,
              message: scanner.errorMessage!,
              type: SnackbarType.error,
              title: 'Pemindaian Gagal',
            );
          } else if (scanner.scanResult != null) {
            context.push('/scan/result');
          }
        }
      }
    } catch (e) {
      debugPrint("Error picking from gallery: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isProcessing = context.watch<ScannerProvider>().isProcessing;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('AI Food Scanner', style: AppTypography.headlineLarge),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Text('AI Ready', style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
                  ]),
                ),
              ]),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (_isCameraInitialized && _controller != null)
                          CameraPreview(_controller!)
                        else if (!_hasCameraPermission)
                          const Center(
                            child: Text(
                              'Izin kamera ditolak.\nSilakan aktifkan izin kamera di pengaturan.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          )
                        else
                          const Center(
                            child: CircularProgressIndicator(color: AppColors.primary),
                          ),
                        // Scan frame corners
                        Positioned(top: 40, left: 40, child: _Corner(isTop: true, isLeft: true)),
                        Positioned(top: 40, right: 40, child: _Corner(isTop: true, isLeft: false)),
                        Positioned(bottom: 40, left: 40, child: _Corner(isTop: false, isLeft: true)),
                        Positioned(bottom: 40, right: 40, child: _Corner(isTop: false, isLeft: false)),
                        
                        // Loading overlay
                        if (isProcessing)
                          Container(
                            color: Colors.black54,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CircularProgressIndicator(color: AppColors.primary),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Menganalisis Makanan...',
                                    style: AppTypography.titleMedium.copyWith(color: Colors.white),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'AI sedang menganalisis makanan...',
                                    style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(children: [
                Expanded(
                  child: NutriMoveButton(
                    label: 'Galeri',
                    type: ButtonType.outline,
                    icon: Icons.photo_library_rounded,
                    onPressed: isProcessing ? () {} : _pickFromGallery,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: NutriMoveButton(
                    label: 'Ambil Foto',
                    icon: Icons.camera_rounded,
                    onPressed: isProcessing ? () {} : _captureAndProcess,
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

class _Corner extends StatelessWidget {
  final bool isTop, isLeft;
  const _Corner({required this.isTop, required this.isLeft});
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 30, height: 30, child: CustomPaint(painter: _CornerPainter(isTop: isTop, isLeft: isLeft)));
  }
}

class _CornerPainter extends CustomPainter {
  final bool isTop, isLeft;
  _CornerPainter({required this.isTop, required this.isLeft});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path();
    if (isTop && isLeft) {
      path.moveTo(0, size.height);
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
    } else if (isTop && !isLeft) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else if (!isTop && isLeft) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
