import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import '../data/database.dart';
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

  Future<void> _addToCart(BuildContext context, Product product) async {
    final database = AppDatabase();
    
    await database.addToCart(
      CartItemsCompanion(
        productId: drift.Value(product.id),
        name: drift.Value(product.name),
        price: drift.Value(product.price),
        imageUrl: drift.Value(product.imageUrl),
        quantity: const drift.Value(1),
        addedAt: drift.Value(DateTime.now()),
      ),
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to cart'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _toggleFavorite(BuildContext context, Product product) async {
    final database = AppDatabase();
    final isFavorite = await database.isFavorite(product.id);

    if (isFavorite) {
      await database.removeFromFavorites(product.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removed from favorites'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      await database.addToFavorites(
        FavoriteItemsCompanion(
          productId: drift.Value(product.id),
          name: drift.Value(product.name),
          price: drift.Value(product.price),
          imageUrl: drift.Value(product.imageUrl),
          description: drift.Value(product.description),
          addedAt: drift.Value(DateTime.now()),
        ),
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added to favorites'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = _getProduct();

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          StreamBuilder<List<FavoriteItem>>(
            stream: AppDatabase().watchFavorites(),
            builder: (context, snapshot) {
              final isFavorite = snapshot.hasData &&
                  snapshot.data!.any((item) => item.productId == product.id);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () => _toggleFavorite(context, product),
              );
            },
          ),
        ],
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
            onPressed: () => _addToCart(context, product),
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
