import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:meme_app/helper/text_widget_container.dart';
import 'dart:ui' as ui;
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:toast/toast.dart';

class EditMemePage extends StatefulWidget {

  final String memeUrl;
  final String memeName;
  final File memeImage;

  EditMemePage({this.memeUrl, this.memeName, this.memeImage});

  @override
  _EditMemePageState createState() => _EditMemePageState();
}

class _EditMemePageState extends State<EditMemePage> {

  static GlobalKey screenshotKey = new GlobalKey();

  List<Widget> list = List<Widget>();

  void _takeScreenShot() async {
    RenderRepaintBoundary boundary =
    screenshotKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    print(pngBytes);
    var filePath = await ImagePickerSaver.saveFile(fileData: pngBytes);
    print(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        shadowColor: Colors.white,
        title: Text(widget.memeName),
        actions: <Widget>[
//          IconButton(
//            onPressed: () {},
//            icon: Icon(Icons.share),
//          ),
          IconButton(
            onPressed: () {
              _takeScreenShot();
              Toast.show("Image saved in gallery", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
            },
            icon: Icon(Icons.save_alt),
          ),
        ],
      ),
      body: RepaintBoundary(
        key: screenshotKey,
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height*0.7,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: widget.memeUrl != "" ? NetworkImage(widget.memeUrl) : FileImage(widget.memeImage),
                  ),
                ),
              ),
              getList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: RaisedButton(
        onPressed: () {
        setState(() {
          list.add(TextWidgetContainer());
        });
        },
        splashColor: Colors.blue,
        color: Colors.deepPurple,
        child: Text("Add Text"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget getList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0,),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (_, index) {
        return InteractiveViewer(child: list.elementAt(index),
        boundaryMargin: EdgeInsets.symmetric(
          vertical: double.infinity,
          horizontal: double.infinity,
        ),
        );
      },
    );
  }

}
