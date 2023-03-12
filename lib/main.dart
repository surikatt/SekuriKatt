import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

import './components/app_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: App(),
    );
  }
}

class App extends StatelessWidget {
  App({super.key});

  final VlcPlayerController _vlcViewController = VlcPlayerController.network(
      "test",
      autoPlay: true,
      options: VlcPlayerOptions(
          video: VlcVideoOptions([VlcVideoOptions.dropLateFrames(true)]),
          http: VlcHttpOptions([VlcHttpOptions.httpReconnect(true)])));

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SizedBox.expand(
          child: Container(
            color: Theme.of(context).colorScheme.background,
            child: SafeArea(
              child: Column(
                children: [
                  const ExtendedAppBar(),
                  VlcPlayer(
                    controller: _vlcViewController,
                    aspectRatio: 16 / 9,
                    placeholder: Text(
                      "Loading",
                      style: Theme.of(context).typography.dense.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
