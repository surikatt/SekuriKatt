import 'package:flutter/material.dart';

class ExtendedAppBar extends StatelessWidget {
  const ExtendedAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 150,
            ),
            Text(
              "SekuriKatt",
              style: Theme.of(context).typography.tall.headlineLarge,
            ),
            const SizedBox(height: 20),
            Text(
              "Votre maison est sécurisée!",
              style: Theme.of(context).typography.tall.bodyLarge,
            ),
            const SizedBox(height: 40),
            Column(
              children: [
                InfoModule(),
                Divider(),
                InfoModule(),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class InfoModule extends StatelessWidget {
  const InfoModule({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Icon(
            Icons.camera_indoor_rounded,
            size: 48,
          ),
          const SizedBox(
            height: 25,
          ),
          SizedBox(
            height: 40,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(
                "4 caméras",
                style: Theme.of(context).typography.englishLike.bodyLarge,
              ),
            ),
          ),
        ]),
        Text(
          "Dernier évènement il y a 10 minutes",
          style: Theme.of(context)
              .typography
              .englishLike
              .labelLarge!
              .copyWith(color: Theme.of(context).disabledColor),
        )
      ],
    );
  }
}
