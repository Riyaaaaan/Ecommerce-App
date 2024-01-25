import 'dart:developer';
import 'package:ecommerce_app/models/product_model.dart';
import 'package:ecommerce_app/widgets/productcard.dart';
import 'package:ecommerce_app/webservice/webservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProductByCat extends StatelessWidget {
  final int catid;
  final String catname;

  const ProductByCat({Key? key, required this.catid, required this.catname})
      : super(key: key);

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
        title: Text(catname),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: Webservice().fetchProductsByCategory(catid),
        builder: (context, snapshot) {
          log('Received Catid: $catid');

          if (snapshot.hasData) {
            final products = snapshot.data!;
            log('Product By Category: $products');
            return Container(
              child: MasonryGridView.builder(
                mainAxisSpacing: 10,
                crossAxisSpacing: 2,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                gridDelegate:
                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  print('item count: ${products.length}');
                  print('index: ${products[index]}');
                  return ProductCard(
                    product: products[index],
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            log('Error: ${snapshot.error}');
            return const Center(
              child: Text('Error loading products'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
