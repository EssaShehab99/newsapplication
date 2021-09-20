import 'package:flutter/material.dart';
import 'package:newsapplication/shared/components/constants.dart';
import 'package:newsapplication/shared/components/download_button.dart';
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
      this.icon,
      this.onPressed})
      : super(key: key);
  final List<dynamic>? images;
  final IconData? icon;
  final Function? onPressed;

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
          borderRadius: BorderRadius.circular(borderRadius),
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
                    },
                    child: DefaultBoxImage(
                      images: widget.images!,
                      index: widget.images!.indexOf(image),
                    ),
                  ),
              if (widget.onPressed != null && widget.icon != null)
                IconButton(
                  onPressed: () async {
                    widget.onPressed!();
                    setState(() {});
                  },
                  icon: Icon(widget.icon),
                )
            ],
            options: CarouselOptions(
              enableInfiniteScroll: false,
              enlargeCenterPage: true,
              viewportFraction: 1,
              height: 215,
            ),
          ),
        ),
      ),
    );
  }
}

class DefaultBoxImage extends StatelessWidget {
  const DefaultBoxImage({Key? key, required this.images, required this.index})
      : super(key: key);
  final List<dynamic> images;
  final index;

  @override
  Widget build(BuildContext context) {
    if (images.isNotEmpty) {
      return Card(
        margin: EdgeInsets.all(0.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => InteractiveImage(
                                  images: images,
                                  index: index,
                                )));
                  },
                  child: images[index].runtimeType == String
                      ? Consumer<FilesManager>(
                          builder: (context, value, child) => Stack(
                                children: [
                                  DownloadButton(
                                      remoteUrl: images[index],
                                      folder: 'Yemen Net'),
                                  if (value.fileInDatabase(images[index]) !=
                                      null)
                                    defaultPhotoView(
                                        value: File(value
                                            .fileInDatabase(images[index])!),
                                        onPressed: () {}),
                                ],
                              ))
                      : defaultPhotoView(
                          value: images[index], onPressed: () {})),
            ),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
