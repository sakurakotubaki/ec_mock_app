import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class CartItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productId => text()();
  TextColumn get name => text()();
  RealColumn get price => real()();
  TextColumn get imageUrl => text()();
  IntColumn get quantity => integer()();
  DateTimeColumn get addedAt => dateTime()();
}

class FavoriteItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productId => text().unique()();
  TextColumn get name => text()();
  RealColumn get price => real()();
  TextColumn get imageUrl => text()();
  TextColumn get description => text()();
  DateTimeColumn get addedAt => dateTime()();
}

@DriftDatabase(tables: [CartItems, FavoriteItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(favoriteItems);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  // Cart operations
  Future<List<CartItem>> getAllCartItems() => select(cartItems).get();

  Future<int> addToCart(CartItemsCompanion item) => into(cartItems).insert(item);

  Future<int> removeFromCart(int id) => 
      (delete(cartItems)..where((t) => t.id.equals(id))).go();

  Future<int> updateQuantity(int id, int quantity) =>
      (update(cartItems)..where((t) => t.id.equals(id)))
      .write(CartItemsCompanion(quantity: Value(quantity)));

  Stream<List<CartItem>> watchCartItems() => select(cartItems).watch();

  // Favorite operations
  Future<List<FavoriteItem>> getAllFavorites() => select(favoriteItems).get();

  Future<bool> isFavorite(String productId) async {
    final count = await (select(favoriteItems)
          ..where((t) => t.productId.equals(productId)))
        .get();
    return count.isNotEmpty;
  }

  Future<int> addToFavorites(FavoriteItemsCompanion item) => 
      into(favoriteItems).insert(item);

  Future<int> removeFromFavorites(String productId) =>
      (delete(favoriteItems)..where((t) => t.productId.equals(productId))).go();

  Stream<List<FavoriteItem>> watchFavorites() => select(favoriteItems).watch();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'cart.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
