import 'package:flutter/material.dart';
import 'package:shop_app_flutter/global_variables.dart';
import 'package:shop_app_flutter/product_card.dart';
import 'package:shop_app_flutter/product_details_page.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
   final List<String> filters = const [
    'All',
    'Adidas',
    'Nike',
    'Jordan'
  ];

  final _searchController = TextEditingController();

  var _filteredShoes = products;
  
  

  void _searchShoes() {
  final query = _searchController.text.toString().toLowerCase();
  _filteredShoes = [];

  if (query.isNotEmpty) {
    for (var product in products) {
      if (product['title'].toString().toLowerCase().contains(query)) {
        _filteredShoes.add(product);
      }
    }
  } else {
    _filteredShoes = products;
  }

  setState(() {});
}
  

  late String selectedFilter;
  
  @override
  void initState() {
    super.initState();
    selectedFilter = filters[0];

    _searchController.addListener(_searchShoes);

  }


  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(225, 225, 225, 1),
      ),
      borderRadius: BorderRadius.horizontal(
        left: Radius.circular(50),
      ),
    );
    return SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Shoes\nCollection',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                 Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: border,
                      enabledBorder: border, 
                      focusedBorder: border,
                    ),
                  ),
                ),
                
              ],
            ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: filters.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (contex, index) {
                  final filter = filters[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        _filteredShoes = [];
                        if (filter == 'All') {
                          _filteredShoes = products;
                        } else {
                          for (var product in products) {
                            if (product['company'] == filter) {
                              _filteredShoes.add(product);
                            }
                          }
                        }
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      child: Chip(
                        backgroundColor:selectedFilter == filter
                          ? Theme.of(context).colorScheme.primary
                          : const  Color.fromRGBO(245, 247, 249, 1),
                        side: const BorderSide(
                          color: Color.fromRGBO(245, 247, 249, 1),
                        ),
                        label: Text(filter),
                        labelStyle: const TextStyle(
                          fontSize: 16,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ); 
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredShoes.length,
                itemBuilder: (context, index) {
                  final product = _filteredShoes[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return ProductDetailPage(
                              product: product,

                            );
                          },
                        ),
                      );
                    },
                    child: ProductCard(
                      title: product['title'] as String,
                      price: product['price'] as String,
                      image: product['imageUrl'] as String,
                      backgroundColor: index.isEven 
                        ? const Color.fromRGBO(216, 240, 253, 1) 
                        : const Color.fromRGBO(245, 247, 249, 1),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
  }
}