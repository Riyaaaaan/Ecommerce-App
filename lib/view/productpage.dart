import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:ecommerce_app/models/product_model.dart';
import 'package:ecommerce_app/provider/provider.dart';
import 'package:ecommerce_app/webservice/webservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//*----------------------Product Details--------------------------->
class ProductPage extends StatelessWidget {
  const ProductPage({Key? key, required this.product}) : super(key: key);

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: const Color(0xFF79AC78),
        foregroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(
          product.productname!,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Image.network(
                    Webservice().imageurl + product.image!,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.productname!,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            ' ₹ ${product.price}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: Text(
                              product.description!,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<Cart>(
                builder: (context, cartProvider, child) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      elevation: 5,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Add to Cart'),
                    onPressed: () {
                      if (cartProvider.getItems.isNotEmpty) {
                        final existingProduct =
                            cartProvider.getItems.firstWhereOrNull(
                          (element) => element.id == product.id,
                        );
                        if (existingProduct != null) {
                          cartProvider.increment(existingProduct);
                        } else {
                          cartProvider.addItem(
                            product.id!,
                            product.productname!,
                            product.price!,
                            1,
                            Webservice().imageurl + product.image!,
                          );
                        }
                      } else {
                        cartProvider.addItem(
                          product.id!,
                          product.productname!,
                          product.price!,
                          1,
                          Webservice().imageurl + product.image!,
                        );
                      }
                      log('Added to Cart');
                    },
                  );
                },
              )),
        ],
      ),
    );
  }
}
