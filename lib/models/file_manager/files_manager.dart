import 'dart:io';

import 'package:flowder/flowder.dart';
import 'package:flutter/material.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:permission_handler/permission_handler.dart';

import 'file_manager.dart';

class FilesManager extends ChangeNotifier {
  List<FileManager> fileManagerList = [];
  bool _isDisposed = false;
  Map<String,double> value={};
  FilesManager();
  late DownloaderUtils options;
  late DownloaderCore core;
  late final String path;
  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
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
        progressValue(remoteUrl: url, value: progress);
        notifyListeners();
        print('Downloading: $progress');
      },
      file: File(_filePath),
      progress: ProgressImplementation(),
      onDone: () async {
        insertImageToDownload(
            remoteUrl: url, localUrl: _filePath);
        notifyListeners();
        print('COMPLETE ${fileInDatabase(url)}');
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
  // Future<void> initPlatformState() async {
  //   if (!mounted) return;
  // }
  Future<void> insertImageToDownload(
      {required String remoteUrl,
        required String? localUrl}) async {
    fileManagerList.add(
        FileManager(remoteUrl: remoteUrl, localUrl: localUrl));
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  String? fileInDatabase(imageUrl) {
    FileManager? localPath = fileManagerList
        .firstWhereOrNull((file) {
      return file.remoteUrl == imageUrl;
    });

    return localPath?.localUrl;
  }

  void progressValue({remoteUrl,value}){
    if(this.value.containsKey(remoteUrl))
      this.value.update(remoteUrl, (_) => value);
    else
      this.value[remoteUrl]=value;

    if (!_isDisposed) {
      notifyListeners();
    }
  }
  void cancelDownload({required String remoteUrl}){
    if(this.value.containsKey(remoteUrl))
      this.value.remove(remoteUrl);
    if (!_isDisposed) {
      notifyListeners();
      core.cancel();
    }
  }
}