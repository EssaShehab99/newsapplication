import 'package:flowder/flowder.dart';
import 'package:flutter/material.dart';
import 'package:newsapplication/models/file_manager/download_files.dart';
import 'package:newsapplication/models/file_manager/files_manager.dart';
import 'package:newsapplication/shared/components/components.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import 'interactive_image.dart';

class PhotoViewer extends StatefulWidget {
  PhotoViewer({
    Key? key,
    required this.images,
    required Function(DismissDirection) this.onDismissed,
    this.enableInfiniteScroll = true,
  }) : super(key: key);
  final List<dynamic>? images;
  final bool enableInfiniteScroll;

  @override
  _PhotoViewerState createState() => _PhotoViewerState();

  final Function onDismissed;
}

class _PhotoViewerState extends State<PhotoViewer> {
  @override
  Widget build(BuildContext context) {
    return widget.images == null
        ? SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(0.0),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CarouselSlider(
                  items: widget.images != null
                      ? widget.images?.map(
                          (image) {
                            return Dismissible(
                              direction: widget.images![0].runtimeType == String
                                  ? DismissDirection.none
                                  : DismissDirection.down,
                              key: Key(image.toString()),
                              onDismissed: (_) {
                                widget.images
                                    ?.removeAt(widget.images!.indexOf(image));
                                setState(() {});
                                print(image.absolute);
                              },
                              child: DefaultBoxImage(
                                images: widget.images!,
                                image: image,
                              ),
                            );
                          },
                        ).toList()
                      : [],
                  options: CarouselOptions(
                    enableInfiniteScroll: false,
                    enlargeCenterPage: false,
                    viewportFraction: widget.enableInfiniteScroll ? 0.8 : 1,
                    height: 220,
                  ),
                ),
              ),
            ),
          );
  }
}

class DefaultBoxImage extends StatefulWidget {
  const DefaultBoxImage({Key? key, required this.images, required this.image})
      : super(key: key);
  final List<dynamic> images;
  final image;

  @override
  _DefaultBoxImageState createState() => _DefaultBoxImageState();
}

class _DefaultBoxImageState extends State<DefaultBoxImage> {
  late DownloaderUtils options;
  late DownloaderCore core;
  late final String path;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => InteractiveImage(
                                images: widget.images,
                                index: widget.images.indexOf(widget.image),
                              )));
                },
                child: widget.image.runtimeType == String
                    ? Consumer<FilesManager>(
                        builder: (context, value, child) => Stack(
                              children: [
                                DownloadFile(
                                    remoteUrl: widget.image,
                                    folder: 'Yemen Net'),
                                if (value.imageLocalUrl(widget.image) != null)
                                  defaultPhotoView(
                                      value: File(value.imageLocalUrl(widget.image)!), onPressed: () {}),
                              ],
                            ))
                    : defaultPhotoView(value: widget.image, onPressed: () {})),
          ),
        ],
      ),
    );
  }
}
