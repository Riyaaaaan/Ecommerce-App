import 'package:ecommerce_app/provider/provider.dart';
import 'package:ecommerce_app/view/checkout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  final List<CartProduct> cartlist = [];
  CartPage({Key? key}) : super(key: key);

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
        title: const Text(
          'Cart',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Provider.of<Cart>(context, listen: false).clearCart();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Flexible(
              child: Container(
                child: Consumer<Cart>(
                  builder: (context, cartProvider, child) {
                    // Check if the cart is empty
                    if (cartProvider.count == 0) {
                      return const Center(
                        child: Text('Your cart is Empty.'),
                      );
                    }

                    // Build the list of added products
                    return ListView.builder(
                      itemCount: cartProvider.count,
                      itemBuilder: (context, index) {
                        final cartProduct = cartProvider.getItems[index];
                        return Card(
                          color: const Color(0xFFD0E7D2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Image.network(
                              cartProvider.getItems[index].imagesUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(
                              cartProduct.name,
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              '₹${cartProvider.getItems[index].price}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            trailing: Container(
                              height: 35,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    iconSize: 18,
                                    onPressed: () {
                                      cartProvider.decrement(cartProduct);
                                    },
                                  ),
                                  Text('${cartProduct.qty}'),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                    ),
                                    iconSize: 18,
                                    onPressed: () {
                                      cartProvider.increment(cartProduct);
                                    },
                                  ),
                                  const VerticalDivider(),
                                  IconButton(
                                    onPressed: () {
                                      cartProvider.removeItem(cartProduct);
                                    },
                                    icon: const Icon(Icons.close),
                                    iconSize: 18,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            BottomSheet(
              backgroundColor: const Color(0xFFD0E7D2),
              onClosing: () {},
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total : ₹${Provider.of<Cart>(context).totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          var cart = context.read<Cart>();
                          if (cart.getItems.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 3),
                                behavior: SnackBarBehavior.floating,
                                padding: EdgeInsets.all(15.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                content: Text(
                                  "Cart is empty !!!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutPage(
                                  cart: cart.getItems,
                                  totalAmount: cart.totalPrice,
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text('Order Now'),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
