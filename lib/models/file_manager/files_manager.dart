import 'package:flutter/material.dart';
import 'package:collection/src/iterable_extensions.dart';

import 'file_manager.dart';

class FilesManager extends ChangeNotifier {
  List<FileManager> fileManagerList = [];
  bool _isDisposed = false;
  Map<String,double> value={};

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

  Future<void> downloadImage(
      {required String remoteUrl,
      required String? localUrl}) async {
    fileManagerList.add(
        FileManager(remoteUrl: remoteUrl, localUrl: localUrl));
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  String? imageLocalUrl(imageUrl) {
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
}
