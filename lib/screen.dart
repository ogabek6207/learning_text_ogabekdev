import 'package:flutter/material.dart';
import 'package:learning_input_image/learning_input_image.dart';
import 'package:learning_text_recognition/learning_text_recognition.dart';
import 'package:provider/provider.dart';

class TextRecognitionPage extends StatefulWidget {
  const TextRecognitionPage({super.key});

  @override
  _TextRecognitionPageState createState() => _TextRecognitionPageState();
}

class _TextRecognitionPageState extends State<TextRecognitionPage> {
  final TextRecognition _textRecognition = TextRecognition();


  @override
  void dispose() {
    _textRecognition.dispose();
    super.dispose();
  }

  Future<void> _startRecognition(InputImage image) async {
    TextRecognitionState state = Provider.of(context, listen: false);

    if (state.isNotProcessing) {
      state.startProcessing();
      state.image = image;
      state.data = await _textRecognition.process(image);
      state.stopProcessing();
    }
  }

  String textView = "";

  @override
  Widget build(BuildContext context) {
    return InputCameraView(
      mode: InputCameraMode.gallery,
      // resolutionPreset: ResolutionPreset.high,
      title: 'Text Recognition',
      onImage: _startRecognition,
      overlay: Consumer<TextRecognitionState>(
        builder: (_, state, __) {
          if (state.isNotEmpty) {
            textView = state.text;
            return Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                ),
                child: Text(
                  state.text,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}

class TextRecognitionState extends ChangeNotifier {
  InputImage? _image;
  RecognizedText? _data;
  bool _isProcessing = false;

  InputImage? get image => _image;

  RecognizedText? get data => _data;

  String get text => _data!.text;

  bool get isNotProcessing => !_isProcessing;

  bool get isNotEmpty => _data != null && text.isNotEmpty;

  void startProcessing() {
    _isProcessing = true;
    notifyListeners();
  }

  void stopProcessing() {
    _isProcessing = false;
    notifyListeners();
  }

  set image(InputImage? image) {
    _image = image;
    notifyListeners();
  }

  set data(RecognizedText? data) {
    _data = data;
    notifyListeners();
  }
}
