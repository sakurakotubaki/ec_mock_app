import 'package:flutter/material.dart';
import '../models/product.dart';
import '../router/router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('EC Mock App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => FavoritesRoute().go(context),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => CartRoute().go(context),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () => ProductDetailRoute(productId: product.id).go(context),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.asset(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
