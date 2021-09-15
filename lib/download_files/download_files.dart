import 'dart:io';

import 'package:flowder/flowder.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DownloadFiles extends StatefulWidget {
  const DownloadFiles({
    Key? key,
    required this.url,
    required this.folder,
    this.extension = 'jpg',
  }) : super(key: key);

  final String folder;

  final String url;

  final String extension;

  @override
  _DownloadFilesState createState() => _DownloadFilesState();
}

class _DownloadFilesState extends State<DownloadFiles> {
  late DownloaderUtils options;
  late DownloaderCore core;
  late final String path;
  double value = 0.0;
  bool isDownload = false;

  String? localPath;

  Future downloadLocal(
      {required String url,
      required String folder,
      String extension = 'jpg'}) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    else return;
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
      onDone: () {
        localPath = _filePath;
        setState(() {});
        print('COMPLETE $localPath');
      },
      deleteOnCancel: true,
    );
    core = await Flowder.download(url, options);
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
    initPlatformState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return localPath == null
        ? Center(
            child: CircularPercentIndicator(
              radius: 50.0,
              lineWidth: 4.0,
              backgroundColor: Colors.black.withOpacity(0.0),
              percent: value.toDouble(),
              center: TextButton(
                onPressed: () async {
                  if (isDownload)
                  return  core.cancel();
                  else {
                    isDownload = true;
                    downloadLocal(url: widget.url, folder: widget.folder);
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
          )
        : Image.file(File(localPath!));
  }
}
