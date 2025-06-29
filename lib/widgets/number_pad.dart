import 'package:flutter/material.dart';
import 'package:numbersgame/const.dart';

class MyButton extends StatelessWidget {
  final String child;
  final VoidCallback onTap;
  var buttonColor = Colors.deepPurple[400];

  MyButton({super.key, required this.child, required this.onTap}) : super();

  @override
  Widget build(BuildContext context) {
    // if (child == 'DEL') {
    //   buttonColor = Colors.redAccent;
    // } else 
    if (child == '⌫') {
      buttonColor = Colors.transparent;
    } 
    else if (child.isEmpty) {
      buttonColor = Colors.transparent;
      // return const SizedBox.shrink();
    }

    // if (child == '=') {
    //   // make this button take 2 columns
    //   return Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    //     child: GestureDetector(
    //       onTap: onTap,
    //       child: Container(
    //         decoration: BoxDecoration(
    //           color: Colors.green,
    //           borderRadius: BorderRadius.circular(8),
    //         ),
    //         child: Center(
    //           child: Text(
    //             child,
    //             style: whiteTextStyle.copyWith(fontSize: 32),
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
    // }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(child: Text(child, style: whiteTextStyle.copyWith(
            color: child == '⌫' ? Colors.orangeAccent : Colors.white,
            fontSize: child == '⌫' ? 40 : 32,
          ))),
        ),
      ),
    );
  }
}
