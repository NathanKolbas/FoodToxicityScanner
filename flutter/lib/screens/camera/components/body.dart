import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:food_toxicity_scanner/screens/home/components/ocr_text_detail.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'dart:async';

import '../../../constants.dart';

class ToggleFlash extends StatefulWidget {
  final onPressed;

  const ToggleFlash({
    Key key,
    this.onPressed,
  }) :
        super(key: key);

  @override
  _ToggleFlashState createState() => _ToggleFlashState();
}

class _ToggleFlashState extends State<ToggleFlash> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  bool enabled = false;
  Color iconColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: kAnimationDuration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onPressed = widget.onPressed;

    return Stack(
      children: [
        Material(
          color: Colors.transparent,
          child: ScaleTransition(
            scale: _animation,
            child: Container(
              width: 42.0,
              height: 42.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ),
        InkWell(
          child: SizedBox(width: 42, height: 42, child: Icon(Icons.flash_on, color: iconColor,)),
          onTap: () {
            setState(() {
              if (enabled) {
                iconColor = Colors.white;
                _controller.reverse();
              } else {
                iconColor = Colors.black;
                _controller.forward();
              }
              enabled = !enabled;

              onPressed(enabled);
            });
          },
        ),
      ],
    );
  }
}

class ChangeCamera extends StatefulWidget {
  final onPressed;

  const ChangeCamera({
    Key key,
    this.onPressed,
  }) : super(key: key);

  @override
  _ChangeCameraState createState() => _ChangeCameraState();
}

class _ChangeCameraState extends State<ChangeCamera> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
    // This will make the animation only spin half way and counterclockwise
    _animation = Tween<double>(begin: 0, end: -0.5).animate(_animation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onPressed = widget.onPressed;

    return RotationTransition(
      turns: _animation,
      child: IconButton(
        icon: Icon(Icons.flip_camera_android),
        color: Colors.white,
        onPressed: () {
          _controller.reset();
          _controller.forward();

          onPressed();
        },
      ),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

// Might need later when updating camera. Will be helpful when debugging.
// Currently version 0.6.2+1 of camera is broken. Taking photos does not
// work and a lot of exceptions are thrown from the plugin side.
// /// Returns a suitable camera icon for [direction].
// IconData getCameraLensIcon(CameraLensDirection direction) {
//   switch (direction) {
//     case CameraLensDirection.back:
//       return Icons.camera_rear;
//     case CameraLensDirection.front:
//       return Icons.camera_front;
//     case CameraLensDirection.external:
//       return Icons.camera;
//   }
//   throw ArgumentError('Unknown lens direction');
// }
//
// void logError(String code, String message) =>
//     print('Error: $code\nError Message: $message');
//
// class _BodyState extends State<Body> with WidgetsBindingObserver {
//   List<CameraDescription> cameras = [];
//   CameraController controller;
//   XFile imageFile;
//   bool enableAudio = true;
//   double _minAvailableZoom;
//   double _maxAvailableZoom;
//   double _currentScale = 1.0;
//   double _baseScale = 1.0;
//
//   // Counting pointers (number of user fingers on screen)
//   int _pointers = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _getCameras().then((_) {
//       // This is where you can change the camera and the resolution
//       controller = CameraController(cameras[0], ResolutionPreset.high);
//       controller.initialize().then((_) {
//         if (!mounted) {
//           return;
//         }
//         setState(() {});
//       });
//     });
//   }
//
//   _getCameras() async {
//     try {
//       WidgetsFlutterBinding.ensureInitialized();
//       // Retrieve the device cameras
//       cameras = await availableCameras();
//     } on CameraException catch (e) {
//       print(e);
//     }
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     // App state changed before we got the chance to initialize.
//     if (controller == null || !controller.value.isInitialized) {
//       return;
//     }
//     if (state == AppLifecycleState.inactive) {
//       controller?.dispose();
//     } else if (state == AppLifecycleState.resumed) {
//       if (controller != null) {
//         onNewCameraSelected(controller.description);
//       }
//     }
//   }
//
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         title: const Text('Camera example'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: Container(
//               child: Padding(
//                 padding: const EdgeInsets.all(1.0),
//                 child: Center(
//                   child: _cameraPreviewWidget(),
//                 ),
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.black,
//                 border: Border.all(
//                   color: controller != null && controller.value.isRecordingVideo
//                       ? Colors.redAccent
//                       : Colors.grey,
//                   width: 3.0,
//                 ),
//               ),
//             ),
//           ),
//           _captureControlRowWidget(),
//           _flashModeRowWidget(),
//           _toggleAudioWidget(),
//           Padding(
//             padding: const EdgeInsets.all(5.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 _cameraTogglesRowWidget(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Display the preview from the camera (or a message if the preview is not available).
//   Widget _cameraPreviewWidget() {
//     if (controller == null || !controller.value.isInitialized) {
//       return const Text(
//         'Tap a camera',
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 24.0,
//           fontWeight: FontWeight.w900,
//         ),
//       );
//     } else {
//       return AspectRatio(
//         aspectRatio: controller.value.aspectRatio,
//         child: Listener(
//           onPointerDown: (_) => _pointers++,
//           onPointerUp: (_) => _pointers--,
//           child: GestureDetector(
//             onScaleStart: _handleScaleStart,
//             onScaleUpdate: _handleScaleUpdate,
//             child: CameraPreview(controller),
//           ),
//         ),
//       );
//     }
//   }
//
//   void _handleScaleStart(ScaleStartDetails details) {
//     _baseScale = _currentScale;
//   }
//
//   Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
//     // When there are not exactly two fingers on screen don't scale
//     if (_pointers != 2) {
//       return;
//     }
//
//     _currentScale = (_baseScale * details.scale)
//         .clamp(_minAvailableZoom, _maxAvailableZoom);
//
//     await controller.setZoomLevel(_currentScale);
//   }
//
//   /// Toggle recording audio
//   Widget _toggleAudioWidget() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 25),
//       child: Row(
//         children: <Widget>[
//           const Text('Enable Audio:'),
//           Switch(
//             value: enableAudio,
//             onChanged: (bool value) {
//               enableAudio = value;
//               if (controller != null) {
//                 onNewCameraSelected(controller.description);
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Display a bar with buttons to change the flash mode
//   Widget _flashModeRowWidget() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       mainAxisSize: MainAxisSize.max,
//       children: <Widget>[
//         IconButton(
//           icon: const Icon(Icons.flash_off),
//           color: controller?.value?.flashMode == FlashMode.off
//               ? Colors.orange
//               : Colors.blue,
//           onPressed: controller != null
//               ? () => onFlashModeButtonPressed(FlashMode.off)
//               : null,
//         ),
//         IconButton(
//           icon: const Icon(Icons.flash_auto),
//           color: controller?.value?.flashMode == FlashMode.auto
//               ? Colors.orange
//               : Colors.blue,
//           onPressed: controller != null
//               ? () => onFlashModeButtonPressed(FlashMode.auto)
//               : null,
//         ),
//         IconButton(
//           icon: const Icon(Icons.flash_on),
//           color: controller?.value?.flashMode == FlashMode.always
//               ? Colors.orange
//               : Colors.blue,
//           onPressed: controller != null
//               ? () => onFlashModeButtonPressed(FlashMode.always)
//               : null,
//         ),
//       ],
//     );
//   }
//
//   /// Display the control bar with buttons to take pictures and record videos.
//   Widget _captureControlRowWidget() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       mainAxisSize: MainAxisSize.max,
//       children: <Widget>[
//         IconButton(
//           icon: const Icon(Icons.camera_alt),
//           color: Colors.blue,
//           onPressed: controller != null &&
//               controller.value.isInitialized &&
//               !controller.value.isRecordingVideo
//               ? onTakePictureButtonPressed
//               : null,
//         ),
//       ],
//     );
//   }
//
//   /// Display a row of toggle to select the camera (or a message if no camera is available).
//   Widget _cameraTogglesRowWidget() {
//     final List<Widget> toggles = <Widget>[];
//
//     if (cameras.isEmpty) {
//       return const Text('No camera found');
//     } else {
//       for (CameraDescription cameraDescription in cameras) {
//         toggles.add(
//           SizedBox(
//             width: 90.0,
//             child: RadioListTile<CameraDescription>(
//               title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
//               groupValue: controller?.description,
//               value: cameraDescription,
//               onChanged: controller != null && controller.value.isRecordingVideo
//                   ? null
//                   : onNewCameraSelected,
//             ),
//           ),
//         );
//       }
//     }
//
//     return Row(children: toggles);
//   }
//
//   String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
//
//   void showInSnackBar(String message) {
//     // ignore: deprecated_member_use
//     _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
//   }
//
//   void onNewCameraSelected(CameraDescription cameraDescription) async {
//     if (controller != null) {
//       await controller.dispose();
//     }
//     controller = CameraController(
//       cameraDescription,
//       ResolutionPreset.medium,
//       enableAudio: enableAudio,
//     );
//
//     // If the controller is updated then update the UI.
//     controller.addListener(() {
//       if (mounted) setState(() {});
//       if (controller.value.hasError) {
//         showInSnackBar('Camera error ${controller.value.errorDescription}');
//       }
//     });
//
//     try {
//       await controller.initialize();
//       _maxAvailableZoom = await controller.getMaxZoomLevel();
//       _minAvailableZoom = await controller.getMinZoomLevel();
//     } on CameraException catch (e) {
//       _showCameraException(e);
//     }
//
//     if (mounted) {
//       setState(() {});
//     }
//   }
//
//   void onTakePictureButtonPressed() {
//     takePicture().then((XFile file) {
//       if (mounted) {
//         setState(() {
//           imageFile = file;
//         });
//         if (file != null) showInSnackBar('Picture saved to ${file.path}');
//       }
//     });
//   }
//
//   void onFlashModeButtonPressed(FlashMode mode) {
//     setFlashMode(mode).then((_) {
//       if (mounted) setState(() {});
//       showInSnackBar('Flash mode set to ${mode.toString().split('.').last}');
//     });
//   }
//
//   Future<void> setFlashMode(FlashMode mode) async {
//     try {
//       await controller.setFlashMode(mode);
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       rethrow;
//     }
//   }
//
//   Future<XFile> takePicture() async {
//     if (!controller.value.isInitialized) {
//       showInSnackBar('Error: select a camera first.');
//       return null;
//     }
//
//     if (controller.value.isTakingPicture) {
//       // A capture is already pending, do nothing.
//       return null;
//     }
//
//     try {
//       XFile file = await controller.takePicture();
//       return file;
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       return null;
//     }
//   }
//
//   void _showCameraException(CameraException e) {
//     logError(e.code, e.description);
//     showInSnackBar('Error: ${e.code}\n${e.description}');
//   }
// }

class _BodyState extends State<Body> {
  CameraController _controller;
  List<CameraDescription> cameras = [];
  List<bool> isSelected = [false];
  int currentCamera = 0;

  @override
  void initState() {
    super.initState();

    _getCameras().then((_) {
      // This is where you can change the camera and the resolution
      _controller = CameraController(cameras[0], ResolutionPreset.high);
      _controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    });
  }

  _getCameras() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      // Retrieve the device cameras
      cameras = await availableCameras();
    } on CameraException catch (e) {
      print(e);
    }
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller.dispose();
    }
    _controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    _controller.addListener(() {
      if (mounted) setState(() {});
      if (_controller.value.hasError) {
        print('Camera error ${_controller.value.errorDescription}');
      }
    });

    try {
      await _controller.initialize();
    } on CameraException catch (e) {
      print(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      // This will make the status bar black
      color: Colors.black,
      child: SafeArea(
        child: _controller != null && _controller.value.isInitialized
            ? Stack(
          alignment: Alignment.center,
          children: <Widget>[
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: CameraPreview(_controller),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(Icons.cancel, color: Colors.white,),
                  onPressed: () => Navigator.maybePop(context),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Container(
                  padding: EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(30.0)
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChangeCamera(
                        onPressed: () {
                          currentCamera = currentCamera + 1 == cameras.length ? 0 : currentCamera + 1;
                          onNewCameraSelected(cameras[currentCamera]);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.camera),
                        color: Colors.white,
                        onPressed: () async {
                          await _takePicture().then((String path) {
                            if (path != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(path),
                                ),
                              );
                            }
                          });
                        },
                      ),
                      ToggleFlash(
                        onPressed: (enabled) => print(enabled),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        )
            : Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<String> _takePicture() async {
    // Checking whether the controller is initialized
    if (!_controller.value.isInitialized) {
      print("Controller is not initialized");
      return null;
    }

    // Formatting Date and Time
    String dateTime = DateFormat.yMMMd()
        .addPattern('-')
        .add_Hms()
        .format(DateTime.now())
        .toString();

    String formattedDateTime = dateTime.replaceAll(' ', '');

    // Retrieving the path for saving an image
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String visionDir = '${appDocDir.path}/Photos/Vision\ Images';
    await Directory(visionDir).create(recursive: true);
    final String imagePath = '$visionDir/image_$formattedDateTime.jpg';

    // Checking whether the picture is being taken
    // to prevent execution of the function again
    // if previous execution has not ended
    if (_controller.value.isTakingPicture) {
      print("Processing is in progress...");
      return null;
    }

    try {
      // Captures the image and saves it to the
      // provided path
      await _controller.takePicture(imagePath);
    } on CameraException catch (e) {
      print("Camera Exception: $e");
      return null;
    }

    return imagePath;
  }
}

// Inside image_detail.dart file
class DetailScreen extends StatefulWidget {
  final String imagePath;
  DetailScreen(this.imagePath);

  @override
  _DetailScreenState createState() => new _DetailScreenState(imagePath);
}

class _DetailScreenState extends State<DetailScreen> {
  _DetailScreenState(this.path);

  final String path;

  Size _imageSize;
  String recognizedText = "Loading ...";

  List<Rect> _elements = [];
  List<String> _texts = [];
  void _initializeVision() async {
    final File imageFile = File(path);

    if (imageFile != null) {
      await _getImageSize(imageFile);
    }

    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);
    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText visionText = await textRecognizer.processImage(visionImage);

    String mailAddress = "";
    for (TextBlock block in visionText.blocks) {
      mailAddress += block.text + '\n';
      _elements.add(block.boundingBox);
      _texts.add(block.text);
    }

    if (this.mounted) {
      setState(() {
        recognizedText = mailAddress;
      });
    }
  }

  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    // Fetching image from path
    final Image image = Image.file(imageFile);

    // Retrieving its size
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
  }

  @override
  void initState() {
    _initializeVision();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      // This will make the status bar black
      color: Colors.black,
      child: SafeArea(
        child: _imageSize != null ?
        Stack(
          children: <Widget>[
            Center(
              child: Container(
                width: double.maxFinite,
                child: GestureDetector(
                  onTapDown: (details) {
                    final offset = details.localPosition;
                    final index = _elements.lastIndexWhere((rect) => scaleRect(rect).contains(offset));
                    if (index != -1) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OcrTextDetail(_texts[index]),
                        ),
                      );
                    }
                  },
                  child: CustomPaint(
                    foregroundPainter: TextDetectorPainter(_imageSize, _elements),
                    child: AspectRatio(
                      aspectRatio: _imageSize.aspectRatio,
                      child: Image.file(
                        File(path),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(Icons.cancel, color: Colors.white,),
                  onPressed: () => Navigator.maybePop(context),
                ),
              ),
            ),
            HelperCard(),
          ],
        )
            :
        Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

// These need to be global vars so we can know the exact location the boxes were drawn after scaling
double scaleX = 1.0;
double scaleY = 1.0;
Rect scaleRect(Rect container) {
  return Rect.fromLTRB(
    container.left * scaleX,
    container.top * scaleY,
    container.right * scaleX,
    container.bottom * scaleY,
  );
}

class TextDetectorPainter extends CustomPainter {
  TextDetectorPainter(this.absoluteImageSize, this.elements);

  final Size absoluteImageSize;
  final List<Rect> elements;

  @override
  void paint(Canvas canvas, Size size) {
    scaleX = size.width / absoluteImageSize.width;
    scaleY = size.height / absoluteImageSize.height;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red
      ..strokeWidth = 2.0;

    for (Rect element in elements) {
      canvas.drawRect(scaleRect(element), paint);
    }
  }

  @override
  bool shouldRepaint(TextDetectorPainter oldDelegate) {
    return true;
  }
}

class HelperCard extends StatefulWidget {
  @override
  _HelperCardState createState() => _HelperCardState();
}

class _HelperCardState extends State<HelperCard> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animation;
  SharedPreferences prefs;
  bool _showedFirstTimeHint = false;

  _getFirstTimeHint() async {
    prefs = await SharedPreferences.getInstance();
    _showedFirstTimeHint = prefs.getBool('firstTimeHintImageDetailsScreen') ?? false;
    if (!_showedFirstTimeHint)
      await prefs.setBool('firstTimeHintImageDetailsScreen', true);
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(_controller);

    _getFirstTimeHint().then((_) {
      if (!_showedFirstTimeHint) {
        _controller.forward();
        new Timer(const Duration(seconds: 5), () => _controller.reverse());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: () => _controller.reverse(),
          child: Card(
            elevation: 8,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      "Click on the red box with the ingredients label to begin scan.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
