class ProductModel {
  final String name;
  final double price;
  final int stock;
  final int masterPack;

  ProductModel({
    required this.name,
    required this.price,
    required this.stock,
    required this.masterPack,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0, 
      stock: int.tryParse(json['stock'].toString()) ?? 0, 
      masterPack: int.tryParse(json['pack_size'].toString()) ?? 0,
    );
  }
}
