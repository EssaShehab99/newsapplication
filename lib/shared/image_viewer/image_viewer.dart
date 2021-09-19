import 'package:flowder/flowder.dart';
import 'package:flutter/material.dart';
import 'package:newsapplication/models/file_manager/download_button.dart';
import 'package:newsapplication/models/file_manager/files_manager.dart';
import 'package:newsapplication/shared/components/components.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import 'interactive_image.dart';

class PhotoViewer extends StatefulWidget {
  PhotoViewer(
      {Key? key,
      required this.images,
      required Function(DismissDirection) this.onDismissed,
      this.enableInfiniteScroll = true,
    required  this.child})
      : super(key: key);
  final List<dynamic>? images;
  final bool enableInfiniteScroll;
  final Widget child;

  @override
  _PhotoViewerState createState() => _PhotoViewerState();

  final Function onDismissed;
}

class _PhotoViewerState extends State<PhotoViewer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CarouselSlider(
            items: [
              if (widget.images != null)
                for (var image in widget.images!)
                  defaultDismissible(
                    direction: image.runtimeType == String
                        ? DismissDirection.none
                        : DismissDirection.down,
                    key: image.toString(),
                    onDismissed: (_) {
                      widget.images?.removeAt(widget.images!.indexOf(image));
                      setState(() {});
                      print(image.absolute);
                    },
                    child: DefaultBoxImage(
                      images: widget.images!,
                      image: image,
                    ),
                  ),
              widget.child
            ],
            options: CarouselOptions(
              enableInfiniteScroll: false,
              enlargeCenterPage: false,
              viewportFraction: widget.enableInfiniteScroll ? 0.8 : 1.0,
              height: 215,
            ),
          ),
        ),
      ),
    );
  }
}

class DefaultBoxImage extends StatelessWidget {
  const DefaultBoxImage({Key? key, required this.images, required this.image})
      : super(key: key);
  final List<dynamic> images;
  final image;

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
                                images: images,
                                index: images.indexOf(image),
                              )));
                },
                child: image.runtimeType == String
                    ? Consumer<FilesManager>(
                        builder: (context, value, child) => Stack(
                              children: [
                                DownloadButton(
                                    remoteUrl: image, folder: 'Yemen Net'),
                                if (value.fileInDatabase(image) != null)
                                  defaultPhotoView(
                                      value: File(value.fileInDatabase(image)!),
                                      onPressed: () {}),
                              ],
                            ))
                    : defaultPhotoView(value: image, onPressed: () {})),
          ),
        ],
      ),
    );
  }
}
