import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:ftpconnect/ftpconnect.dart';

class FtpUtility {
  final String host;
  final int port;
  final String user;
  final String password;

  FtpUtility({
    required this.host,
    this.port = 21,
    required this.user,
    required this.password,
  });

  Future<void> uploadFileInIsolate(
      String localFilePath, String remoteFilePath) async {
    final ReceivePort receivePort = ReceivePort();

    await Isolate.spawn(
      _uploadFileIsolate,
      _IsolateData(
        host: host,
        port: port,
        user: user,
        password: password,
        localFilePath: localFilePath,
        remoteFilePath: remoteFilePath,
        sendPort: receivePort.sendPort,
      ),
    );

    receivePort.listen((message) {
      if (message is String) {
        log('Upload complete: $message');
      } else if (message is Exception) {
        log('Upload error: $message');
      }

      receivePort.close();
    });
  }

  static void _uploadFileIsolate(_IsolateData data) async {
    try {
      final ftpClient = FTPConnect(
        data.host,
        user: data.user,
        pass: data.password,
        port: data.port,
      );

      await ftpClient.connect();
      await ftpClient.uploadFile(
        File(data.localFilePath),
        sRemoteName: data.remoteFilePath,
      );

      await ftpClient.disconnect();

      data.sendPort.send('Upload complete');
    } catch (e) {
      data.sendPort.send(Exception('Upload error: $e'));
    }
  }
}

class _IsolateData {
  final String host;
  final int port;
  final String user;
  final String password;
  final String localFilePath;
  final String remoteFilePath;
  final SendPort sendPort;

  _IsolateData({
    required this.host,
    required this.port,
    required this.user,
    required this.password,
    required this.localFilePath,
    required this.remoteFilePath,
    required this.sendPort,
  });
}
