// ignore_for_file: unused_element

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lrl_shopping/feature/products/presentation/cubit/product_cubit.dart';
import 'package:lrl_shopping/feature/products/data/models/product_model.dart';
import 'package:lrl_shopping/feature/products/presentation/pages/checkout_page.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  final Map<ProductModel, int> _selectedProducts = {};

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchProducts();
  }

  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = query.isEmpty
          ? _allProducts
          : _allProducts
              .where((product) =>
                  product.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  void _updateQuantity(ProductModel product, int quantity) {
    setState(() {
      if (quantity <= 0) {
        _selectedProducts.remove(product);
      } else {
        _selectedProducts[product] = quantity;
      }
    });
  }

  void _removeProduct(ProductModel product) {
    setState(() {
      _selectedProducts.remove(product);
    });
  }

  void _onCheckout() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Order placed successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("products_list".tr())),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterProducts,
              decoration: InputDecoration(
                hintText: "search".tr(),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<ProductCubit, List<ProductModel>>(
              builder: (context, products) {
                if (products.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (_allProducts.isEmpty) {
                  _allProducts = products;
                  _filteredProducts = products;
                }

                return ListView.builder(
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = _filteredProducts[index];

                    return ListTile(
                      // Demo image for practise perpose
                      leading: Image.network(
                        "https://storage.googleapis.com/gen-atmedia/3/2018/01/2d4ea32ed14a1f75cf1b454748dfa99cd4a1fa62.jpeg",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(product.name),
                      subtitle: Text(
                          "${"price".tr()}: \$${product.price} | ${"stock".tr()}: ${product.stock}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              _updateQuantity(product,
                                  (_selectedProducts[product] ?? 0) - 1);
                            },
                          ),
                          Text("${_selectedProducts[product] ?? 0}"),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              _updateQuantity(product,
                                  (_selectedProducts[product] ?? 0) + 1);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _selectedProducts.isNotEmpty
          ? ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => CheckoutPage(
                    selectedProducts: _selectedProducts,
                    updateQuantity: _updateQuantity,
                    removeProduct: _removeProduct,
                  ),
                );
              },
              child: Text("view_busket".tr()),
            )
          : const SizedBox.shrink(),
    );
  }
}
