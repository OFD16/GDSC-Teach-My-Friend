import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RateCard extends StatelessWidget {
  final String? rate;

  RateCard({this.rate});

  @override
  Widget build(BuildContext context) {
    if (rate == null) {
      return const SizedBox();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Text(
                "$rate",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              SvgPicture.asset("assets/icons/Star Icon.svg"),
            ],
          ),
        ),
      ],
    );
  }
}
