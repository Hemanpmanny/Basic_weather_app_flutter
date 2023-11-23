import "package:flutter/material.dart";

class AdditionalinfoItem extends StatelessWidget {
  final IconData icon;
  final String lable;
  final String value;
  const AdditionalinfoItem(
      {super.key,
      required this.icon,
      required this.lable,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32),
        const SizedBox(
          height: 10,
        ),
        Text(
          lable,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
