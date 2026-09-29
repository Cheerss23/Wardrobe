import 'package:flutter/material.dart';

class ProductItem {
  final String id;
  final String name;
  final String seller;
  final String brand;
  final int price;
  final String formattedPrice;
  final int? originalPrice;
  final String? formattedOriginalPrice;
  final int? discountPercentage;
  final String image;
  final List<String> gallery;
  final String category; // 'Tops', 'Bottoms', 'Shoes', 'Outerwear', 'Accessories', 'Bags'
  final String styleCategory; // 'Casual', 'Streetwear', 'Minimal', 'Smart Casual', 'Korean', 'Old Money'
  final String gender; // 'Men', 'Women', 'Unisex'
  final double rating;
  final String soldCount;
  final bool isOwned;
  final String? badgeLabel;
  final String? matchReason;
  final int? matchPercentage;
  final String description;
  final String material;
  final List<String> sizes;
  final List<String> colors;
  final int reviewsCount;

  const ProductItem({
    required this.id,
    required this.name,
    required this.seller,
    this.brand = 'Fitly Label',
    required this.price,
    required this.formattedPrice,
    this.originalPrice,
    this.formattedOriginalPrice,
    this.discountPercentage,
    required this.image,
    this.gallery = const [],
    required this.category,
    this.styleCategory = 'Casual',
    this.gender = 'Unisex',
    this.rating = 4.8,
    this.soldCount = '1.2K sold',
    this.isOwned = false,
    this.badgeLabel,
    this.matchReason,
    this.matchPercentage,
    required this.description,
    this.material = '100% Premium Cotton',
    this.sizes = const ['S', 'M', 'L', 'XL'],
    this.colors = const ['Black', 'White', 'Navy'],
    this.reviewsCount = 142,
  });

  List<String> get allImages => gallery.isNotEmpty ? gallery : [image];
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

class VoucherModel {
  final String code;
  final String title;
  final int discountValue;
  final bool isPercentage;
  final int minSpend;
  final String formattedMinSpend;
  final String expiryDate;
  final String description;

  const VoucherModel({
    required this.code,
    required this.title,
    required this.discountValue,
    this.isPercentage = true,
    required this.minSpend,
    required this.formattedMinSpend,
    required this.expiryDate,
    required this.description,
  });

  int calculateDiscount(int subtotal) {
    if (subtotal < minSpend) return 0;
    if (isPercentage) {
      final discount = (subtotal * discountValue) ~/ 100;
      return discount > 100000 ? 100000 : discount; // Max cap 100k
    }
    return discountValue;
  }
}

class PaymentMethod {
  final String id;
  final String name;
  final String category; // 'E-Wallet', 'Virtual Account', 'Card'
  final String subtitle;
  final IconData icon;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.category,
    required this.subtitle,
    required this.icon,
  });
}

class WardrobePiece {
  final String id;
  final String name;
  final String category;
  final String image;
  final String dateAdded;
  final int usedInLooksCount;
  final String color;
  final String style;

  const WardrobePiece({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.dateAdded,
    this.usedInLooksCount = 0,
    this.color = 'Neutral',
    this.style = 'Casual',
  });
}

enum StylingMode {
  diy, // Susun Sendiri: Pilih item per item dari lemari / katalog
  guided, // Dipandu AI: Rekomendasi berdasarkan kategori / acara / style pilihan
  autopilot, // AI Tentukan Semua: 1-Click rekomendasi otomatis cuaca & profil
}

class OutfitRecommendation {
  final String id;
  final String title;
  final int matchScore;
  final String image;
  final List<ProductItem> items;
  final int totalNewItemsPrice;
  final int? bundleDiscountPrice;
  final int bundleDiscountPercentage;
  final List<String> whyMatchReasons;
  final String occasion;
  final String styleVibe;
  final String weatherNote;
  final String curatorType;

  const OutfitRecommendation({
    required this.id,
    required this.title,
    required this.matchScore,
    required this.image,
    required this.items,
    required this.totalNewItemsPrice,
    this.bundleDiscountPrice,
    this.bundleDiscountPercentage = 10,
    required this.whyMatchReasons,
    this.occasion = 'Campus',
    this.styleVibe = 'Casual',
    this.weatherNote = '28°C Sunny • Light & breathable',
    this.curatorType = 'AI Stylist',
  });

  int get effectivePrice => bundleDiscountPrice ?? (totalNewItemsPrice * (100 - bundleDiscountPercentage) ~/ 100);
}

class OrderModel {
  final String id;
  final String seller;
  final String itemTitle;
  final String price;
  final String image;
  final String status; // 'Processing', 'Shipped', 'Delivered'
  final String date;
  final String trackingNumber;
  final String courier;
  final String estimatedDelivery;
  final int itemsCount;

  const OrderModel({
    required this.id,
    required this.seller,
    required this.itemTitle,
    required this.price,
    required this.image,
    required this.status,
    required this.date,
    this.trackingNumber = 'FTL-882940192',
    this.courier = 'SiCepat Best (Express)',
    this.estimatedDelivery = 'Tomorrow, 30 Sep',
    this.itemsCount = 1,
  });
}

class TryOnResult {
  final String id;
  final String title;
  final String originalImageUrl;
  final String resultImageUrl;
  final List<ProductItem> garments;
  final ProductItem? newProduct;
  final List<WardrobePiece> ownedPieces;
  final int fitScore;
  final String recommendedSize;
  final String date;
  final String occasion;
  final String style;
  final String weather;
  final String bodyNotes;
  final List<String> compatibilityReasons;

  const TryOnResult({
    required this.id,
    required this.title,
    required this.originalImageUrl,
    required this.resultImageUrl,
    required this.garments,
    this.newProduct,
    this.ownedPieces = const [],
    required this.fitScore,
    required this.recommendedSize,
    required this.date,
    this.occasion = 'Campus',
    this.style = 'Smart Casual',
    this.weather = '28°C Sunny',
    this.bodyNotes = 'Optimal shoulder drape and proportional waist drop.',
    this.compatibilityReasons = const [
      'Color combination works',
      'Matches your preferred style',
      'Suitable for today\'s weather',
      'Matches your wardrobe',
      'Suitable for your selected occasion',
    ],
  });
}

class StylistLookOption {
  final String id;
  final String title;
  final List<String> itemNames;
  final int matchScore;
  final int estimatedPrice;
  final String weatherCompatibility;
  final List<ProductItem> missingItems;
  final List<WardrobePiece> ownedItems;
  final String image;

  const StylistLookOption({
    required this.id,
    required this.title,
    required this.itemNames,
    required this.matchScore,
    required this.estimatedPrice,
    required this.weatherCompatibility,
    required this.missingItems,
    required this.ownedItems,
    required this.image,
  });

  String get formattedEstimatedPrice => 'Rp${(estimatedPrice ~/ 1000)}.000';
}

class TryOnModelAvatar {
  final String id;
  final String name;
  final String gender;
  final String imageUrl;
  final String height;
  final String recommendedSize;
  final String bodyShape;

  const TryOnModelAvatar({
    required this.id,
    required this.name,
    required this.gender,
    required this.imageUrl,
    required this.height,
    required this.recommendedSize,
    required this.bodyShape,
  });
}

