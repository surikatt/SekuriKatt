import 'package:flutter/material.dart';

class ExtendedAppBar extends StatelessWidget {
  const ExtendedAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(12),
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
            Text(
              "Votre maison est sécurisée!",
              style: Theme.of(context).typography.tall.bodyLarge,
            ),
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
    var theme = Theme.of(context);
    print(
        "Theme: ${theme.colorScheme.background} ${theme.cardColor} ${theme.colorScheme.surface}");

    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 25.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 90,
          color: Theme.of(context).colorScheme.surface,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              IconePanel(Icons.home_rounded, label: "Accueil", selected: true,),
              IconePanel(Icons.camera_indoor_rounded, label: "Caméras"),
              IconePanel(
                Icons.door_front_door_rounded,
                label: "Portes",
              ),
              IconePanel(
                Icons.history_rounded,
                label: "Historique",
              ),
              IconePanel(Icons.admin_panel_settings_rounded, label: "Gérer"),
            ],
          ),
        ),
      ),
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
    Color bgColor = selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface;
    Color fgColor = selected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface;

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
              SizedBox(height: 2),
              FittedBox(
                child: Text(label),
              ),
            ],
          )),
    );
  }
}
