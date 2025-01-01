import 'package:ec_mock_app/pages/cart_page.dart';
import 'package:ec_mock_app/pages/favorites_page.dart';
import 'package:ec_mock_app/pages/home_page.dart';
import 'package:ec_mock_app/pages/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'router.g.dart';

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    TypedGoRoute<ProductDetailRoute>(
      path: 'product/:productId',
    ),
    TypedGoRoute<CartRoute>(
      path: 'cart',
    ),
    TypedGoRoute<FavoritesRoute>(
      path: 'favorites',
    ),
  ],
)
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();
}

class ProductDetailRoute extends GoRouteData {
  const ProductDetailRoute({required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ProductDetailPage(productId: productId);
}

class CartRoute extends GoRouteData {
  const CartRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const CartPage();
}

class FavoritesRoute extends GoRouteData {
  const FavoritesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const FavoritesPage();
}
