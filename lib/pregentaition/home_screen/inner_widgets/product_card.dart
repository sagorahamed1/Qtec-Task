
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final cardHeight = mq.size.height * 0.3;
    final padding = mq.size.width * 0.03;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: CachedNetworkImage(
              imageUrl: product.image.toString(),
              height: cardHeight * 0.6,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title.toString(),
                  style: TextStyle(
                    fontSize: mq.size.width * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: mq.size.height * 0.01),

                Row(
                  children: [


                    Text(
                      '\$ ${ (product.price! * 0.8).toStringAsFixed(1) }',
                      style: TextStyle(fontSize: mq.size.width * 0.028),
                    ),


                    Text(
                      " ${product.price}",
                      style: TextStyle(
                        fontSize: mq.size.width * 0.028,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: mq.size.width * 0.02),
                    Text(
                      '20% OFF',
                      style: TextStyle(
                        fontSize: mq.size.width * 0.028,
                        color: Colors.red[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: mq.size.height * 0.01),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    Text(
                      ' ${product.rating?.rate?.toStringAsFixed(1)} (${product.rating?.count})',
                      style: TextStyle(fontSize: mq.size.width * 0.03),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}