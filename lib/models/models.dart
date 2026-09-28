class ProductItem {
  final String id;
  final String name;
  final String seller;
  final int price;
  final String formattedPrice;
  final String image;
  final String category;
  final double rating;
  final bool isOwned;
  final String? badgeLabel;
  final String? matchReason;
  final int? matchPercentage;
  final String description;
  final List<String> sizes;

  const ProductItem({
    required this.id,
    required this.name,
    required this.seller,
    required this.price,
    required this.formattedPrice,
    required this.image,
    required this.category,
    this.rating = 4.8,
    this.isOwned = false,
    this.badgeLabel,
    this.matchReason,
    this.matchPercentage,
    required this.description,
    this.sizes = const ['S', 'M', 'L', 'XL'],
  });
}

class CartItem {
  final ProductItem product;
  final String size;
  final String color;
  int quantity;

  CartItem({
    required this.product,
    required this.size,
    required this.color,
    this.quantity = 1,
  });
}

class WardrobePiece {
  final String id;
  final String name;
  final String category;
  final String image;
  final String dateAdded;
  final int usedInLooksCount;

  const WardrobePiece({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.dateAdded,
    this.usedInLooksCount = 0,
  });
}

class OutfitRecommendation {
  final String id;
  final String title;
  final int matchScore;
  final String image;
  final List<ProductItem> items;
  final int totalNewItemsPrice;
  final List<String> whyMatchReasons;

  const OutfitRecommendation({
    required this.id,
    required this.title,
    required this.matchScore,
    required this.image,
    required this.items,
    required this.totalNewItemsPrice,
    required this.whyMatchReasons,
  });
}

class OrderModel {
  final String id;
  final String seller;
  final String itemTitle;
  final String price;
  final String image;
  final String status; // 'Processing', 'Shipped', 'Delivered'
  final String date;

  const OrderModel({
    required this.id,
    required this.seller,
    required this.itemTitle,
    required this.price,
    required this.image,
    required this.status,
    required this.date,
  });
}
