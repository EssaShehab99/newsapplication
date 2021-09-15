import 'dart:io';

import 'package:flowder/flowder.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DownloadFiles extends StatefulWidget {
  const DownloadFiles({Key? key,required  this.url,required  this.folder, this.extension = 'jpg',}) : super(key: key);

final  String folder ;
  final   String url  ;
  final   String extension  ;

  @override
  _DownloadFilesState createState() => _DownloadFilesState();
}

class _DownloadFilesState extends State<DownloadFiles> {
  late DownloaderUtils options;
  late DownloaderCore core;
  late final String path;
  double value=0.0;

  Future downloadLocal({required String url,required String folder, String extension = 'jpg'}) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    options = DownloaderUtils(
      progressCallback: (current, total) {
        final progress = (current / total);
        setState(() {
          value=progress;
        });
        print('Downloading: $progress');
      },
      file: File('/storage/emulated/0/$folder/${DateTime.now()}.$extension'),
      progress: ProgressImplementation(),
      onDone: () => print('COMPLETE $path'),
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
    return  Center(
      child: CircularPercentIndicator(
        radius: 100.0,
        lineWidth: 10.0,
        percent: value.toDouble(),
        center: ElevatedButton(
          onPressed: () {
            downloadLocal(url: widget.url, folder: widget.folder);
          },
          style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              primary: Colors.white.withOpacity(0.5),
              minimumSize: Size(50, 50)),
          child: Icon(
            Icons.download,
            color: Colors.black45,
          ),
        ),
        progressColor: Colors.orange,
      ),
    );
  }
}

