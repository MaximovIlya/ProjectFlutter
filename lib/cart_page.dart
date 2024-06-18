import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app_flutter/cart_provider.dart';
import 'package:shop_app_flutter/global_variables.dart';
import 'package:shop_app_flutter/shoes_data.dart';


class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPage createState() => _CartPage();
}

class _CartPage extends State<CartPage> {
  late Future<List<ShoesData>> futureShoesData;

  @override
  void initState() {
    super.initState();
    futureShoesData = getShoesData();
  }

  Future<List<ShoesData>> getShoesData() async {
  var prefs = await SharedPreferences.getInstance();
  final encodeShoesList = prefs.getStringList('shoesData');
  setState(() {
    
  });
  if (encodeShoesList == null) return [];

  final shoesList = encodeShoesList.map((encodeShoes){
    final decodeShoes = json.decode(encodeShoes);
    return ShoesData.fromJson(decodeShoes);
  }).toList();

  return shoesList;
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Cart'),
    ),
    body: FutureBuilder(
      future: getShoesData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final cart = snapshot.data!;
          if (cart.isEmpty) {
            return const Center(
              child: Text('Cart is empty'),
            );
          }

          return ListView.builder(
            itemCount: cart.length,
            itemBuilder: (context, index) {
              final cartItem = cart[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: cartItem.imageUrl!= null && cartItem.imageUrl.isNotEmpty
                   ? AssetImage(cartItem.imageUrl)
                    : null,
                  radius: 30,
                ),
                trailing: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context, 
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'Delete Product',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          content: const Text('Are you sure you want to remove the product from your cart?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              }, 
                              child: const Text('No', style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                if (cart.any((element) => element.id == cartItem.id)) {
                                  final prefs = await SharedPreferences.getInstance();
                                  final encodeShoesList = prefs.getStringList('shoesData')?? [];

                                  final encodeCartItem = json.encode(cartItem.toJson());
                                  if (encodeShoesList.contains(encodeCartItem)) {
                                    encodeShoesList.remove(encodeCartItem);
                                    await prefs.setStringList('shoesData', encodeShoesList);
                                    setState(() {
                                      
                                    });
                                  }
                                }
                                Navigator.of(context).pop();
                              },
                              child: const Text('Yes', style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }, 
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
                title: Text(
                  cartItem.title.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                subtitle: Text('Size: ${cartItem.size}'),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
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