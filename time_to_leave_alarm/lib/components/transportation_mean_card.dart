import 'package:flutter/material.dart';

class TransportationMeanCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool selected;
  final Function()? callback;

  const TransportationMeanCard({Key? key,
    required this.icon,
    required this.text,
    this.selected = false,
    this.callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: GestureDetector(
        onTap: callback,
        child: Card(
          color: selected ? Theme
              .of(context)
              .primaryColor : Colors.white,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Theme
                  .of(context)
                  .primaryColor, width: 1),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [Icon(icon), Text(text, style: const TextStyle(fontSize: 12),)],
            ),
          ),
        ),),
    );
  }
}
