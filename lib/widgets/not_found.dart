import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
/*
 * Template for use across app
 */

Widget notFound({context, required String assetImg, required String text}) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 3,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          SizedBox(width: 200, height: 225, child: Lottie.asset(assetImg)),

          Text(
            textAlign: TextAlign.center,
            // "No Groups found",
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 18,
            ),
          ),
        ],
      ),
    ),
  );
}
