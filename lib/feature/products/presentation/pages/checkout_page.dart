// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lrl_shopping/core/services/storage_service.dart';
import 'package:lrl_shopping/feature/products/data/models/product_model.dart';

class CheckoutPage extends StatefulWidget {
  final Map<ProductModel, int> selectedProducts;
  final Function(ProductModel, int) updateQuantity;
  final Function(ProductModel) removeProduct;

  const CheckoutPage({
    super.key,
    required this.selectedProducts,
    required this.updateQuantity,
    required this.removeProduct,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String? _bearerToken;

  @override
  void initState() {
    super.initState();
    _fetchToken();
  }

  Future<void> _fetchToken() async {
    final storageService = StorageService();
    String? token = await storageService.getToken();
    setState(() {
      _bearerToken = token;
    });
  }

  double getTotalPrice() {
    return widget.selectedProducts.entries.fold(
      0.0,
      (sum, entry) => sum + (entry.key.price * entry.value),
    );
  }

  bool hasAvailableStock() {
    return widget.selectedProducts.entries
        .any((entry) => entry.value <= entry.key.stock);
  }

  void _placeOrder() async {
    if (_bearerToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Authentication Error: Token missing!")),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            "Order placed successfully! Total: \$${getTotalPrice().toStringAsFixed(2)}"),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("review_order".tr())),
      body: widget.selectedProducts.isEmpty
          ? const Center(child: Text("No products selected."))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.selectedProducts.length,
                    itemBuilder: (context, index) {
                      var entry =
                          widget.selectedProducts.entries.toList()[index];
                      ProductModel product = entry.key;
                      int quantity = entry.value;
                      bool isOutOfStock = quantity > product.stock;

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.pink.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    limitToThreeWords(product.name),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Available: ${product.stock}",
                                    style: TextStyle(
                                        color: isOutOfStock
                                            ? Colors.red
                                            : Colors.black),
                                  ),
                                  Text("Requested: $quantity"),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      if (quantity > 1) {
                                        widget.updateQuantity(
                                            product, quantity - 1);
                                        setState(() {});
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    width: 40,
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      controller: TextEditingController(
                                          text: quantity.toString()),
                                      onChanged: (value) {
                                        int newQty = int.tryParse(value) ?? 1;
                                        widget.updateQuantity(product, newQty);
                                        setState(() {});
                                      },
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 8),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      widget.updateQuantity(
                                          product, quantity + 1);
                                      setState(() {});
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      widget.removeProduct(product);
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "total_price: \$${getTotalPrice().toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: hasAvailableStock() ? _placeOrder : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            hasAvailableStock() ? Colors.blue : Colors.grey,
                      ),
                      child: Text("confirm_order".tr()),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  String limitToThreeWords(String text) {
    List<String> words = text.split(' ');
    return words.length > 3 ? '${words.take(3).join(' ')}...' : text;
  }
}
