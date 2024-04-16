import 'dart:developer';
import 'package:ecommerce_app/models/product_model.dart';
import 'package:ecommerce_app/view/cart.dart';
import 'package:ecommerce_app/widgets/productcard.dart';
import 'package:ecommerce_app/view/category_product.dart';
import 'package:ecommerce_app/webservice/webservice.dart';
import 'package:ecommerce_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatelessWidget {
  final String username;
  final String password;
  const HomePage({Key? key, required this.username, required this.password})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productfuture = Webservice().fetchCatProducts();

    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber.shade900),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF79AC78),
          toolbarHeight: 60,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'E  STORE',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CartPage(),
                ));
              },
              icon: const Icon(Icons.shopping_cart),
            )
          ],
        ),
        drawer: DrawerWidget(
          username: username,
          password: password,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                  future: Webservice().fetchCategory(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      log("length == ${snapshot.data!.length}");
                      return Container(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: InkWell(
                                onTap: () {
                                  log('Clicked');
                                  log('Cat : ${snapshot.data![index].category!}');
                                  print('ID : ${snapshot.data![index].id!}');

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductByCat(
                                        catid: snapshot.data![index].id!,
                                        catname:
                                            snapshot.data![index].category!,
                                      ),
                                    ),
                                  );
                                  print(
                                    snapshot.data![index].category,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color.fromARGB(37, 5, 2, 39),
                                  ),
                                  child: Center(
                                    child: Text(
                                      snapshot.data![index].category!,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Offer Products',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //*-------------Product list------------->

                FutureBuilder<List<ProductModel>>(
                  future: productfuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final products = snapshot.data!;
                      log("No.of Products ==${snapshot.data!.length}");

                      return Container(
                        child: MasonryGridView.builder(
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 2,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          gridDelegate:
                              const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return ProductCard(
                              product: products[index],
                            );
                          },
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
