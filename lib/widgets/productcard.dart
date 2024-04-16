import 'package:ecommerce_app/models/product_model.dart';
import 'package:ecommerce_app/view/productpage.dart';

import 'package:ecommerce_app/webservice/webservice.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, required this.product}) : super(key: key);

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductPage(product: product),
            ));
      },
      child: Card(
        color: const Color(0xFFD0E7D2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                Webservice().imageurl + product.image!,
                fit: BoxFit.cover,
              ),
            ),
            ListTile(
              title: Text(product.productname!),
              subtitle: Text(
                '₹ ${product.price.toString()}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
