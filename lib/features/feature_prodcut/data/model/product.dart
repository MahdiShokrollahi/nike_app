import 'package:hive/hive.dart';
part 'product.g.dart';

class ProductSort {
  static const int latest = 0;
  static const int popular = 1;
  static const int priceHighToLow = 2;
  static const int priceLowTOHigh = 3;

  static const List<String> sortNameList = [
    'جدیدترین',
    'پربازدید ترین',
    'قیمت نزولی',
    'قیمت صعودی'
  ];
}

@HiveType(typeId: 0)
class ProductModel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String imageUrl;
  @HiveField(3)
  final int price;
  @HiveField(4)
  final int discount;
  @HiveField(5)
  final int previousPrice;
  ProductModel(this.id, this.title, this.imageUrl, this.price, this.discount,
      this.previousPrice);
  ProductModel.fromJson(Map<String, dynamic> jsonObject)
      : id = jsonObject['id'],
        title = jsonObject['title'],
        imageUrl = jsonObject['image'],
        price = jsonObject['price'],
        previousPrice = jsonObject['previous_price'] ?? jsonObject['price'],
        discount = jsonObject['discount'];
}
