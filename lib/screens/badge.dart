// badge widget to display a badge
import 'package:flutter/material.dart';

class BadgeWidget extends StatelessWidget {
  final String badgeName;
  final String badgeIcon;
  final bool unlocked;
  final String description;

  const BadgeWidget({
    super.key,
    required this.badgeName,
    required this.badgeIcon,
    required this.unlocked,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(8.0),
      // ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ColorFiltered(
              colorFilter: unlocked
                  ? const ColorFilter.mode(
                      Colors.transparent,
                      BlendMode.multiply,
                    )
                  : const ColorFilter.matrix(<double>[
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0,      0,      0,      1, 0,
                    ]),
              child: Image.asset(
                badgeIcon,
                // fit: BoxFit.cover,
                height: 120,
                width: 120,
                opacity: AlwaysStoppedAnimation(unlocked?1:0.5),),
            ),
          ),
          // const SizedBox(height: 8.0),
          Text(
            badgeName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          ),
          // const SizedBox(height: 4.0),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12.0, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
