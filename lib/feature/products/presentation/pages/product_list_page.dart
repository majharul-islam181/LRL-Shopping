import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lrl_shopping/feature/products/presentation/cubit/product_cubit.dart';
import 'package:lrl_shopping/feature/products/data/models/product_model.dart';
/*

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lrl_shopping/feature/products/presentation/cubit/product_cubit.dart';
import 'package:lrl_shopping/feature/products/data/models/product_model.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  final Map<int, int> _quantities = {}; // Stores product quantities

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

  void _incrementQuantity(int productId) {
    setState(() {
      _quantities[productId] = (_quantities[productId] ?? 0) + 1;
    });
  }

  void _decrementQuantity(int productId) {
    setState(() {
      if ((_quantities[productId] ?? 0) > 0) {
        _quantities[productId] = _quantities[productId]! - 1;
      }
    });
  }

  void _deleteProduct(int productId, Function setDialogState) {
    setState(() {
      _quantities.remove(productId); // Remove from UI
    });
    setDialogState(() {}); // Update the popup UI
  }

  // Get total ordered items count
  int get totalOrderedItems {
    return _quantities.values.fold(0, (sum, qty) => sum + qty);
  }

  // Get ordered products
  List<MapEntry<ProductModel, int>> get orderedProducts {
    return _allProducts
        .where((product) => (_quantities[product.hashCode] ?? 0) > 0)
        .map((product) => MapEntry(product, _quantities[product.hashCode] ?? 0))
        .toList();
  }

  // Show Order Summary with Scrollable ListView
  void _showOrderSummary() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            List<MapEntry<ProductModel, int>> ordered = orderedProducts;
            bool hasOutOfStock =
                ordered.any((entry) => entry.value > entry.key.stock);

            return AlertDialog(
              title: const Text("Order Summary"),
              content: SizedBox(
                width: double.maxFinite,
                height: 350, // Make popup scrollable
                child: ordered.isEmpty
                    ? const Center(child: Text("No products selected."))
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: ordered.length,
                        itemBuilder: (context, index) {
                          var entry = ordered[index];
                          bool isOutOfStock = entry.value > entry.key.stock;

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            // leading: Image.asset(
                            //   "assets/images/placeholder.png",
                            //   width: 40,
                            //   height: 40,
                            //   fit: BoxFit.cover,
                            // ),
                            title: Text(entry.key.name),
                            subtitle: Text(
                              "Requested: ${entry.value} | Available: ${entry.key.stock}",
                              style: TextStyle(
                                  color:
                                      isOutOfStock ? Colors.red : Colors.black),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    if (_quantities[entry.key.hashCode]! > 0) {
                                      setDialogState(() {
                                        _quantities[entry.key.hashCode] =
                                            _quantities[entry.key.hashCode]! -
                                                1;
                                      });
                                    }
                                  },
                                ),
                                SizedBox(
                                  width: 40,
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    controller: TextEditingController(
                                        text: _quantities[entry.key.hashCode]
                                            .toString()),
                                    onChanged: (value) {
                                      int qty = int.tryParse(value) ?? 0;
                                      setDialogState(() {
                                        _quantities[entry.key.hashCode] = qty;
                                      });
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
                                    setDialogState(() {
                                      _quantities[entry.key.hashCode] =
                                          _quantities[entry.key.hashCode]! + 1;
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    _deleteProduct(
                                        entry.key.hashCode, setDialogState);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"),
                ),
                ElevatedButton(
                  onPressed: hasOutOfStock || ordered.isEmpty
                      ? null
                      : () {
                          Navigator.pop(context);
                          _proceedToCheckout();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (hasOutOfStock || ordered.isEmpty)
                        ? Colors.grey
                        : Colors.blue,
                  ),
                  child: const Text("Checkout"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Proceed to checkout function
  void _proceedToCheckout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Proceeding to checkout...")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product List")),
      body: Column(
        children: [
          // Container(
          //   height: MediaQuery.sizeOf(context).height * .1,
          //   width: MediaQuery.sizeOf(context).width * .8,
          //   decoration: BoxDecoration(
          //     color: Colors.pink.withOpacity(0.2),
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: const Padding(
          //     padding: EdgeInsets.all(8.0),
          //     child: Row(
          //       children: [
          //         //titile
          //         Column(
          //           children: [
          //             Text('product title'),
          //             Text('Avalaible : 12'),
          //             Text('Requested: 90'),
          //           ],
          //         ),

          //         // plus button //reduct button

          //       ],
          //     ),
          //   ),
          // ),
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterProducts,
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // 🛍️ Product List
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
                    final productId = product.hashCode;
                    _quantities.putIfAbsent(productId, () => 0);

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        // leading: Image.asset(
                        //   "assets/images/placeholder.png",
                        //   width: 50,
                        //   height: 50,
                        //   fit: BoxFit.cover,
                        // ),
                        title: Text(product.name),
                        subtitle: Text(
                            "Price: \$${product.price} | Stock: ${product.stock} | Master Pack: ${product.masterPack}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => _decrementQuantity(productId),
                            ),
                            Text("${_quantities[productId]}"),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => _incrementQuantity(productId),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: totalOrderedItems > 0
          ? ElevatedButton(
              onPressed: _showOrderSummary,
              child: const Text("Review Order"),
            )
          : const SizedBox.shrink(),
    );
  }
}
*/

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  final Map<int, int> _quantities = {}; // Stores product quantities

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

  void _incrementQuantity(int productId) {
    setState(() {
      _quantities[productId] = (_quantities[productId] ?? 0) + 1;
    });
  }

  void _decrementQuantity(int productId) {
    setState(() {
      if ((_quantities[productId] ?? 0) > 0) {
        _quantities[productId] = _quantities[productId]! - 1;
      }
    });
  }

  void _deleteProduct(int productId, Function setDialogState) {
    setState(() {
      _quantities.remove(productId); // Remove from UI
    });
    setDialogState(() {}); // Update the popup UI
  }

  // Get ordered products
  List<MapEntry<ProductModel, int>> get orderedProducts {
    return _allProducts
        .where((product) => (_quantities[product.hashCode] ?? 0) > 0)
        .map((product) => MapEntry(product, _quantities[product.hashCode] ?? 0))
        .toList();
  }

  // Show Order Summary Popup with New UI
  void _showOrderSummary() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            List<MapEntry<ProductModel, int>> ordered = orderedProducts;
            bool hasOutOfStock =
                ordered.any((entry) => entry.value > entry.key.stock);

            return AlertDialog(
              title: const Text("Order Summary"),
              content: SizedBox(
                width: MediaQuery.sizeOf(context).width * .8,
                height: 350, // Make popup scrollable
                child: ordered.isEmpty
                    ? const Center(child: Text("No products selected."))
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: ordered.length,
                        itemBuilder: (context, index) {
                          var entry = ordered[index];
                          bool isOutOfStock = entry.value > entry.key.stock;

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.all(8.0),
                            height: MediaQuery.sizeOf(context).height * .1,
                            width: MediaQuery.sizeOf(context).width * .8,
                            decoration: BoxDecoration(
                              color: Colors.pink.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Product Info Section
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      entry.key.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Available: ${entry.key.stock}",
                                      style: TextStyle(
                                          color: isOutOfStock
                                              ? Colors.red
                                              : Colors.black),
                                    ),
                                    Text("Requested: ${entry.value}"),
                                  ],
                                ),

                                // Increment & Decrement Buttons
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        if (_quantities[entry.key.hashCode]! >
                                            0) {
                                          setDialogState(() {
                                            _quantities[entry.key.hashCode] =
                                                _quantities[
                                                        entry.key.hashCode]! -
                                                    1;
                                          });
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      width: 40,
                                      child: TextField(
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        controller: TextEditingController(
                                            text:
                                                _quantities[entry.key.hashCode]
                                                    .toString()),
                                        onChanged: (value) {
                                          int qty = int.tryParse(value) ?? 0;
                                          setDialogState(() {
                                            _quantities[entry.key.hashCode] =
                                                qty;
                                          });
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
                                        setDialogState(() {
                                          _quantities[entry.key.hashCode] =
                                              _quantities[entry.key.hashCode]! +
                                                  1;
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        _deleteProduct(
                                            entry.key.hashCode, setDialogState);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"),
                ),
                ElevatedButton(
                  onPressed: hasOutOfStock || ordered.isEmpty
                      ? null
                      : () {
                          Navigator.pop(context);
                          _proceedToCheckout();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (hasOutOfStock || ordered.isEmpty)
                        ? Colors.grey
                        : Colors.blue,
                  ),
                  child: const Text("Checkout"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Proceed to checkout function
  void _proceedToCheckout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Proceeding to checkout...")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product List")),
      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterProducts,
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // 🛍️ Product List
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
                    final productId = product.hashCode;
                    _quantities.putIfAbsent(productId, () => 0);

                    return ListTile(
                      // leading: Image.asset(
                      //   "assets/images/placeholder.png",
                      //   width: 50,
                      //   height: 50,
                      //   fit: BoxFit.cover,
                      // ),
                      title: Text(product.name),
                      subtitle: Text(
                          "Price: \$${product.price} | Stock: ${product.stock} | Master Pack: ${product.masterPack}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () => _incrementQuantity(productId),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: orderedProducts.isNotEmpty
          ? ElevatedButton(
              onPressed: _showOrderSummary,
              child: const Text(" View card"),
            )
          : const SizedBox.shrink(),
    );
  }
}
