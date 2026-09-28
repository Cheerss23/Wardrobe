import 'package:flutter/foundation.dart';
import '../models/models.dart';

class AppState extends ChangeNotifier {
  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  // Sample Products from UMKM Sellers
  final List<ProductItem> _products = [
    const ProductItem(
      id: 'p1',
      name: 'Oversized Black Tee',
      seller: 'Localwear',
      price: 129000,
      formattedPrice: 'Rp129.000',
      image: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=600&auto=format&fit=crop&q=80',
      category: 'Tops',
      rating: 4.8,
      badgeLabel: 'Matches your style',
      matchReason: 'Matches your preferred casual style & relaxed silhouette.',
      matchPercentage: 94,
      description: 'Heavyweight 24s combed cotton with relaxed drop shoulder fit. Handcrafted by Localwear UMKM Bandung.',
    ),
    const ProductItem(
      id: 'p2',
      name: 'Relaxed Cargo Pants',
      seller: 'Street Co.',
      price: 189000,
      formattedPrice: 'Rp189.000',
      image: 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=600&auto=format&fit=crop&q=80',
      category: 'Bottoms',
      rating: 4.9,
      badgeLabel: 'Within your budget',
      matchReason: 'Pairs naturally with your owned white sneakers.',
      matchPercentage: 92,
      description: 'Durable cotton twill utility pants featuring 6 deep pockets and adjustable ankle drawstring by Street Co.',
    ),
    const ProductItem(
      id: 'p3',
      name: 'White Canvas Sneakers',
      seller: 'Personal Wardrobe',
      price: 0,
      formattedPrice: 'Already owned',
      image: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=600&auto=format&fit=crop&q=80',
      category: 'Shoes',
      rating: 5.0,
      isOwned: true,
      badgeLabel: 'Already owned',
      matchReason: 'Matches 3 of your saved AI looks.',
      matchPercentage: 96,
      description: 'Your favorite clean white low-top canvas sneakers from your digital wardrobe.',
    ),
    const ProductItem(
      id: 'p4',
      name: 'Vintage Denim Jacket',
      seller: 'Kita Apparel',
      price: 245000,
      formattedPrice: 'Rp245.000',
      image: 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?w=600&auto=format&fit=crop&q=80',
      category: 'Tops',
      rating: 4.7,
      badgeLabel: 'New from UMKM',
      matchReason: 'Fits your streetwear preference.',
      matchPercentage: 88,
      description: 'Medium wash vintage denim with washed texture by Kita Apparel Solo.',
    ),
    const ProductItem(
      id: 'p5',
      name: 'Minimalist Linen Shirt',
      seller: 'Ruang Basic',
      price: 175000,
      formattedPrice: 'Rp175.000',
      image: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=600&auto=format&fit=crop&q=80',
      category: 'Tops',
      rating: 4.8,
      badgeLabel: 'Matches your style',
      matchReason: 'Clean breathable neutral weave.',
      matchPercentage: 90,
      description: '100% natural linen oversized shirt for warm days, tailored by Ruang Basic.',
    ),
  ];

  List<ProductItem> get products => List.unmodifiable(_products);

  // Initial cart populated with AI recommendation sample
  final List<CartItem> _cart = [];
  List<CartItem> get cart => List.unmodifiable(_cart);

  void initializeDefaultCart() {
    if (_cart.isEmpty) {
      _cart.add(CartItem(product: _products[0], size: 'M', color: 'Black'));
      _cart.add(CartItem(product: _products[1], size: 'L', color: 'Olive'));
    }
  }

  // Saved / Favorites
  final Set<String> _savedProductIds = {'p1', 'p2'};
  Set<String> get savedProductIds => Set.unmodifiable(_savedProductIds);

  void toggleSave(String productId) {
    if (_savedProductIds.contains(productId)) {
      _savedProductIds.remove(productId);
    } else {
      _savedProductIds.add(productId);
    }
    notifyListeners();
  }

  bool isSaved(String productId) => _savedProductIds.contains(productId);

  // Cart operations
  void addToCart(ProductItem product, String size, String color) {
    final existingIndex = _cart.indexWhere((item) =>
        item.product.id == product.id && item.size == size && item.color == color);
    if (existingIndex != -1) {
      _cart[existingIndex].quantity += 1;
    } else {
      _cart.add(CartItem(product: product, size: size, color: color));
    }
    notifyListeners();
  }

  void updateQuantity(int index, int delta) {
    if (index >= 0 && index < _cart.length) {
      _cart[index].quantity += delta;
      if (_cart[index].quantity <= 0) {
        _cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  int get cartCount => _cart.fold(0, (sum, item) => sum + item.quantity);
  int get cartSubtotal => _cart.fold(0, (sum, item) => sum + (item.product.price * item.quantity));

  // Wardrobe Items
  final List<WardrobePiece> _wardrobe = const [
    WardrobePiece(
      id: 'w1',
      name: 'White Canvas Sneakers',
      category: 'Shoes',
      image: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=600&auto=format&fit=crop&q=80',
      dateAdded: '12 Aug 2026',
      usedInLooksCount: 6,
    ),
    WardrobePiece(
      id: 'w2',
      name: 'Relaxed Denim Jeans',
      category: 'Bottoms',
      image: 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=600&auto=format&fit=crop&q=80',
      dateAdded: '01 Sep 2026',
      usedInLooksCount: 8,
    ),
    WardrobePiece(
      id: 'w3',
      name: 'Black Heavyweight Hoodie',
      category: 'Tops',
      image: 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=600&auto=format&fit=crop&q=80',
      dateAdded: '15 Jul 2026',
      usedInLooksCount: 4,
    ),
    WardrobePiece(
      id: 'w4',
      name: 'Silver Cuban Chain',
      category: 'Accessories',
      image: 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=600&auto=format&fit=crop&q=80',
      dateAdded: '20 Aug 2026',
      usedInLooksCount: 5,
    ),
    WardrobePiece(
      id: 'w5',
      name: 'Sage Green Knit Sweater',
      category: 'Tops',
      image: 'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=600&auto=format&fit=crop&q=80',
      dateAdded: '04 Sep 2026',
      usedInLooksCount: 3,
    ),
    WardrobePiece(
      id: 'w6',
      name: 'Cream Tailored Trousers',
      category: 'Bottoms',
      image: 'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=600&auto=format&fit=crop&q=80',
      dateAdded: '10 Sep 2026',
      usedInLooksCount: 4,
    ),
  ];

  List<WardrobePiece> get wardrobe => _wardrobe;

  // Orders Data
  final List<OrderModel> _orders = const [
    OrderModel(
      id: 'o1',
      seller: 'Localwear',
      itemTitle: 'Oversized Black Tee',
      price: 'Rp129.000',
      image: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=600&auto=format&fit=crop&q=80',
      status: 'Shipped',
      date: '26 Sep 2026',
    ),
    OrderModel(
      id: 'o2',
      seller: 'Street Co.',
      itemTitle: 'Relaxed Cargo Pants',
      price: 'Rp189.000',
      image: 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=600&auto=format&fit=crop&q=80',
      status: 'Delivered',
      date: '20 Sep 2026',
    ),
    OrderModel(
      id: 'o3',
      seller: 'Ruang Basic',
      itemTitle: 'Minimalist Linen Shirt',
      price: 'Rp175.000',
      image: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=600&auto=format&fit=crop&q=80',
      status: 'Processing',
      date: '28 Sep 2026',
    ),
  ];

  List<OrderModel> get orders => _orders;

  // AI Selection options state
  String selectedOccasion = 'Campus';
  String selectedStyle = 'Casual';
  String selectedBudget = 'Rp200K–500K';
  bool useWardrobePreference = true;
  bool usePurchaseHistoryPreference = true;

  void setOccasion(String occasion) {
    selectedOccasion = occasion;
    notifyListeners();
  }

  void setStyle(String style) {
    selectedStyle = style;
    notifyListeners();
  }

  void setBudget(String budget) {
    selectedBudget = budget;
    notifyListeners();
  }

  void toggleWardrobePref(bool val) {
    useWardrobePreference = val;
    notifyListeners();
  }

  void toggleHistoryPref(bool val) {
    usePurchaseHistoryPreference = val;
    notifyListeners();
  }
}
