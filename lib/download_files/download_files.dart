import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flowder/flowder.dart';
import 'package:newsapplication/models/post/post.dart';
import 'package:newsapplication/models/post/posts_manager.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class DownloadButton extends StatefulWidget {
  const DownloadButton({
    Key? key,
    required this.url,
    required this.folder,
    this.extension = 'jpg',
  }) : super(key: key);

  final String folder;

  final String url;

  final String extension;

  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  DownloaderUtils? options;
  DownloaderCore? core;
  String? path;
  double value = 0.0;
  bool isDownload = false;
  String? localPath;
  PostsManager? _postsManager;

  @override
  void initState() {
    initPlatformState();
    super.initState();
    _postsManager = Provider.of<PostsManager>(context, listen: false);
  }
  @override
  void setState(fn) {
    if (mounted)    super.setState(fn);

  }
  Future<dynamic> downloadFile(
      {required String url,
        required String folder,
        String extension = 'jpg'}) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) await Permission.storage.request();

    String _filePath =
        '/storage/emulated/0/$folder/${DateTime.now()}.$extension';
    options = DownloaderUtils(
      progressCallback: (current, total) {
        final progress = (current / total);
        setState(() {
          value = progress;
        });
        print('Downloading: $progress');
      },
      file: File(_filePath),
      progress: ProgressImplementation(),
      onDone: () async {
        _postsManager?.downloadImage(localUrl: _filePath, remoteUrl: url);
        print('COMPLETE $localPath');
      },
      deleteOnCancel: true,
      /* client: Dio(BaseOptions(
            baseUrl: url,
            receiveTimeout: 1000,
            connectTimeout: 1000,
            sendTimeout: 1000))*/);
    core = await Flowder.download(url, options!);
  }

  Future<void> initPlatformState() async {
    if (!mounted)
    return;
  }

  void _setPath() async {
    path = (await getExternalStorageDirectory())!.path;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularPercentIndicator(
        radius: 50.0,
        lineWidth: 4.0,
        backgroundColor: Colors.black.withOpacity(0.0),
        percent: value.toDouble(),
        center: TextButton(
          onPressed: () async {
            if (isDownload) {
              core?.cancel();
              value = 0.0;
              isDownload = false;
              setState(() {});
            } else {
              isDownload = true;
              if (Provider.of<PostsManager>(context, listen: false)
                  .imageLocalUrl(widget.url) ==
                  null) downloadFile(url: widget.url, folder: widget.folder);
            }
            setState(() {});
          },
          style: TextButton.styleFrom(
              shape: CircleBorder(),
              backgroundColor: Colors.black.withOpacity(0.3),
              minimumSize: Size(50, 50)),
          child: Icon(
            isDownload ? Icons.stop : Icons.download,
            color: Colors.white,
          ),
        ),
        progressColor: Colors.orange,
      ),
    );
  }
}

