import 'dart:io';

import 'package:flutter/material.dart';
import 'package:newsapplication/models/file_manager/download_button.dart';
import 'package:newsapplication/models/file_manager/files_manager.dart';
import 'package:newsapplication/shared/components/components.dart';
import 'package:provider/provider.dart';

class InteractiveImage extends StatefulWidget {
  const InteractiveImage({Key? key, required this.images, this.index = 0})
      : super(key: key);
  final List<dynamic> images;
  final int index;

  @override
  _InteractiveImageState createState() => _InteractiveImageState();
}

class _InteractiveImageState extends State<InteractiveImage> {
  bool _isVisible = true;
  int index = 0;

  @override
  void initState() {
    index = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Container(
            color: Colors.black,
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      PageView(
                        controller: PageController(initialPage: index),
                        onPageChanged: (value) {
                          setState(() {
                            index = value;
                          });
                        },
                        scrollDirection: Axis.horizontal,
                        children: widget.images
                            .map(
                              (image) => Stack(
                                children: [
                                  if (image.runtimeType == String)
                                    Consumer<FilesManager>(
                                        builder: (context, value, child) =>
                                            Stack(
                                              children: [
                                                DownloadButton(
                                                    remoteUrl: image,
                                                    folder: 'Yemen Net'),
                                                if (value.fileInDatabase(
                                                        image) !=
                                                    null)
                                                  defaultPhotoView(
                                                      value: File(
                                                          value.fileInDatabase(
                                                              image)!),
                                                      onPressed: () {
                                                        setState(() {
                                                          _isVisible =
                                                              !_isVisible;
                                                        });
                                                      },
                                                      disableGestures: false),
                                              ],
                                            ))
                                  else
                                    defaultPhotoView(
                                        value: image,
                                        onPressed: () {
                                          setState(() {
                                            _isVisible = !_isVisible;
                                          });
                                        },
                                        disableGestures: false),
                                ],
                              ),
                            )
                            .toList(),
                        allowImplicitScrolling: true,
                      ),
                      AnimatedContainer(
                        height: _isVisible ? 56.0 : 0.0,
                        curve: Curves.linear,
                        duration: Duration(milliseconds: 350),
                        child: AppBar(
                          iconTheme: IconThemeData(color: Colors.white),
                          backgroundColor: Colors.black,
                          title: Text(
                            "${index + 1} of ${widget.images.length}",
                            style: TextStyle(color: Colors.white),
                          ),
                          centerTitle: true,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedContainer(
                          height: _isVisible ? 56.0 : 0.0,
                          curve: Curves.linear,
                          duration: Duration(milliseconds: 350),
                          color: Colors.black,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.download,
                                    color: Colors.white),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.share, color: Colors.white),
                                onPressed: () {},
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
