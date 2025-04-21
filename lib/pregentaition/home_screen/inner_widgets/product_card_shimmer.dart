import 'package:flutter/material.dart';

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final cardHeight = mq.size.height * 0.3;
    final lineHeight = mq.size.height * 0.015;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: cardHeight * 0.6,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(mq.size.width * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: lineHeight,
                  color: Colors.grey[200],
                ),
                SizedBox(height: lineHeight / 2),
                Container(
                  width: mq.size.width * 0.2,
                  height: lineHeight * 0.9,
                  color: Colors.grey[200],
                ),
                SizedBox(height: lineHeight / 2),
                Container(
                  width: mq.size.width * 0.15,
                  height: lineHeight * 0.9,
                  color: Colors.grey[200],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}