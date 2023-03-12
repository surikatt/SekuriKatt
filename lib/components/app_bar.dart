import 'package:flutter/material.dart';

class ExtendedAppBar extends StatelessWidget {
  const ExtendedAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 250,
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "SekuriKatt",
              style: Theme.of(context).typography.tall.headlineLarge,
            ),
            const SizedBox(height: 20),
            Card(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Icon(Icons.camera), Icon(Icons.door_back_door)],
            ))
          ],
        ),
      ),
    );
  }
}
