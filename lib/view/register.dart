import 'dart:convert';
import 'dart:developer';
import 'package:ecommerce_app/view/login.dart';
import 'package:ecommerce_app/webservice/webservice.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool _obscureText = true;
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  register(String name, phone, address, username, password) async {
    log("name = $name");
    log("phone= $phone");
    log("address = $address");
    log("username = $username");
    log("password = $password");

    try {
      var result;
      final Map<String, dynamic> userData = {
        'name': name,
        'phone': phone,
        'address': address,
        'username': username,
        'password': password,
      };
      final response = await http.post(
          Uri.parse(Webservice.mainurl + 'registration.php'),
          body: userData);

      print(response.statusCode);

      if (response.statusCode == 200) {
        if (response.body.contains("success")) {
          log('Registration Completed');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              content: Text(
                'REGISTRATION SUCCESSFULL',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return LoginPage();
              },
            ),
          );
        } else {
          log('Registration Failed');
          print(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              content: Text(
                'REGISTRATION FAILED!!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }
      } else {
        print(response.body);
        result = json.decode(response.body)['error'].toString();
        print(result);
      }
    } catch (e) {
      print('Error: $e');
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Center(
                  child: Text(
                    'Register Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Center(
                child: Text(
                  'Enter your details',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              //Name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: name,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "Name",
                    hintText: 'Enter your Name',
                    prefixIcon: const Icon(Icons.person_pin_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  validator: (name) => name!.length < 3
                      ? 'Name should be atleast 3 characters'
                      : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              //phone
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Phone",
                    hintText: 'Enter your number',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  validator: (value) =>
                      value!.length < 10 ? 'Number should be 10 digits' : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              //address
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: address,
                  minLines: 1,
                  maxLines: 2,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Address",
                    hintText: 'Enter your Address',
                    prefixIcon: const Icon(Icons.place),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  validator: (name) => name!.length < 10
                      ? 'Name should be atleast 10 characters'
                      : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              //username
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: username,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "Username",
                    hintText: 'Enter your Username',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your username';
                    } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                      return 'Username must contain both characters and numbers';
                    } else {
                      return null;
                    }
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              //password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: password,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: 'Enter your Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      icon: Icon(_obscureText
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your username';
                    } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                      return 'password must contain both characters and numbers';
                    } else {
                      return null;
                    }
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      register(
                        name.text,
                        phone.text,
                        address.text,
                        username.text,
                        password.text,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Register'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
