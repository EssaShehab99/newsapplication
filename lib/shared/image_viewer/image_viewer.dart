import 'dart:io';
import 'package:flutter/material.dart';
import 'package:newsapplication/models/post/posts_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';


class PhotoViewer extends StatefulWidget {
  PhotoViewer({Key? key, required this.images,required Function(DismissDirection) this.onDismissed}) :super(key: key);
  final List<dynamic>? images;

  @override
  _PhotoViewerState createState() => _PhotoViewerState();

 final Function onDismissed ;
}

class _PhotoViewerState extends State<PhotoViewer> {


  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CarouselSlider(
                items: widget.images!=null?widget.images
                    ?.map((image) {
                      return Dismissible(
                      direction: DismissDirection.down,
                      key: Key(image.toString()),
                      onDismissed: (_){
                        widget.images?.removeAt(widget.images!.indexOf(image));
                        setState(() {

                        });
                        print(image.absolute);
                      },
                      child: DefaultBoxImage(images: widget.images!, initialIndex: widget.images!.indexOf(image)),
                    );
                    },
                  )
                    .toList():[],
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  height: 220,
                ),
              ),
            ),
          ),
        );
  }
}

class DefaultBoxImage extends StatefulWidget {
  const DefaultBoxImage({Key? key, required this.images,required this.initialIndex}) : super(key: key);
  final List<dynamic> images;
  final int initialIndex;
  @override
  _DefaultBoxImageState createState() => _DefaultBoxImageState();
}

class _DefaultBoxImageState extends State<DefaultBoxImage> {
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
                        builder: (_) =>
                            DefaultInteractiveImage(
                              images: widget.images,
                              selectedIndex: widget.initialIndex,
                            )));
              },
              child: PhotoView(
                disableGestures: true,
                imageProvider: DefaultInteractiveImage.imageProvider(widget.images[widget.initialIndex]),
                initialScale: PhotoViewComputedScale
                    .covered,
                errorBuilder: (context, error,
                    stackTrace) =>
                    Center(
                      child: ElevatedButton(
                        onPressed: () {

                        },
                        style: ElevatedButton
                            .styleFrom(
                            shape: CircleBorder(),
                            primary: Colors.white
                                .withOpacity(0.5),
                            minimumSize: Size(
                                50, 50)),
                        child: const Icon(
                          Icons.refresh,
                          color: Colors.black,
                        ),
                      ),
                    ),
                loadingBuilder: (context, event) =>
                    Center(
                      child: SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          value: event == null
                              ? 0
                              : event
                              .cumulativeBytesLoaded /
                              event
                                  .expectedTotalBytes!,
                        ),
                      ),
                    ),
              ),
            ),
          ),
          if(widget.images[widget.initialIndex].runtimeType==String)  Center(
            child: ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  primary: Colors.white.withOpacity(0.5),
                  minimumSize: Size(50, 50)),
              child: Icon(
                Icons.download,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DefaultInteractiveImage extends StatefulWidget {
  const DefaultInteractiveImage({Key? key, required this.images,required int selectedIndex}) : super(key: key);
  final List<dynamic> images;
  static ImageProvider imageProvider(image) {
    if(image.runtimeType==String)return NetworkImage(image);
    else return FileImage(image);
  }
  @override
  State<DefaultInteractiveImage> createState() =>
      _DefaultInteractiveImageState();
}

class _DefaultInteractiveImageState extends State<DefaultInteractiveImage> {
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
                        children: widget.images.map((image) =>
                            Stack(
                              children: [

                                PhotoView(
                                  imageProvider: DefaultInteractiveImage.imageProvider(image),
                                  initialScale: PhotoViewComputedScale.contained,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Center(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // images[images.indexOf(e)]
                                            //     .localUrl = 'assets/images/a.png';
                                            // setState(() {});
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: CircleBorder(),
                                              primary: Colors.white.withOpacity(
                                                  0.5),
                                              minimumSize: Size(50, 50)),
                                          child: const Icon(
                                            Icons.refresh,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                  loadingBuilder: (context, event) =>
                                      Center(
                                        child: SizedBox(
                                          width: 20.0,
                                          height: 20.0,
                                          child: CircularProgressIndicator(
                                            value: event == null
                                                ? 0
                                                : event.cumulativeBytesLoaded /
                                                event.expectedTotalBytes!,
                                          ),
                                        ),
                                      ),
                                  onTapDown: (context, details, controllerValue) {
                                    _isVisible = !_isVisible;
                                    setState(() {});
                                  },
                                  minScale: PhotoViewComputedScale.contained * 1,
                                  maxScale: PhotoViewComputedScale.covered * 2.0,
                                ),
                              ],
                            ),).toList(),
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
