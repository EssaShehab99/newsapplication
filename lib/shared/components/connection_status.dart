import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectionStatus extends StatefulWidget {
  ConnectionStatus({Key? key}) : super(key: key);

  @override
  _ConnectionStatusState createState() => _ConnectionStatusState();
}

class _ConnectionStatusState extends State<ConnectionStatus> {
  bool connect = false;

  Future<void> check() async {
if(mounted)
  connect = await InternetConnectionChecker().hasConnection;

    StreamSubscription<InternetConnectionStatus> listener =
        InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            connect = true;
            break;
          case InternetConnectionStatus.disconnected:
            connect = false;
            break;
        }
      },
    );

    // close listener after 30 seconds, so the program doesn't run forever
    await Future<void>.delayed(const Duration(seconds: 30));
    await listener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    check();
    return AnimatedOpacity(
      opacity: connect ? 0.0 : 1.0,
      duration: Duration(seconds: 1),
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 25.0,
        color: connect ? Colors.green : Colors.red,
        child: Text(connect ?'Connected':'You are not connect'),
      ),
    );
  }
}
