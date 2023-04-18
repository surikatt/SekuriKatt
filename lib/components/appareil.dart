import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppareilCard extends HookConsumerWidget {
  const AppareilCard({super.key, required this.nom});

  final String nom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(children: [
          Icon(
            Icons.door_sliding_rounded,
            size: 32,
          ),
          SizedBox(
            width: 24,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nom,
                  style: Theme.of(context).typography.englishLike.titleMedium),
              Row(
                children: [
                  Text(
                    "Connecté",
                    style: Theme.of(context)
                        .typography
                        .englishLike
                        .bodyLarge!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  ClipOval(
                    child: Container(
                      height: 20,
                      width: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                ],
              ),
            ],
          )
        ]),
      ),
    );
  }
}
