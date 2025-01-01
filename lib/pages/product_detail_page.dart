import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.productId});

  final String productId;

  Product _getProduct() {
    // 実際のアプリではAPIやデータベースから取得します
    final products = [
      Product(
        id: '1',
        name: 'Modern Couch',
        price: 599.99,
        imageUrl: 'assets/images/couch.jpg',
        description: 'A comfortable modern couch perfect for your living room.',
      ),
      Product(
        id: '2',
        name: 'Designer Armchair',
        price: 299.99,
        imageUrl: 'assets/images/da.jpg',
        description: 'Stylish designer armchair with premium comfort.',
      ),
      Product(
        id: '3',
        name: 'Living Room Set',
        price: 1299.99,
        imageUrl: 'assets/images/living.jpg',
        description: 'Complete living room set with modern aesthetics.',
      ),
    ];
    return products.firstWhere((p) => p.id == productId);
  }

  @override
  Widget build(BuildContext context) {
    final product = _getProduct();

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              product.imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              // カートに追加する処理
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Added to cart'),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Add to Cart'),
            ),
          ),
        ),
      ),
    );
  }
}
