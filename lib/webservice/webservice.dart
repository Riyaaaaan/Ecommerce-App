import 'dart:convert';
import 'dart:developer';
import 'package:ecommerce_app/models/category_model.dart';
import 'package:ecommerce_app/models/order_model.dart';
import 'package:ecommerce_app/models/product_model.dart';
import 'package:ecommerce_app/models/user_model.dart';
import 'package:http/http.dart' as http;

class Webservice {
  final imageurl = 'http://bootcamp.cyralearnings.com/products/';

  static const mainurl = 'http://bootcamp.cyralearnings.com/';

//**-------------------------fetch Category ----------------------->

  Future<List<CategoryModel>?> fetchCategory() async {
    try {
      final response = await http.get(Uri.parse('${mainurl}getcategories.php'));

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

        return parsed
            .map<CategoryModel>((json) => CategoryModel.fromjson(json))
            .toList();
      } else {
        throw Exception(' Failed to load category');
      }
    } catch (e) {
      log('Fetch Error : ${e.toString()}');
    }
    return null;
  }

  //**-------------------------fetch Products ------------------>

  Future<List<ProductModel>> fetchCatProducts() async {
    final response =
        await http.get(Uri.parse('${mainurl}view_offerproducts.php'));

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<ProductModel>((json) => ProductModel.fromjson(json))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  //*----------------------Fetch product by category id-------->

  Future<List<ProductModel>> fetchProductsByCategory(int catid) async {
    try {
      final response = await http.post(
        Uri.parse('${mainurl}get_category_products.php?catid=$catid'),
        body: {'catid': '$catid'},
      );

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

        if (parsed == null) {
          log('Error: Null response from API');
          throw Exception('Null response from API');
        }

        return parsed
            .map<ProductModel>((json) => ProductModel.fromjson(json))
            .toList();
      } else {
        log('Error in fetchProductsByCategory: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load products by category');
      }
    } catch (e) {
      log('Error in fetchProductsByCategory: $e');
      throw Exception('Failed to load products by category');
    }
  }

  //*---------------------fetch OrderDetails-------------->
  Future<List<OrderModel>?> fetchOrderDetails(String username) async {
    try {
      log("username == $username");
      final response = await http.post(
        Uri.parse('${mainurl}get_orderdetails.php'),
        body: {'username': username.toString()},
      );

      log("Order details API response: ${response.body}");

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

        return parsed
            .map<OrderModel>((json) => OrderModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
            'Failed to load order details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      log("order details == $e");
      return null;
    }
  }

  //*----------------------Fetch User---------------------->
  Future<UserModel?> fetchUser(String username) async {
    try {
      final response = await http.post(
        Uri.parse('${mainurl}get_user.php'),
        body: {'username': username},
      );
      log('username : $username');

      if (response.statusCode == 200) {
        log(' ressponse : ${response.body}');

        final parsed = jsonDecode(response.body);
        return parsed != null ? UserModel.fromJson(parsed) : null;
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      log('catch : ${e.toString()}');
      return null;
    }
  }
}
