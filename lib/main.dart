import 'dart:convert';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_server_client.dart';
import 'package:sekuri_katt/components/appareil.dart';
import 'package:typed_data/src/typed_buffer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:developer' as d;

import './components/app_bar.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
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
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
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
      },
    );
  }
}

final routeProvider = Provider((_) => 'home');
final dataProvider = NotifierProvider<MqttData, Data>(MqttData.new);
final MqttServerClient client = MqttServerClient("172.16.28.48", '');

Future mqtt() async {
  client.logging(on: false);
  await client.connect();
  client.subscribe("telephone:alexis", MqttQos.exactlyOnce);

  client.updates.listen((event) {
    for (var element in event) {
      var payload = MqttUtilities.bytesToStringAsString(
          (element.payload as MqttPublishMessage).payload.message!);
      var message = jsonDecode(payload);
      print("Payload: $message");

      switch (message['type']) {
        case "appareils":
          break;
      }
    }
  });

  final builder = MqttPayloadBuilder();
  builder.addString('{"type": "requete", "requete": "appareils"}');

  client.publishMessage(
      "telephone:alexis", MqttQos.exactlyOnce, builder.payload!);
}

class Data {
  Data(
      {required this.appareils, required this.armee, required this.evenements});

  List appareils = [];
  List evenements = [];
  bool armee = false;
}

@Riverpod(keepAlive: true)
class MqttData extends Notifier<Data> {
  @override
  Data build() {
    return Data(appareils: [], armee: false, evenements: []);
  }

  bool waiting = false;

  mqtt() async {
    client.logging(on: false);
    await client.connect();
    print("Connected?: ${client.connectionStatus}");
    client.subscribe("telephone:alexis", MqttQos.exactlyOnce);
    client.subscribe("evenements", MqttQos.exactlyOnce);

    client.updates.listen((event) {
      for (var element in event) {
        var payload = MqttUtilities.bytesToStringAsString(
            (element.payload as MqttPublishMessage).payload.message!);
        var message = jsonDecode(payload);
        print("Payload: $message");

        waiting = false;

        switch (message['type']) {
          case "appareils":
            state = Data(
                appareils: message["data"],
                armee: state.armee,
                evenements: state.evenements);
            break;
          case "evenements":
            state = Data(
                appareils: state.appareils,
                armee: state.armee,
                evenements: message["data"]);
            break;
          case "maj":
            var index = state.appareils.indexWhere(
                (element) => element["id_appareil"] == message["appareil"]);
            print(index);
            state.appareils[index]["connecte"] = message["connecte"];
            state = Data(
                appareils: state.appareils,
                armee: state.armee,
                evenements: state.evenements);
        }
      }
    });

    fetch();
    fetch(type: "evenements");
  }

  void fetch({String type = "appareils"}) {
    final builder = MqttPayloadBuilder();
    builder.addString('{"type": "requete", "requete": "$type"}');

    client.publishMessage(
        "telephone:alexis", MqttQos.exactlyOnce, builder.payload!);
  }

  void armer() {
    final builder = MqttPayloadBuilder();
    builder.addString('{"type": "armement"}');

    client.publishMessage(
        "telephone:alexis", MqttQos.exactlyOnce, builder.payload!);
  }

  void desarmer() {
    final builder = MqttPayloadBuilder();
    builder.addString('{"type": "desarmement"}');

    client.publishMessage(
        "telephone:alexis", MqttQos.exactlyOnce, builder.payload!);
  }

  fetchData() async {
    waiting = true;
    final builder = MqttPayloadBuilder();
    builder.addString('{"type": "requete", "requete": "appareils"}');

    client.publishMessage(
        "telephone:alexis", MqttQos.exactlyOnce, builder.payload!);

    return Future.delayed(const Duration(seconds: 3));
  }
}

class App extends StatefulHookConsumerWidget {
  const App({super.key});

  @override
  createState() => AppState();
}

class AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
    ref.read(dataProvider.notifier).mqtt();
  }

  @override
  void didChangeDependencies() {
    /// connect to the MQTT server
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //final String route = ref.watch(routeProvider);
    final Data data = ref.watch(dataProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SizedBox.expand(
          child: Container(
            color: Theme.of(context).colorScheme.background,
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      child:
                          NotificationListener<OverscrollIndicatorNotification>(
                        onNotification:
                            (OverscrollIndicatorNotification overscroll) {
                          overscroll.disallowIndicator();
                          return false;
                        },
                        child: CustomScrollView(
                          shrinkWrap: false,
                          slivers: [
                            ExtendedAppBar(),
                            SliverList(
                                delegate: SliverChildBuilderDelegate(
                              childCount: data.appareils.length,
                              (context, index) {
                                var appareil = data.appareils[index];

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AppareilCard(
                                      nom: appareil["nom"],
                                      connecte: appareil["connecte"]),
                                );
                              },
                            )),
                            SliverList(
                                delegate: SliverChildBuilderDelegate(
                              childCount: data.evenements.length,
                              (context, index) {
                                var ev = data.evenements[index];

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          "${ev["type"]}: ${ev["date"]}, (${ev["id_appareil"]})",
                                          style: Theme.of(context)
                                              .typography
                                              .englishLike
                                              .bodyMedium),
                                    ),
                                  ),
                                );
                              },
                            )),
                          ],
                        ),
                      ),
                      onRefresh: () =>
                          ref.read(dataProvider.notifier).fetchData(),
                    ),
                  ),
                  InfoModule(),
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
