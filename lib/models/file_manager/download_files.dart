import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flowder/flowder.dart';
import 'package:newsapplication/models/file_manager/files_manager.dart';
import 'package:newsapplication/models/post/post.dart';
import 'package:newsapplication/models/post/posts_manager.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class DownloadFile extends StatefulWidget {
  DownloadFile(
      {Key? key,
      required this.remoteUrl,
      required this.folder,
      this.extension = 'jpg'})
      : super(key: key);

  final String folder;
  final String remoteUrl;
  final String extension;

  @override
  State<DownloadFile> createState() => _DownloadFileState();
}

class _DownloadFileState extends State<DownloadFile> {
  String? localUrl;
  late DownloaderUtils options;
  late DownloaderCore core;
  late final String path;
  String? localPath;

  FilesManager? _fileManager;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _fileManager = Provider.of<FilesManager>(context, listen: false);
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
        _fileManager?.progressValue(remoteUrl: url, value: progress);
        print('Downloading: $progress');
      },
      file: File(_filePath),
      progress: ProgressImplementation(),
      onDone: () async {
        _fileManager?.downloadImage(
            remoteUrl: widget.remoteUrl, localUrl: _filePath);

        print('COMPLETE ${_fileManager?.imageLocalUrl(widget.remoteUrl)}');
      },
      deleteOnCancel: true,
      /* client: Dio(BaseOptions(
            baseUrl: url,
            receiveTimeout: 1000,
            connectTimeout: 1000,
            sendTimeout: 1000))*/
    );
    core = await Flowder.download(url, options);
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<FilesManager>(
        builder: (context, value, child) => CircularPercentIndicator(
          radius: 50.0,
          lineWidth: 4.0,
          backgroundColor: Colors.black.withOpacity(0.0),
          percent: _fileManager?.value[widget.remoteUrl] ?? 0.0,
          center: TextButton(
            onPressed: () async {
              if (_fileManager?.value.containsKey(widget.remoteUrl) == true &&
                  _fileManager!.value[widget.remoteUrl]! > 0) {
                _fileManager?.cancelDownload(remoteUrl: widget.remoteUrl);
                return core.cancel();
              } else {
                if (_fileManager?.imageLocalUrl(widget.remoteUrl) == null &&
                    _fileManager?.value.containsKey(widget.remoteUrl) != true) {
                  downloadFile(url: widget.remoteUrl, folder: widget.folder);
                }
              }
            },
            style: TextButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: Colors.black.withOpacity(0.3),
                minimumSize: Size(50, 50)),
            child: Icon(
              _fileManager?.value.containsKey(widget.remoteUrl) == true
                  ? Icons.stop
                  : Icons.download,
              color: Colors.white,
            ),
          ),
          progressColor: Colors.orange,
        ),
      ),
    );
  }
}

/*
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
*/

/*class _DownloadButtonState extends State<DownloadButton> {
  DownloaderUtils? options;
  DownloaderCore? core;
  String? path;
  bool isDownload = false;
  String? localPath;
  FilesManager? _fileManager;

  @override
  void initState() {
    initPlatformState();
    super.initState();
    _fileManager = Provider.of<FilesManager>(context, listen: false);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<dynamic> downloadFile({required String url,
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
          _fileManager
          ?.
          =
          progress;
        });
        print('Downloading: $progress');
      },
      file: File(_filePath),
      progress: ProgressImplementation(),
      onDone: () async {
        _fileManager?.downloadImage(localUrl: _filePath, remoteUrl: url);
        print('COMPLETE $localPath');
      },
      deleteOnCancel: true,
      */ /* client: Dio(BaseOptions(
            baseUrl: url,
            receiveTimeout: 1000,
            connectTimeout: 1000,
            sendTimeout: 1000))*/ /*
    );
    core = await Flowder.download(url, options!);
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
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
        percent: _fileManager?.value.toDouble() ?? 0.0,
        center: TextButton(
          onPressed: () async {
            if (isDownload) {
              core?.cancel();
              _fileManager?.value = 0.0;
              isDownload = false;
              setState(() {});
            } else {
              if (_fileManager?.imageLocalUrl(widget.url) == null)
                downloadFile(url: widget.url, folder: widget.folder);
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
}*/
