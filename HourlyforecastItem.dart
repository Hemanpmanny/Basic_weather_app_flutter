import "package:flutter/material.dart";

class HourlyforecastItem extends StatelessWidget {
  final String time;
  final String temperature;
  final IconData icon;
  const HourlyforecastItem(
      {super.key,
      required this.time,
      required this.temperature,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Text(
                  time,
                  style: const TextStyle(
                      fontSize: 23, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 5,
                ),
                Icon(
                  icon,
                  size: 34,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  temperature,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
