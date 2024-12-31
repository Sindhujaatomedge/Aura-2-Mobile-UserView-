import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AttendanceCard extends StatelessWidget {
  final String title;
  final String count;
  final double percentage;
  final Color progressColor;
  final Color backgroundColor;
  final double elevation; // New property for elevation

  const AttendanceCard({
    Key? key,
    required this.title,
    required this.count,
    required this.percentage,
    required this.progressColor,
    required this.backgroundColor,
    this.elevation = 4.0, // Default elevation value
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Material(
      elevation: elevation, // Adding elevation
      shadowColor: Colors.grey.withOpacity(0.1), // Shadow color for elevation
      borderRadius: BorderRadius.circular(8), // Ensures shadow follows rounded corners
      color: Colors.transparent, // Ensure only shadow is visible outside
      child: Container(
        height: 130,
        width: 175,
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.2,
            color: const Color(0xFFE4E7EC),
          ),
          borderRadius: BorderRadius.circular(8), // Rounded corners
          color: Colors.white, // Background color inside the container
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF1D2939),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 17.0, top: 4),
              child: Text(
                count,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  color: Color(0xFF000000),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 15.0, top: 4.0),
                child:
                CircularPercentIndicator (
                  startAngle: 0,
                  circularStrokeCap: CircularStrokeCap.round,
                  radius: 25.0,
                  lineWidth: 4.0,
                  percent: percentage,
                  backgroundColor: backgroundColor,
                  center: Text("${(percentage * 100).toInt()}%"),
                  progressColor: progressColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}