import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/src/widgets/basic.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tapioca/src/video_editor.dart';
import 'package:tapioca/tapioca.dart';
import 'package:video_player/video_player.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final navigatorKey = GlobalKey<NavigatorState>();
  File _video;
  File _Mainvideo;
  bool isLoading = false;
  bool showText = false;
  bool isText = false;
  bool isImage = false;
  bool isFilter = false;

  TextEditingController textController = TextEditingController();

  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await VideoEditor.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  _pickVideo() async {
    try {
      File video = await ImagePicker.pickVideo(source: ImageSource.gallery);
      print(video.path);
      setState(() {
        _video = video;
        _Mainvideo = video;
        _controller = VideoPlayerController.file(File(_video.path))
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
          });
        // isLoading = true;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = showText
        ? Container(
            height: 52,
            //color: COLOR_CONST.colorWhite,
            margin: EdgeInsets.only(top: 24, bottom: 24, left: 10, right: 10),
            padding: EdgeInsets.only(left: 15, top: 4, bottom: 2, right: 15),
            child: TextFormField(
              maxLines: 1,
              cursorColor: Colors.blue,
              controller: textController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                contentPadding: EdgeInsets.all(0.0),
                hintText: "Add Text",
              ),
            ),
          )
        : SizedBox();

    editProcess() async {
      var tempDir = await getTemporaryDirectory();
      final path = '${tempDir.path}/result.mp4';
      print(tempDir);
      final imageBitmap1 =
          (await rootBundle.load("assets/images/ic_image1.png"))
              .buffer
              .asUint8List();
      try {
        if (_Mainvideo != null) {
          if (isText && isImage && isFilter) {
            final tapiocaBalls = [
              TapiocaBall.filter(Filters.pink),
              TapiocaBall.imageOverlay(imageBitmap1, 250, 500),
              TapiocaBall.textOverlay(
                  "Nice Click", 300, 200, 50, Color(0xff000000)),
            ];
            final cup = Cup(Content(_Mainvideo.path), tapiocaBalls);
            cup.suckUp(path).then((_) async {
              print("finished");
              GallerySaver.saveVideo(path).then((bool success) {
                print(success.toString());
              });
              _video = File(path);
              _controller = VideoPlayerController.file(File(_video.path))
                ..initialize().then((_) {
                  // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                  setState(() {});
                });
              setState(() {
                isLoading = false;
              });
            });
          } else if (isText && isImage) {
            final tapiocaBalls = [
              TapiocaBall.imageOverlay(imageBitmap1, 250, 500),
              TapiocaBall.textOverlay(
                  "Nice Click", 300, 200, 50, Color(0xff000000)),
            ];

            final cup = Cup(Content(_Mainvideo.path), tapiocaBalls);
            cup.suckUp(path).then((_) async {
              print("finished");
              GallerySaver.saveVideo(path).then((bool success) {
                print(success.toString());
              });
              _video = File(path);
              _controller = VideoPlayerController.file(File(_video.path))
                ..initialize().then((_) {
                  // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                  setState(() {});
                });
              setState(() {
                isLoading = false;
              });
            });
          } else if (isText && isFilter) {
            final tapiocaBalls = [
              TapiocaBall.filter(Filters.pink),
              TapiocaBall.textOverlay(
                  "Nice Click", 300, 200, 50, Color(0xff000000)),
            ];

            final cup = Cup(Content(_Mainvideo.path), tapiocaBalls);
            cup.suckUp(path).then((_) async {
              print("finished");
              GallerySaver.saveVideo(path).then((bool success) {
                print(success.toString());
              });
              _video = File(path);
              _controller = VideoPlayerController.file(File(_video.path))
                ..initialize().then((_) {
                  // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                  setState(() {});
                });
              setState(() {
                isLoading = false;
              });
            });
          } else if (isImage && isFilter) {
            final tapiocaBalls = [
              TapiocaBall.filter(Filters.pink),
              TapiocaBall.imageOverlay(imageBitmap1, 250, 500),
            ];

            final cup = Cup(Content(_Mainvideo.path), tapiocaBalls);
            cup.suckUp(path).then((_) async {
              print("finished");
              GallerySaver.saveVideo(path).then((bool success) {
                print(success.toString());
              });
              _video = File(path);
              _controller = VideoPlayerController.file(File(_video.path))
                ..initialize().then((_) {
                  // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                  setState(() {});
                });
              setState(() {
                isLoading = false;
              });
            });
          } else if (isText) {
            final tapiocaBalls = [
              TapiocaBall.textOverlay(
                  "Nice Click", 300, 200, 50, Color(0xff000000)),
            ];

            final cup = Cup(Content(_Mainvideo.path), tapiocaBalls);
            cup.suckUp(path).then((_) async {
              print("finished");
              GallerySaver.saveVideo(path).then((bool success) {
                print(success.toString());
              });
              _video = File(path);
              _controller = VideoPlayerController.file(File(_video.path))
                ..initialize().then((_) {
                  // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                  setState(() {});
                });
              setState(() {
                isLoading = false;
              });
            });
          } else if (isImage) {
            final tapiocaBalls = [
              TapiocaBall.imageOverlay(imageBitmap1, 250, 500),
            ];
            final cup = Cup(Content(_Mainvideo.path), tapiocaBalls);
            cup.suckUp(path).then((_) async {
              print("finished");
              GallerySaver.saveVideo(path).then((bool success) {
                print(success.toString());
              });
              _video = File(path);
              _controller = VideoPlayerController.file(File(_video.path))
                ..initialize().then((_) {
                  // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                  setState(() {});
                });
              setState(() {
                isLoading = false;
              });
            });
          } else if (isFilter) {
            final tapiocaBalls = [
              TapiocaBall.filter(Filters.pink),
            ];

            final cup = Cup(Content(_Mainvideo.path), tapiocaBalls);
            cup.suckUp(path).then((_) async {
              print("finished");
              GallerySaver.saveVideo(path).then((bool success) {
                print(success.toString());
              });
              _video = File(path);
              _controller = VideoPlayerController.file(File(_video.path))
                ..initialize().then((_) {
                  // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                  setState(() {});
                });
              setState(() {
                isLoading = false;
              });
            });
          } else {
            final tapiocaBalls = [
              TapiocaBall.textOverlay(
                  "Nice Click", 300, 200, 1, Color(0xff000000)),
            ];
            final cup = Cup(Content(_Mainvideo.path), tapiocaBalls);
            cup.suckUp(path).then((_) async {
              print("finished");
              GallerySaver.saveVideo(path).then((bool success) {
                print(success.toString());
              });
              _video = File(path);
              _controller = VideoPlayerController.file(File(_video.path))
                ..initialize().then((_) {
                  // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                  setState(() {});
                });
              setState(() {
                isLoading = false;
              });
            });
          }
        } else {
          print("video is null");
        }
      } on PlatformException {
        print("error!!!!");
      }
    }

    final buttonEdit = Align(
        alignment: FractionalOffset.topRight,
        child: _controller != null && _controller.value.initialized ?Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: 56, right: 10),
            padding: EdgeInsets.only(top: 10),
            width: 80,
            height: 310,
            decoration: BoxDecoration(
                color: Color(0x80808080),
                borderRadius: BorderRadius.all(Radius.circular(50))),
            child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _controller != null && _controller.value.initialized
                      ? InkWell(
                          onTap: () async {
                            setState(() {
                              if (isText) {
                                isText = false;
                              } else {
                                isText = true;
                              }
                              isLoading = true;
                            });
                            editProcess();
                          },
                          child: Column(
                            children: [
                              Container(
                                  width: 60,
                                  height: 60,
                                  margin:
                                      EdgeInsets.only(bottom: 5,right: 10),
                                  child: Icon(
                                    Icons.text_fields,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isText
                                          ? Color(0xFF008000)
                                          : Color(0xFFffffff))),
                              Container(
                                  margin:
                                      EdgeInsets.only(bottom: 20,right: 10),
                                  child: Text("Text"))
                            ],
                          ),
                        )
                      : SizedBox(),
                  _controller != null && _controller.value.initialized
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              if (isImage) {
                                isImage = false;
                              } else {
                                isImage = true;
                              }
                              isLoading = true;
                            });
                            editProcess();
                          },
                          child: Column(
                            children: [
                              Container(
                                  width: 60,
                                  height: 60,
                                  margin: EdgeInsets.only(bottom: 5,right: 10),
                                  child: Icon(
                                    Icons.image,
                                    size: 20,
                                  ),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isImage
                                          ? Color(0xFF008000)
                                          : Color(0xFFFFFFFF))),
                              Container(
                                  margin:
                                  EdgeInsets.only(bottom: 20,right: 10),
                                  child: Text("Sticker"))
                            ],
                          ),
                        )
                      : SizedBox(),
                  _controller != null && _controller.value.initialized
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              if (isFilter) {
                                isFilter = false;
                              } else {
                                isFilter = true;
                              }
                              isLoading = true;
                            });
                            editProcess();
                          },
                          child: Column(
                            children: [
                              Container(
                                  width: 60,
                                  height: 60,
                                  margin: EdgeInsets.only(bottom: 5,right: 10),
                                  child: Icon(
                                    Icons.filter,
                                    size: 20,
                                  ),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isFilter
                                          ? Color(0xFF008000)
                                          : Color(0xFFFFFFFF))),
                              Container(
                                  margin:
                                  EdgeInsets.only(bottom: 10, right: 10),
                                  child: Text("Filter"))
                            ],
                          ),
                        )
                      : SizedBox(),
                ])): SizedBox());
    final button = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _controller != null && _controller.value.initialized
            ? SizedBox()
            : InkWell(
                onTap: () async {
                  await _pickVideo();
                },
                child: Container(
                    width: 60,
                    height: 60,
                    margin: EdgeInsets.only(bottom: 50),
                    child: Icon(
                      Icons.videocam,
                      size: 20,
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xFFFF0000))),
              ),
        _controller != null && _controller.value.initialized
            ? Container(
                width: 60,
                height: 60,
                margin: EdgeInsets.only(bottom: 50),
                child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                    child: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    )))
            : SizedBox()
      ],
    );

    final data = Stack(
      children: [
        Center(
          child: _controller != null && _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
        Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[text, button]),
        buttonEdit
      ],
    );

    return MaterialApp(
        navigatorKey: navigatorKey,
        home: Scaffold(
          body: Center(
            child: isLoading ? CircularProgressIndicator() : data,
          ),
        ));
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context, true);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("Please add some text."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
