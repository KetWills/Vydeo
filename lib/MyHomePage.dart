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
import 'package:vydeo/VideoScreen.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final navigatorKey = GlobalKey<NavigatorState>();
  File _video;
  bool isLoading = false;
  bool showText = false;
  TextEditingController textController = TextEditingController();

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
        isLoading = true;
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

    final button =
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              if (showText) {
                showText = false;
              } else {
                showText = true;
              }
            });
          },
          child: Container(
              width: 60,
              height: 60,
              margin: EdgeInsets.only(bottom: 50,right: 20),
              child: Icon(
                Icons.text_fields,
                color: Colors.white,
                size: 20,
              ),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xFFFF0000))),
        ),
        InkWell(
          onTap: () {
          },
          child: Container(
              width: 60,
              height: 60,
              margin: EdgeInsets.only(bottom: 50,right: 20),
              child: Icon(
                Icons.image,
                size: 20,
              ),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xFF808080))),
        ),
        InkWell(
          onTap: () async {
            if (textController.text.toString().length > 0) {
              print("clicked!");
              await _pickVideo();
              var tempDir = await getTemporaryDirectory();
              final path = '${tempDir.path}/result.mp4';
              print(tempDir);
              final imageBitmap =
                  (await rootBundle.load("assets/images/ic_drink.png"))
                      .buffer
                      .asUint8List();

              final imageBitmap1 =
                  (await rootBundle.load("assets/images/ic_image1.png"))
                      .buffer
                      .asUint8List();

              final imageBitmap2 =
                  (await rootBundle.load("assets/images/ic_image2.png"))
                      .buffer
                      .asUint8List();

              final imageBitmap3 =
                  (await rootBundle.load("assets/images/ic_image1.png"))
                      .buffer
                      .asUint8List();
              try {
                final tapiocaBalls = [
                  TapiocaBall.filter(Filters.pink),
                  TapiocaBall.imageOverlay(imageBitmap, 300, 300),
                  TapiocaBall.imageOverlay(imageBitmap3, 100, 100),
                  TapiocaBall.imageOverlay(imageBitmap2, 200, 200),
                  TapiocaBall.imageOverlay(imageBitmap1, 250, 500),
                  TapiocaBall.textOverlay(textController.text.toString(), 300,
                      200, 50, Color(0xff008000)),
                ];
                if (_video != null) {
                  final cup = Cup(Content(_video.path), tapiocaBalls);
                  cup.suckUp(path).then((_) async {
                    print("finished");
                    GallerySaver.saveVideo(path).then((bool success) {
                      print(success.toString());
                    });
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => VideoScreen(path)),
                    );
                    setState(() {
                      isLoading = false;
                    });
                  });
                } else {
                  print("video is null");
                }
              } on PlatformException {
                print("error!!!!");
              }
            } else {
              showAlertDialog(context);
            }
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
        )
      ],
    );

    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        body: Center(
            child: isLoading
                ? CircularProgressIndicator()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[text, button])),
      ),
    );
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
