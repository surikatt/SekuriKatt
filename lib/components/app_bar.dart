import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekuri_katt/main.dart';

class ExtendedAppBar extends StatelessWidget {
  const ExtendedAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      pinned: true,
      expandedHeight: 400,
      flexibleSpace: FlexibleSpace(),
    );
  }
}

class FlexibleSpace extends HookConsumerWidget {
  const FlexibleSpace({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(builder: (context, c) {
      final settings = context
          .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
      final deltaExtent = settings!.maxExtent - settings.minExtent;
      final t =
          (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
              .clamp(0.0, 1.0);
      final fadeStart = max(0.0, 1.0 - kToolbarHeight / deltaExtent);
      const fadeEnd = 1.0;
      final factor = 1.0 - Interval(fadeStart, fadeEnd).transform(t);
      final textSize = 100 * const Interval(0.2, 1).transform(t);

      return Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                "Surikatt",
                style: Theme.of(context).typography.tall.headlineLarge,
              ),
            ),
          ),
          const Divider(),
        ],
      );
    });
  }
}

class InfoModule extends HookConsumerWidget {
  const InfoModule({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    var armee = ref.read(dataProvider).armee;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 25.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 90,
              color: Theme.of(context).colorScheme.surface,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  IconePanel(
                    Icons.home_rounded,
                    label: "Accueil",
                    selected: true,
                  ),
                  IconePanel(Icons.camera_indoor_rounded, label: "Appareils"),
                  IconePanel(
                    Icons.history_rounded,
                    label: "Historique",
                  ),
                  IconePanel(Icons.admin_panel_settings_rounded,
                      label: "Gérer"),
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 90),
          alignment: Alignment.topCenter,
          child: FloatingActionButton(
            child: armee
                ? Icon(Icons.warning_rounded)
                : Icon(Icons.check_circle_rounded),
            onPressed: () {
              armee
                  ? ref.read(dataProvider.notifier).desarmer()
                  : ref.read(dataProvider.notifier).armer();
            },
          ),
        ),
      ],
    );
  }
}

class IconePanel extends StatelessWidget {
  const IconePanel(this.iconData,
      {super.key, required this.label, this.selected = false});
  final IconData iconData;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    Color bgColor = selected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.surface;
    Color fgColor = selected
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSurface;

    return Expanded(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(side: BorderSide.none),
              backgroundColor: bgColor,
              foregroundColor: fgColor),
          onPressed: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 34,
              ),
              const SizedBox(height: 2),
              FittedBox(
                child: Text(label),
              ),
            ],
          )),
    );
  }
}
