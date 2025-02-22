// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';

class ProductTile extends StatefulWidget {
  final ProductModel product;

  const ProductTile({super.key, required this.product});

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  int quantity = 1;

  void increment() => setState(() => quantity++);
  void decrement() => setState(() => quantity = (quantity > 1) ? quantity - 1 : 1);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.product.name),
      subtitle: Text("Price: \$${widget.product.price} | Stock: ${widget.product.stock} | Master Pack: ${widget.product.masterPack}"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: const Icon(Icons.remove), onPressed: decrement),
          Text("$quantity"),
          IconButton(icon: const Icon(Icons.add), onPressed: increment),
        ],
      ),
    );
  }
}
