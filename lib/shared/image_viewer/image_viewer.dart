import 'package:flowder/flowder.dart';
import 'package:flutter/material.dart';
import 'package:http/src/response.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' show get;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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
                      child: DefaultBoxImage(images: widget.images!, image: image,download: false,),
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
  const DefaultBoxImage({Key? key, required this.images,required this.image,this.download=true}) : super(key: key);
  final List<dynamic> images;
  final  image;

  final bool  download;
  @override
  _DefaultBoxImageState createState() => _DefaultBoxImageState();
}

class _DefaultBoxImageState extends State<DefaultBoxImage> {
  bool  download=true;

  late DownloaderUtils options;
  late DownloaderCore core;
  late final String path;

downloadimage() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }

  options = DownloaderUtils(
    progressCallback: (current, total) {
      final progress = (current / total) * 100;
      print('Downloading: $progress');
    },
    file: File('/storage/emulated/0/200MB.jpg'),
    progress: ProgressImplementation(),
    onDone: () => print('COMPLETE $path' ),
    deleteOnCancel: true,
  );
  core = await Flowder.download(
      'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png',
      options);

}
  Future<void> initPlatformState() async {
    _setPath();
    if (!mounted) return;
  }

  void _setPath() async {
    path = (await getExternalStorageDirectory())!.path;
  }

  @override
  void initState() {
    download=widget.download;
    initPlatformState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          if(widget.image.runtimeType!=String||(widget.image.runtimeType==String&&download))
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
                              selectedIndex:widget.images.indexOf(widget.image),
                            )));
              },
              child: PhotoView(
                disableGestures: true,
                imageProvider: DefaultInteractiveImage.imageProvider(widget.image),
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
          if(widget.image.runtimeType==String&&download==false)
            Center(
            child: ElevatedButton(
              onPressed: () {

                download=true;
                setState(() {

                });
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

