import 'dart:convert';
import 'dart:developer';
import 'package:ecommerce_app/payments/upi_payment.dart';
import 'package:ecommerce_app/widgets/animation.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerce_app/models/user_model.dart';
import 'package:ecommerce_app/provider/provider.dart';
import 'package:ecommerce_app/webservice/webservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CheckoutPage extends StatefulWidget {
  final List<CartProduct> cart;
  final double totalAmount;

  const CheckoutPage({Key? key, required this.cart, required this.totalAmount})
      : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckoutPage> {
  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  String? username;

  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString('username');
    });
    log("checkout isloggedin = $username");
  }

  int selectedValue = 1;

  void orderPlace(
    List<CartProduct> cart,
    String amount,
    String paymentmethod,
    String date,
    String name,
    String address,
    String phone,
  ) async {
    try {
      String jsondata =
          jsonEncode(cart.map((product) => product.toJson()).toList());

      log('jsondata = $jsondata');

      final vm = Provider.of<Cart>(context, listen: false);

      final response = await http.post(
        Uri.parse("${Webservice.mainurl}order.php"),
        body: {
          "username": username,
          "amount": amount,
          "paymentmethod": paymentmethod,
          "date": date,
          "quantity": vm.count.toString(),
          "cart": jsondata,
          'name': name,
          "address": address,
          "phone": phone,
        },
      );

      if (response.statusCode == 200) {
        log('checkout : ${response.body}');
        log('Ordered Items: $jsondata');
        if (response.body.contains("Success")) {
          vm.clearCart();
          // animation

          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return LottieAnime();
            },
          ));
        }
      }
    } catch (e) {
      log('checkout error catch :${e.toString()}');
    }
  }

  String? name, address, phone;
  String? paymentmethod = "Cash on delivery";

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CheckOut',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: const Color(0xFF79AC78),
        foregroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<UserModel?>(
                  future: Webservice().fetchUser(username.toString()),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      name = snapshot.data!.name;
                      phone = snapshot.data!.phone;
                      address = snapshot.data!.address;
                      return Card(
                          color: const Color(0xFFD0E7D2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "Name : ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(name.toString())
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Text("Phone : ",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    Text(phone.toString())
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Text("Address : ",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    Container(
                                      // color: Colors.amber,
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                      child: Text(
                                        address.toString(),
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ));
                    }
                    return const CircularProgressIndicator();
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
            RadioListTile(
              activeColor: Colors.blue.shade900,
              value: 1,
              groupValue: selectedValue,
              onChanged: (int? value) {
                setState(() {
                  selectedValue = value ?? 1;
                  paymentmethod = 'Cash on delivery';
                });
              },
              title: const Text(
                'Cash On Delivery',
              ),
              subtitle: const Text(
                'Pay Cash At Home',
              ),
            ),
            RadioListTile(
              activeColor: Colors.blue.shade900,
              value: 2,
              groupValue: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value ?? 1;
                  paymentmethod = 'Online';
                });
              },
              title: const Text(
                'Pay Now',
              ),
              subtitle: const Text(
                'Online Payment',
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            if (selectedValue == 2) // Only show if 'Pay Now' is selected
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Payment Method',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(),
                      ListTile(
                        splashColor: Colors.white,
                        title: Text(
                          'UPI Apps',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UpiPaymentsPage(
                              totalAmount: widget.totalAmount,
                            ),
                          ));
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Credit/Debit Cards',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          // Handle selection
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            String datetime = DateTime.now().toString();
            log('Cart Contents: ${widget.cart}');

            orderPlace(
              widget.cart,
              vm.totalPrice.toString(),
              paymentmethod!,
              datetime,
              name!,
              address!,
              phone!,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            "Checkout",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
