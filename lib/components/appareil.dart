import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppareilCard extends HookConsumerWidget {
  AppareilCard({super.key, required this.nom, required this.connecte});

  final String nom;
  bool connecte = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Container(
        height: 82,
        padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.door_sliding_rounded,
              size: 32,
            ),
            SizedBox(
              width: 24,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nom,
                    style:
                        Theme.of(context).typography.englishLike.titleMedium),
                Row(
                  children: [
                    Text(
                      connecte ? "Connecté" : "Déconnecté",
                      style: Theme.of(context)
                          .typography
                          .englishLike
                          .bodyLarge!
                          .copyWith(
                              color: connecte
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.error),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    ClipOval(
                      child: Container(
                        height: 20,
                        width: 20,
                        color: connecte
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            InkWell(
              child: SizedBox(
                width: 82,
                height: 82,
                child: Center(child: Icon(Icons.info_outline_rounded)),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
