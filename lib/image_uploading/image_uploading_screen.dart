import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io';

class ImageUploadingScreen extends StatefulWidget {
  const ImageUploadingScreen({super.key});

  @override
  ImageUploadingScreenState createState() => ImageUploadingScreenState();
}

class ImageUploadingScreenState extends State<ImageUploadingScreen> {
  String recognizedText = '';
  String? imagePath;
  late FlutterTts ftts;
  var data;

  @override
  void initState() {
    super.initState();
    ftts = FlutterTts();
  }

  Future<void> speakCaption() async {
    await ftts.setLanguage("en-US");
    await ftts.setPitch(1);
    await ftts.speak(recognizedText);
  }

  Future<void> pauseCaption() async {
    await ftts.pause();
  }

  Future<void> stopCaption() async {
    await ftts.stop();
  }

  Future<void> getImage(bool isCamera) async {
    XFile? image;

    if (isCamera) {
      image = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
    }

    if (image != null) {
      File imageFile = File(image.path);

      setState(() {
        imagePath = image?.path;
        recognizedText = '';
      });
      recognizeText();
    }
  }

  Future<void> pickImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
        recognizedText = ''; // Clear recognized text when new image is selected
      });
      recognizeText();
    }
  }

  Future<void> recognizeText() async {
    if (imagePath == null) return;

    final inputImage = InputImage.fromFilePath(imagePath!);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final result = await textRecognizer.processImage(inputImage);

    setState(() {
      recognizedText = result.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool showOptions = false;
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Recognition App'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              imagePath != null
                  ? Image.file(
                      File(imagePath!),
                      height: 200,
                    )
                  : Text('No image selected'),
              SizedBox(height: 20),
              Text('Recognized Text:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              SingleChildScrollView(
                child: Text(recognizedText),
              ),

              // ElevatedButton(
              //   onPressed: () => speakCaption(),
              //   child: const Text("Audio"),
              // ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.insert_drive_file),
                    color: Colors.white,
                    iconSize: 24,
                    onPressed: () {
                      getImage(false);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    color: Colors.white,
                    iconSize: 24,
                    onPressed: () {
                      getImage(true);
                    },
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => speakCaption(),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => speakCaption(),
                              icon: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            const Text("Play Audio"),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      GestureDetector(
                        onTap: () => pauseCaption(),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => pauseCaption(),
                              icon: const Icon(
                                Icons.pause_rounded,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            const Text("Pause Audio"),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      GestureDetector(
                        onTap: () => stopCaption(),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => stopCaption(),
                              icon: const Icon(
                                Icons.stop_rounded,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            const Text("Stop Audio"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.file_copy_sharp),
              onPressed: () {
                getImage(false);
              },
            ),
            IconButton(
              icon: Icon(Icons.camera_alt_rounded),
              onPressed: () {
                getImage(true);
              },
            ),
          ],
        ),
      ),
    );
  }
}