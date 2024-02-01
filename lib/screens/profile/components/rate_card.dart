import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RateCard extends StatelessWidget {
  final double rate;

  RateCard({required this.rate});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 20),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Text(
                rate.toString(),
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
