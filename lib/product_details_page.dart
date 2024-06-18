import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app_flutter/cart_provider.dart';
import 'package:shop_app_flutter/shoes_data.dart';

class ProductDetailPage extends StatefulWidget {
  final  Map<String, Object> product;
  const ProductDetailPage({
    super.key, 
    required this.product,
    });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPagState();
}

class _ProductDetailPagState extends State<ProductDetailPage> {
  int selectedSize = 0;

  /*void onTap() {
    if (selectedSize != 0) {
      Provider.of<CartProvider>(context, listen: false).addProduct(
        {
          'id': widget.product['id'],
          'title': widget.product['title'],
          'price': widget.product['price'],
          'company': widget.product['company'],
          'size': selectedSize,
          'imageUrl': widget.product['imageUrl'],
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added successfully!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a size!'),
        ),
      );
    }
  }*/
  Future<void> _setCartData() async {
  if (selectedSize!= 0) {
    var prefs = await SharedPreferences.getInstance();
    final cartDataList = ShoesData(
      id: widget.product['id'] as String,
      imageUrl: widget.product['imageUrl'] as String,
      price: widget.product['price'] as String,
      size: selectedSize,
      title: widget.product['title'] as String,
    );
    final encodedDataList = prefs.getStringList('shoesData');
    if (encodedDataList == null) {
      prefs.setStringList('shoesData', [json.encode(cartDataList.toJson())]);
      setState(() {
        
      });
    } else {
      encodedDataList.add(json.encode(cartDataList.toJson()));
      prefs.setStringList('shoesData', encodedDataList);

      setState(() {});
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product added successfully!'),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select a size!'),
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Details'),
    ),
    body: Column(
      children: [
        Text(
          widget.product['title'] as String,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.asset(widget.product['imageUrl'] as String),
        ),
        const Spacer(flex: 2),
        Container(
          height: 250,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(245, 247, 249, 1),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '\$${widget.product['price']}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: (widget.product['sizes'] as List<int>?)?.length?? 0,
                  itemBuilder: (context, index) {
                    final size = (widget.product['sizes'] as List<int>?)?[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedSize = size?? 0;
                          });
                        },
                        child: Chip(
                          label: Text(
                            size?.toString()?? '',
                          ),
                          backgroundColor: selectedSize == size
                             ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: _setCartData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Add To Cart',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}