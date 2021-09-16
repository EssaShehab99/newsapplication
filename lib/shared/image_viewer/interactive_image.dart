import 'dart:io';

import 'package:flutter/material.dart';
import 'package:newsapplication/download_files/download_files.dart';
import 'package:newsapplication/models/post/posts_manager.dart';
import 'package:newsapplication/shared/components/components.dart';
import 'package:provider/provider.dart';

class InteractiveImage extends StatefulWidget {
  const InteractiveImage(
      {Key? key, required this.images, int selectedIndex = 0})
      : super(key: key);
  final List<dynamic> images;

  @override
  _InteractiveImageState createState() => _InteractiveImageState();
}

class _InteractiveImageState extends State<InteractiveImage> {
  bool _isVisible = true;

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
                        scrollDirection: Axis.horizontal,
                        children: widget.images
                            .map(
                              (image) => Stack(
                                children: [
                                  if (image.runtimeType == String)
                                    Selector<PostsManager, String?>(
                                        selector: (context, value) =>
                                            value.imageLocalUrl(image),
                                        builder: (context, value, child) =>
                                            Stack(
                                              children: [
                                                DownloadButton(
                                                    url: image,
                                                    folder: 'Yemen Net'),
                                                if (value != null)
                                                  defaultPhotoView(
                                                      value: File(value),
                                                      onPressed: () {},
                                                      disableGestures: false),
                                              ],
                                            ))
                                  else
                                    defaultPhotoView(
                                        value: image,
                                        onPressed: () {},
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
                          backgroundColor: Colors.black54,
                          title: Text(
                            "${1} of ${widget.images.length}",
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
                          color: Colors.black54,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.download,
                                  color: Colors.white,
                                ),
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
