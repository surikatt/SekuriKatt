import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

import './components/app_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final _defaultLightColorScheme =
      ColorScheme.fromSwatch(primarySwatch: Colors.blue);

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.blue, brightness: Brightness.dark);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DynamicColorPlugin.getCorePalette().then((value) => print("Got theme: $value"));

    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          print("Dark: $darkDynamic, Light: $lightDynamic");

      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: lightDynamic ?? _defaultLightColorScheme,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkDynamic ?? _defaultDarkColorScheme,
          useMaterial3: true,
        ),
        themeMode: ThemeMode.dark,
        home: App(),
      );
    });
  }
}

class App extends StatelessWidget {
  App({super.key});

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
                  //CameraView(),
                ],
              ),
            ),
          ),
        ));
  }
}

class CameraView extends StatelessWidget {
  CameraView({super.key});

  final VlcPlayerController _vlcViewController = VlcPlayerController.network(
      "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
      autoPlay: true,
      options: VlcPlayerOptions(
          video: VlcVideoOptions([VlcVideoOptions.dropLateFrames(true)]),
          http: VlcHttpOptions([VlcHttpOptions.httpReconnect(true)])));

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Caméras",
                style: Theme.of(context).typography.tall.headlineLarge,
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                children: <Widget>[
                  Image.network(
                    "https://static.vecteezy.com/system/resources/previews/005/261/421/original/cctv-camera-icon-security-camera-icon-free-vector.jpg",
                    height: 40,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Salon',
                        style: Theme.of(context).typography.tall.titleLarge,
                      ),
                      Text(
                        'Il y a deux minutes',
                        style: Theme.of(context).typography.tall.bodyMedium,
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              VlcPlayer(
                controller: _vlcViewController,
                aspectRatio: 16 / 9,
                placeholder: Text(
                  "Loading",
                  style: Theme.of(context).typography.dense.bodyLarge,
                ),
              ),
            ],
          )),
    );
  }
}
