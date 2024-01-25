class OrderModel {
  int id;
  String username;
  double totalamount;
  String paymentmethod;
  DateTime date;
  List<Product> products;

  OrderModel({
    required this.id,
    required this.username,
    required this.totalamount,
    required this.paymentmethod,
    required this.date,
    required this.products,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json["id"],
      username:
          json["username"] ?? "", // Provide a default value if username is null
      totalamount: json["totalamount"]?.toDouble() ??
          0.0, // Provide a default value if totalamount is null
      paymentmethod: json["paymentmethod"] ??
          "", // Provide a default value if paymentmethod is null
      date: json["date"] != null
          ? DateTime.tryParse(json["date"]) ?? DateTime.now()
          : DateTime.now(), // Use DateTime.tryParse to handle invalid formats
      products: (json["products"] as List<dynamic>?)
              ?.map((x) => Product.fromJson(x))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "totalamount": totalamount,
        "paymentmethod": paymentmethod,
        "date": date.toIso8601String(),
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Product {
  String productname;
  double? price;
  String image;
  int quantity;

  Product({
    required this.productname,
    required this.price,
    required this.image,
    required this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productname: json["productname"],
        price: json["price"]?.toDouble() ??
            0.0, // Provide a default value if price is null
        image: json["image"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "productname": productname,
        "price": price,
        "image": image,
        "quantity": quantity,
      };
}
