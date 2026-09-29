import 'package:flutter/material.dart';
import '../models/models.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final String timestamp;
  final List<ProductItem>? attachedProducts;
  final OutfitRecommendation? attachedOutfit;
  final List<StylistLookOption>? stylistLookOptions;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.attachedProducts,
    this.attachedOutfit,
    this.stylistLookOptions,
  });
}

class AppState extends ChangeNotifier {
  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  // ===================== PRODUCT CATALOG =====================
  final List<ProductItem> _products = [
    const ProductItem(
      id: 'p_jacket',
      name: 'Black Oversized Jacket',
      seller: 'Studio Monolith',
      brand: 'Studio Monolith',
      price: 399000,
      formattedPrice: 'Rp399.000',
      originalPrice: 499000,
      formattedOriginalPrice: 'Rp499.000',
      discountPercentage: 20,
      image: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=600&auto=format&fit=crop&q=80',
      gallery: [
        'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?w=600&auto=format&fit=crop&q=80',
      ],
      category: 'Outerwear',
      styleCategory: 'Smart Casual',
      gender: 'Unisex',
      rating: 4.8,
      soldCount: '1.5K sold',
      badgeLabel: '94% AI Match',
      matchReason: 'Seamlessly matches your owned White T-Shirt, Black Pants, and White Sneakers.',
      matchPercentage: 94,
      description: 'Structured oversized tailored jacket with boxy drop shoulders, matte hardware snaps, and clean interior lining. An essential layering piece for campus and date occasions.',
      material: 'Structured Wool-Blend Twill',
      sizes: ['S', 'M', 'L', 'XL'],
      colors: ['Matte Black', 'Charcoal Grey'],
      reviewsCount: 218,
    ),
    const ProductItem(
      id: 'p1',
      name: 'Oversized Combed Black Tee',
      seller: 'Localwear Bandung',
      brand: 'Localwear',
      price: 129000,
      formattedPrice: 'Rp129.000',
      originalPrice: 169000,
      formattedOriginalPrice: 'Rp169.000',
      discountPercentage: 24,
      image: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=600&auto=format&fit=crop&q=80',
      gallery: [
        'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=600&auto=format&fit=crop&q=80',
      ],
      category: 'Tops',
      styleCategory: 'Streetwear',
      gender: 'Unisex',
      rating: 4.8,
      soldCount: '2.4K sold',
      badgeLabel: '96% AI Match',
      matchReason: 'Matches your preferred casual streetwear silhouette & relaxed fit.',
      matchPercentage: 96,
      description: 'Heavyweight 24s premium combed cotton with dropped shoulders and reinforced ribbed collar. Designed for everyday relaxed comfort by Bandung craftsmen.',
      material: '100% Cotton Combed 24s Heavyweight',
      sizes: ['S', 'M', 'L', 'XL', 'XXL'],
      colors: ['Black', 'Charcoal', 'Off White'],
      reviewsCount: 384,
    ),
    const ProductItem(
      id: 'p2',
      name: 'Relaxed Utility Cargo Pants',
      seller: 'Street Co.',
      brand: 'Street Co.',
      price: 189000,
      formattedPrice: 'Rp189.000',
      originalPrice: 249000,
      formattedOriginalPrice: 'Rp249.000',
      discountPercentage: 24,
      image: 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=600&auto=format&fit=crop&q=80',
      gallery: [
        'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1517445312882-bc9910d016b7?w=600&auto=format&fit=crop&q=80',
      ],
      category: 'Bottoms',
      styleCategory: 'Streetwear',
      gender: 'Unisex',
      rating: 4.9,
      soldCount: '1.9K sold',
      badgeLabel: 'Best Pick',
      matchReason: 'Pairs naturally with your owned low-top sneakers and oversized tees.',
      matchPercentage: 94,
      description: 'Military-grade cotton twill utility pants featuring 6 functional cargo pockets, elastic waist with toggle drawstring, and adjustable ankle cinch cords.',
      material: 'Durable Washed Cotton Twill',
      sizes: ['28', '30', '32', '34', '36'],
      colors: ['Olive Green', 'Jet Black', 'Beige Khaki'],
      reviewsCount: 295,
    ),
    const ProductItem(
      id: 'p3',
      name: 'Clean White Canvas Low-Tops',
      seller: 'Personal Wardrobe',
      brand: 'Wardrobe Core',
      price: 0,
      formattedPrice: 'Already owned',
      image: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=600&auto=format&fit=crop&q=80',
      category: 'Shoes',
      styleCategory: 'Casual',
      gender: 'Unisex',
      rating: 5.0,
      soldCount: 'Owned',
      isOwned: true,
      badgeLabel: 'In Your Wardrobe',
      matchReason: 'Core wardrobe piece that pairs with 92% of your recommended looks.',
      matchPercentage: 98,
      description: 'Your favorite clean white vulcanized low-top canvas sneakers saved in your digital wardrobe.',
      material: '12oz Canvas & Vulcanized Rubber',
      sizes: ['41 EUR'],
      colors: ['White'],
      reviewsCount: 0,
    ),
    const ProductItem(
      id: 'p4',
      name: 'Vintage Trucker Denim Jacket',
      seller: 'Kita Apparel Solo',
      brand: 'Kita Apparel',
      price: 245000,
      formattedPrice: 'Rp245.000',
      originalPrice: 320000,
      formattedOriginalPrice: 'Rp320.000',
      discountPercentage: 23,
      image: 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?w=600&auto=format&fit=crop&q=80',
      gallery: [
        'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=600&auto=format&fit=crop&q=80',
      ],
      category: 'Outerwear',
      styleCategory: 'Streetwear',
      gender: 'Unisex',
      rating: 4.8,
      soldCount: '860 sold',
      badgeLabel: 'Trending',
      matchReason: 'Ideal for layering during evening outings with relaxed vintage wash.',
      matchPercentage: 91,
      description: '13.5oz rigid washed denim with vintage fade, brass hardware buttons, and double chest flap pockets. Made locally in Surakarta.',
      material: '13.5oz Washed Denim Cotton',
      sizes: ['M', 'L', 'XL'],
      colors: ['Medium Vintage Wash', 'Deep Indigo'],
      reviewsCount: 178,
    ),
    const ProductItem(
      id: 'p5',
      name: 'Relaxed Minimalist Linen Shirt',
      seller: 'Ruang Basic',
      brand: 'Ruang Basic',
      price: 175000,
      formattedPrice: 'Rp175.000',
      originalPrice: 220000,
      formattedOriginalPrice: 'Rp220.000',
      discountPercentage: 20,
      image: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=600&auto=format&fit=crop&q=80',
      gallery: [
        'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=600&auto=format&fit=crop&q=80',
      ],
      category: 'Tops',
      styleCategory: 'Minimal',
      gender: 'Unisex',
      rating: 4.8,
      soldCount: '1.4K sold',
      badgeLabel: 'Weather Pick',
      matchReason: 'Ultra-breathable natural weave ideal for humid 28°C sunny weather.',
      matchPercentage: 95,
      description: 'Natural linen-cotton blended shirt with resort camp collar and shell buttons. Airy, relaxed drape for smart casual daily wear.',
      material: '55% Pure Linen, 45% Cotton',
      sizes: ['S', 'M', 'L', 'XL'],
      colors: ['Off-White', 'Sage Green', 'Warm Beige'],
      reviewsCount: 224,
    ),
    const ProductItem(
      id: 'p6',
      name: 'Pleated Straight Smart Trousers',
      seller: 'Studio Monolith',
      brand: 'Studio Monolith',
      price: 219000,
      formattedPrice: 'Rp219.000',
      originalPrice: 289000,
      formattedOriginalPrice: 'Rp289.000',
      discountPercentage: 24,
      image: 'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=600&auto=format&fit=crop&q=80',
      gallery: [
        'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=600&auto=format&fit=crop&q=80',
      ],
      category: 'Bottoms',
      styleCategory: 'Smart Casual',
      gender: 'Unisex',
      rating: 4.9,
      soldCount: '980 sold',
      badgeLabel: 'Office & Date',
      matchReason: 'Sharp tailored pleats elevate both casual sneakers and leather loafers.',
      matchPercentage: 93,
      description: 'Tailored front-pleat trousers cut from drape-resistant poly-viscose blend. Features hidden stretch waistband and clean ankle break.',
      material: 'Semi-Wool Poly-Viscose Blend',
      sizes: ['29', '30', '32', '34'],
      colors: ['Charcoal Gray', 'Cream White', 'Black'],
      reviewsCount: 164,
    ),
    const ProductItem(
      id: 'p7',
      name: 'Korean Boxy Wool Knit Cardigan',
      seller: 'K-Atelier',
      brand: 'K-Atelier',
      price: 229000,
      formattedPrice: 'Rp229.000',
      originalPrice: 310000,
      formattedOriginalPrice: 'Rp310.000',
      discountPercentage: 26,
      image: 'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=600&auto=format&fit=crop&q=80',
      gallery: [
        'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=600&auto=format&fit=crop&q=80',
      ],
      category: 'Outerwear',
      styleCategory: 'Korean Style',
      gender: 'Unisex',
      rating: 4.9,
      soldCount: '1.1K sold',
      badgeLabel: 'Limited Deal',
      matchReason: 'Soft knit silhouette with trendy Korean boxy drop fit.',
      matchPercentage: 94,
      description: 'Chunky waffle knit cardigan with horn buttons and oversized front patch pockets. Cosy yet structured aesthetic.',
      material: 'Soft Acrylic & Merino Wool Blend',
      sizes: ['M', 'L', 'XL'],
      colors: ['Sage Green', 'Oatmeal', 'Espresso'],
      reviewsCount: 198,
    ),
    const ProductItem(
      id: 'p8',
      name: 'Retro Chunky Leather Sneakers',
      seller: 'Localwear Bandung',
      brand: 'Localwear',
      price: 329000,
      formattedPrice: 'Rp329.000',
      originalPrice: 420000,
      formattedOriginalPrice: 'Rp420.000',
      discountPercentage: 22,
      image: 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=600&auto=format&fit=crop&q=80',
      gallery: [
        'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=600&auto=format&fit=crop&q=80',
      ],
      category: 'Shoes',
      styleCategory: 'Streetwear',
      gender: 'Unisex',
      rating: 4.8,
      soldCount: '740 sold',
      badgeLabel: 'Popular',
      matchReason: 'Chunky sole balances wide leg trousers and baggy cargo fits.',
      matchPercentage: 92,
      description: 'Action leather and breathable mesh upper with high-rebound EVA midsole for all-day campus walking comfort.',
      material: 'Full Grain Leather & Mesh',
      sizes: ['39', '40', '41', '42', '43', '44'],
      colors: ['White / Cream', 'Grey / Silver'],
      reviewsCount: 112,
    ),
    const ProductItem(
      id: 'p9',
      name: 'Everyday Canvas Crossbody Messenger',
      seller: 'Ruang Basic',
      brand: 'Ruang Basic',
      price: 135000,
      formattedPrice: 'Rp135.000',
      originalPrice: 175000,
      formattedOriginalPrice: 'Rp175.000',
      discountPercentage: 23,
      image: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=600&auto=format&fit=crop&q=80',
      gallery: [
        'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=600&auto=format&fit=crop&q=80',
      ],
      category: 'Bags',
      styleCategory: 'Minimal',
      gender: 'Unisex',
      rating: 4.7,
      soldCount: '2.1K sold',
      badgeLabel: 'Essential',
      matchReason: 'Fits 14-inch laptop, tablet, and campus accessories cleanly.',
      matchPercentage: 90,
      description: 'Water-repellent 14oz canvas messenger with quick-access magnetic flap and padded interior sleeve.',
      material: 'Water-resistant Canvas & YKK Hardware',
      sizes: ['One Size (12L)'],
      colors: ['Matte Black', 'Olive Drab', 'Natural Sand'],
      reviewsCount: 310,
    ),
    const ProductItem(
      id: 'p10',
      name: 'Essential Oversized Oxford Shirt',
      seller: 'ZARA Indonesia Official',
      brand: 'ZARA',
      price: 299000,
      formattedPrice: 'Rp299.000',
      originalPrice: 449000,
      formattedOriginalPrice: 'Rp449.000',
      discountPercentage: 33,
      image: 'https://images.unsplash.com/photo-1603252109303-2751441dd157?w=600&auto=format&fit=crop&q=80',
      gallery: [
        'https://images.unsplash.com/photo-1603252109303-2751441dd157?w=600&auto=format&fit=crop&q=80',
      ],
      category: 'Tops',
      styleCategory: 'Smart Casual',
      gender: 'Men',
      rating: 4.9,
      soldCount: '3.2K sold',
      badgeLabel: 'Brand Deal',
      matchReason: 'Classic button-down collar with modern relaxed boxy proportions.',
      matchPercentage: 97,
      description: '100% yarn-dyed Oxford cotton with soft pre-washed hand feel. Timeless design with curved hem and box pleat back.',
      material: '100% Pre-washed Oxford Cotton',
      sizes: ['S', 'M', 'L', 'XL'],
      colors: ['Crisp White', 'Sky Blue', 'Light Stripe'],
      reviewsCount: 420,
    ),
    const ProductItem(
      id: 'p11',
      name: 'Minimalist Stainless Cuban Chain',
      seller: 'Studio Monolith',
      brand: 'Studio Monolith',
      price: 89000,
      formattedPrice: 'Rp89.000',
      originalPrice: 120000,
      formattedOriginalPrice: 'Rp120.000',
      discountPercentage: 25,
      image: 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=600&auto=format&fit=crop&q=80',
      gallery: [
        'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=600&auto=format&fit=crop&q=80',
      ],
      category: 'Accessories',
      styleCategory: 'Streetwear',
      gender: 'Unisex',
      rating: 4.8,
      soldCount: '4.5K sold',
      badgeLabel: 'Complete The Look',
      matchReason: 'Adds subtle polished detail to plain tees and open collar shirts.',
      matchPercentage: 91,
      description: '316L medical-grade stainless steel with polished rhodium plating. 100% hypoallergenic, waterproof, and tarnish-free.',
      material: '316L Surgical Stainless Steel',
      sizes: ['50 cm', '55 cm'],
      colors: ['Silver', 'Gunmetal'],
      reviewsCount: 520,
    ),
    const ProductItem(
      id: 'p12',
      name: 'Relaxed Washed Wide-Leg Jeans',
      seller: 'Street Co.',
      brand: 'Street Co.',
      price: 239000,
      formattedPrice: 'Rp239.000',
      originalPrice: 319000,
      formattedOriginalPrice: 'Rp319.000',
      discountPercentage: 25,
      image: 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=600&auto=format&fit=crop&q=80',
      gallery: [
        'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=600&auto=format&fit=crop&q=80',
      ],
      category: 'Bottoms',
      styleCategory: 'Streetwear',
      gender: 'Unisex',
      rating: 4.8,
      soldCount: '1.7K sold',
      badgeLabel: 'Trending Now',
      matchReason: 'Clean medium blue wash with perfect stacking over sneakers.',
      matchPercentage: 95,
      description: 'Non-stretch 13oz cotton denim tailored with a roomy thigh and straight leg opening for authentic 90s streetwear drape.',
      material: '13oz Ring-Spun Cotton Denim',
      sizes: ['28', '30', '32', '34', '36'],
      colors: ['Vintage Light Blue', 'Medium Wash', 'Washed Black'],
      reviewsCount: 230,
    ),
  ];

  List<ProductItem> get products => List.unmodifiable(_products);

  // ===================== DISCOVER & SEARCH FILTER STATE =====================
  String _discoverSearchQuery = '';
  String get discoverSearchQuery => _discoverSearchQuery;

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  String _selectedDiscoverStyle = 'All';
  String get selectedDiscoverStyle => _selectedDiscoverStyle;

  String _selectedSort = 'AI Match';
  String get selectedSort => _selectedSort;

  RangeValues _priceRange = const RangeValues(50000, 500000);
  RangeValues get priceRange => _priceRange;

  void setDiscoverSearchQuery(String query) {
    _discoverSearchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setStyleFilter(String style) {
    _selectedDiscoverStyle = style;
    notifyListeners();
  }

  void setSortOption(String sort) {
    _selectedSort = sort;
    notifyListeners();
  }

  void setPriceRange(RangeValues range) {
    _priceRange = range;
    notifyListeners();
  }

  void resetDiscoverFilters() {
    _discoverSearchQuery = '';
    _selectedCategory = 'All';
    _selectedDiscoverStyle = 'All';
    _selectedSort = 'AI Match';
    _priceRange = const RangeValues(50000, 500000);
    notifyListeners();
  }

  List<ProductItem> get filteredProducts {
    var list = _products.where((p) {
      if (p.isOwned) return false; // Don't show owned items in shop search
      // Search query
      if (_discoverSearchQuery.trim().isNotEmpty) {
        final query = _discoverSearchQuery.toLowerCase();
        final matchesName = p.name.toLowerCase().contains(query);
        final matchesBrand = p.brand.toLowerCase().contains(query);
        final matchesCategory = p.category.toLowerCase().contains(query);
        final matchesStyle = p.styleCategory.toLowerCase().contains(query);
        if (!matchesName && !matchesBrand && !matchesCategory && !matchesStyle) {
          return false;
        }
      }
      // Category filter
      if (_selectedCategory != 'All') {
        if (_selectedCategory == 'Men' || _selectedCategory == 'Women') {
          if (p.gender != _selectedCategory && p.gender != 'Unisex') return false;
        } else if (p.category.toLowerCase() != _selectedCategory.toLowerCase()) {
          return false;
        }
      }
      // Style filter
      if (_selectedDiscoverStyle != 'All') {
        if (!p.styleCategory.toLowerCase().contains(_selectedDiscoverStyle.toLowerCase())) {
          return false;
        }
      }
      // Price range
      if (p.price < _priceRange.start || p.price > _priceRange.end) {
        return false;
      }
      return true;
    }).toList();

    // Sorting
    switch (_selectedSort) {
      case 'Price: Low to High':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Popular':
        list.sort((a, b) => b.reviewsCount.compareTo(a.reviewsCount));
        break;
      case 'Rating':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'AI Match':
      default:
        list.sort((a, b) => (b.matchPercentage ?? 80).compareTo(a.matchPercentage ?? 80));
        break;
    }

    return list;
  }

  // ===================== CART & VOUCHERS =====================
  final List<CartItem> _cart = [];
  List<CartItem> get cart => List.unmodifiable(_cart);

  final List<VoucherModel> availableVouchers = const [
    VoucherModel(
      code: 'FITLY10',
      title: 'Diskon 10% Spesial Fitly',
      discountValue: 10,
      isPercentage: true,
      minSpend: 200000,
      formattedMinSpend: 'Min. belanja Rp200.000',
      expiryDate: 'Berlaku s/d 31 Okt 2026',
      description: 'Potongan 10% s.d Rp100.000 untuk seluruh koleksi kurasi AI.',
    ),
    VoucherModel(
      code: 'NEWUSER',
      title: 'Diskon 15% Pengguna Baru',
      discountValue: 15,
      isPercentage: true,
      minSpend: 150000,
      formattedMinSpend: 'Min. belanja Rp150.000',
      expiryDate: 'Berlaku 14 hari',
      description: 'Spesial sambutan untuk pesanan fashion pertamamu di Fitly.',
    ),
    VoucherModel(
      code: 'FASHION20',
      title: 'Diskon 20% Bundle Look',
      discountValue: 20,
      isPercentage: true,
      minSpend: 400000,
      formattedMinSpend: 'Min. belanja Rp400.000',
      expiryDate: 'Berlaku s/d 15 Okt 2026',
      description: 'Potongan hemat 20% saat membeli minimal 1 outfit bundle lengkap.',
    ),
    VoucherModel(
      code: 'FREESHIP',
      title: 'Gratis Ongkir Se-Indonesia',
      discountValue: 20000,
      isPercentage: false,
      minSpend: 100000,
      formattedMinSpend: 'Min. belanja Rp100.000',
      expiryDate: 'Berlaku s/d 31 Okt 2026',
      description: 'Gratis ongkir reguler potongan Rp20.000.',
    ),
  ];

  VoucherModel? _appliedVoucher;
  VoucherModel? get appliedVoucher => _appliedVoucher;

  String _selectedShippingOption = 'Regular';
  String get selectedShippingOption => _selectedShippingOption;

  void setShippingOption(String option) {
    _selectedShippingOption = option;
    notifyListeners();
  }

  int get shippingCost {
    if (_cart.isEmpty) return 0;
    int baseCost = 15000;
    if (_selectedShippingOption == 'Express') baseCost = 25000;
    if (_selectedShippingOption == 'Same Day') baseCost = 40000;
    if (_appliedVoucher?.code == 'FREESHIP') {
      return (baseCost - 20000) < 0 ? 0 : (baseCost - 20000);
    }
    return baseCost;
  }

  void initializeDefaultCart() {
    if (_cart.isEmpty) {
      _cart.add(CartItem(product: _products[0], size: 'M', color: 'Black'));
      _cart.add(CartItem(product: _products[1], size: '32', color: 'Olive Green'));
      _appliedVoucher = availableVouchers[0]; // FITLY10 default
    }
  }

  bool applyVoucher(String code) {
    final found = availableVouchers.firstWhere(
      (v) => v.code.toUpperCase() == code.trim().toUpperCase(),
      orElse: () => const VoucherModel(
        code: '',
        title: '',
        discountValue: 0,
        minSpend: 0,
        formattedMinSpend: '',
        expiryDate: '',
        description: '',
      ),
    );
    if (found.code.isNotEmpty) {
      _appliedVoucher = found;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeVoucher() {
    _appliedVoucher = null;
    notifyListeners();
  }

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

  void addMultipleToCart(List<ProductItem> items) {
    for (final item in items) {
      if (!item.isOwned) {
        addToCart(item, item.sizes.first, item.colors.first);
      }
    }
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

  void removeFromCart(int index) {
    if (index >= 0 && index < _cart.length) {
      _cart.removeAt(index);
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    _appliedVoucher = null;
    notifyListeners();
  }

  int get cartCount => _cart.fold(0, (sum, item) => sum + item.quantity);
  int get cartSubtotal => _cart.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  int get voucherDiscountAmount => _appliedVoucher?.calculateDiscount(cartSubtotal) ?? 0;
  int get cartFinalTotal => (cartSubtotal - voucherDiscountAmount + shippingCost).clamp(0, 99999999);

  // Group cart items by seller
  Map<String, List<CartItem>> get cartGroupedBySeller {
    final Map<String, List<CartItem>> map = {};
    for (final item in _cart) {
      map.putIfAbsent(item.product.seller, () => []).add(item);
    }
    return map;
  }

  // ===================== WISHLIST & FAVORITES =====================
  final Set<String> _savedProductIds = {'p1', 'p2', 'p5', 'p10'};
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

  final Set<String> _savedOutfitIds = {'rec_1', 'rec_2'};
  Set<String> get savedOutfitIds => Set.unmodifiable(_savedOutfitIds);

  void toggleSaveOutfit(String outfitId) {
    if (_savedOutfitIds.contains(outfitId)) {
      _savedOutfitIds.remove(outfitId);
    } else {
      _savedOutfitIds.add(outfitId);
    }
    notifyListeners();
  }

  bool isOutfitSaved(String outfitId) => _savedOutfitIds.contains(outfitId);

  // ===================== USER DIGITAL WARDROBE =====================
  final List<WardrobePiece> _wardrobe = [
    // TOPS
    const WardrobePiece(
      id: 'w_top1',
      name: 'White Oversized Shirt',
      category: 'Tops',
      image: 'https://images.unsplash.com/photo-1603252109303-2751441dd157?w=600&auto=format&fit=crop&q=80',
      dateAdded: '12 Aug 2026',
      usedInLooksCount: 14,
      color: 'White',
      style: 'Smart Casual',
    ),
    const WardrobePiece(
      id: 'w_top2',
      name: 'Black T-Shirt',
      category: 'Tops',
      image: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=600&auto=format&fit=crop&q=80',
      dateAdded: '15 Jul 2026',
      usedInLooksCount: 18,
      color: 'Black',
      style: 'Streetwear',
    ),
    const WardrobePiece(
      id: 'w_top3',
      name: 'Beige Shirt',
      category: 'Tops',
      image: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=600&auto=format&fit=crop&q=80',
      dateAdded: '02 Sep 2026',
      usedInLooksCount: 6,
      color: 'Beige',
      style: 'Minimal',
    ),

    // BOTTOMS
    const WardrobePiece(
      id: 'w_bot1',
      name: 'Black Straight Pants',
      category: 'Bottoms',
      image: 'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=600&auto=format&fit=crop&q=80',
      dateAdded: '10 Sep 2026',
      usedInLooksCount: 12,
      color: 'Black',
      style: 'Smart Casual',
    ),
    const WardrobePiece(
      id: 'w_bot2',
      name: 'Blue Jeans',
      category: 'Bottoms',
      image: 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=600&auto=format&fit=crop&q=80',
      dateAdded: '01 Sep 2026',
      usedInLooksCount: 15,
      color: 'Blue',
      style: 'Casual',
    ),
    const WardrobePiece(
      id: 'w_bot3',
      name: 'Beige Chinos',
      category: 'Bottoms',
      image: 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=600&auto=format&fit=crop&q=80',
      dateAdded: '20 Aug 2026',
      usedInLooksCount: 9,
      color: 'Beige',
      style: 'Smart Casual',
    ),

    // SHOES
    const WardrobePiece(
      id: 'w_shoe1',
      name: 'White Sneakers',
      category: 'Shoes',
      image: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=600&auto=format&fit=crop&q=80',
      dateAdded: '12 Aug 2026',
      usedInLooksCount: 22,
      color: 'White',
      style: 'Casual',
    ),
    const WardrobePiece(
      id: 'w_shoe2',
      name: 'Black Sneakers',
      category: 'Shoes',
      image: 'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=600&auto=format&fit=crop&q=80',
      dateAdded: '05 Aug 2026',
      usedInLooksCount: 11,
      color: 'Black',
      style: 'Streetwear',
    ),

    // ACCESSORIES
    const WardrobePiece(
      id: 'w_acc1',
      name: 'Black Watch',
      category: 'Accessories',
      image: 'https://images.unsplash.com/photo-1524805444758-089113d48a6d?w=600&auto=format&fit=crop&q=80',
      dateAdded: '20 Aug 2026',
      usedInLooksCount: 8,
      color: 'Black',
      style: 'Minimal',
    ),
    const WardrobePiece(
      id: 'w_acc2',
      name: 'Crossbody Bag',
      category: 'Accessories',
      image: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=600&auto=format&fit=crop&q=80',
      dateAdded: '14 Sep 2026',
      usedInLooksCount: 7,
      color: 'Brown',
      style: 'Casual',
    ),
  ];

  List<WardrobePiece> get wardrobe => List.unmodifiable(_wardrobe);

  // Return categorized wardrobe pieces
  List<WardrobePiece> getWardrobeByCategory(String category) {
    if (category == 'All') return _wardrobe;
    return _wardrobe.where((item) => item.category.toLowerCase() == category.toLowerCase()).toList();
  }

  // Scenario B: AI recommendations for a selected wardrobe item
  List<ProductItem> getMatchingProductsForWardrobeItem(WardrobePiece item) {
    // Curated catalog recommendations that pair with this wardrobe item
    final List<ProductItem> list = [];
    final jacket = _products.firstWhere((p) => p.name.contains('Jacket') || p.id == 'p_jacket', orElse: () => _products[0]);
    final pants = _products.firstWhere((p) => p.name.contains('Trousers') || p.name.contains('Pants') || p.category == 'Bottoms', orElse: () => _products[1]);
    final shoes = _products.firstWhere((p) => p.category == 'Shoes' && !p.isOwned, orElse: () => _products[6]);
    final accessory = _products.firstWhere((p) => p.category == 'Accessories' || p.category == 'Bags', orElse: () => _products[8]);

    list.add(jacket);
    list.add(pants);
    list.add(shoes);
    list.add(accessory);
    return list;
  }

  // Pre-Try-On AI Outfit Compatibility Analyzer
  Map<String, dynamic> calculateOutfitCompatibility({
    required ProductItem newProduct,
    required List<WardrobePiece> selectedWardrobe,
    String occasion = 'Campus',
  }) {
    int score = 94; // Default high match
    final reasons = <String>[
      'Color combination works seamlessly',
      'Matches your preferred style (${userStyleProfileSummary.split(',').first.trim()})',
      'Suitable for today\'s weather (28°C Sunny)',
      'Matches your wardrobe aesthetics',
      'Suitable for your selected occasion ($occasion)',
    ];

    String? suggestion;
    bool hasBlackShoes = selectedWardrobe.any((w) => w.name.toLowerCase().contains('black sneaker'));
    if (hasBlackShoes) {
      suggestion = 'Try your white sneakers instead of black sneakers for a cleaner look.';
    }

    return {
      'score': score,
      'reasons': reasons,
      'suggestion': suggestion,
    };
  }

  void addWardrobePiece(WardrobePiece piece) {
    _wardrobe.insert(0, piece);
    notifyListeners();
  }

  // ===================== ORDERS & TRACKING =====================
  final List<OrderModel> _orders = [
    const OrderModel(
      id: 'FTL-99201',
      seller: 'Localwear Bandung',
      itemTitle: 'Oversized Combed Black Tee',
      price: 'Rp129.000',
      image: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=600&auto=format&fit=crop&q=80',
      status: 'In Transit',
      date: '28 Sep 2026',
      trackingNumber: 'SC-992019482',
      courier: 'SiCepat Regular',
      estimatedDelivery: 'Tomorrow, 30 Sep',
      itemsCount: 1,
    ),
    const OrderModel(
      id: 'FTL-88402',
      seller: 'Street Co.',
      itemTitle: 'Relaxed Cargo Pants',
      price: 'Rp189.000',
      image: 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=600&auto=format&fit=crop&q=80',
      status: 'Delivered',
      date: '22 Sep 2026',
      trackingNumber: 'JT-884021049',
      courier: 'J&T Express',
      estimatedDelivery: 'Delivered 24 Sep',
      itemsCount: 1,
    ),
    const OrderModel(
      id: 'FTL-77103',
      seller: 'Ruang Basic',
      itemTitle: 'Minimalist Linen Shirt',
      price: 'Rp175.000',
      image: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=600&auto=format&fit=crop&q=80',
      status: 'Delivered',
      date: '15 Sep 2026',
      trackingNumber: 'AN-771038102',
      courier: 'Anteraja Reguler',
      estimatedDelivery: 'Delivered 17 Sep',
      itemsCount: 1,
    ),
  ];

  List<OrderModel> get orders => List.unmodifiable(_orders);

  OrderModel? _recentlyPlacedOrder;
  OrderModel? get recentlyPlacedOrder => _recentlyPlacedOrder;

  OrderModel placeOrder({
    required String recipientName,
    required String address,
    required String paymentMethodName,
  }) {
    final newId = 'FTL-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final firstItem = _cart.isNotEmpty ? _cart.first.product : _products[0];
    final totalFormatted = 'Rp${(cartFinalTotal ~/ 1000)}.000';

    final order = OrderModel(
      id: newId,
      seller: firstItem.seller,
      itemTitle: _cart.length > 1 ? '${firstItem.name} + ${_cart.length - 1} lainnya' : firstItem.name,
      price: totalFormatted,
      image: firstItem.image,
      status: 'Order Confirmed',
      date: 'Today, 29 Sep 2026',
      trackingNumber: 'SC-$newId',
      courier: 'SiCepat Best ($selectedShippingOption)',
      estimatedDelivery: selectedShippingOption == 'Same Day'
          ? 'Today (by 21:00)'
          : selectedShippingOption == 'Express'
              ? 'Tomorrow, 30 Sep'
              : '2-3 Days (01-02 Oct)',
      itemsCount: _cart.length,
    );

    _orders.insert(0, order);
    _recentlyPlacedOrder = order;
    clearCart();
    notifyListeners();
    return order;
  }

  // ===================== USER PROFILE & AI SIZING =====================
  String userName = 'Rahmat Hidayat';
  String userEmail = 'rahmat.hidayat@example.com';
  String userLocation = 'Jakarta Selatan, Indonesia';
  String weatherLocation = '28°C Cerah • Jakarta';
  int userHeightCm = 178;
  int userWeightKg = 70;
  String userPreferredSize = 'L';
  String userStyleProfileSummary = 'Smart Casual, Streetwear, Minimal';

  void updateUserProfile({
    String? name,
    int? height,
    int? weight,
    String? preferredSize,
  }) {
    if (name != null) userName = name;
    if (height != null) userHeightCm = height;
    if (weight != null) userWeightKg = weight;
    if (preferredSize != null) userPreferredSize = preferredSize;
    notifyListeners();
  }

  String getRecommendedSizeForProduct(ProductItem product) {
    if (userWeightKg > 78 || userHeightCm > 182) return 'XL';
    if (userWeightKg > 68 || userHeightCm > 174) return 'L';
    if (userWeightKg > 58 || userHeightCm > 165) return 'M';
    return 'S';
  }

  // ===================== CURATED OUTFIT RECOMMENDATIONS =====================
  late final List<OutfitRecommendation> _curatedOutfits = [
    OutfitRecommendation(
      id: 'rec_1',
      title: 'Clean Campus Look',
      matchScore: 96,
      image: 'https://images.unsplash.com/photo-1516257984-b1b4d707412e?w=600&auto=format&fit=crop&q=80',
      items: [_products[0], _products[1], _products[2], _products[8]],
      totalNewItemsPrice: 453000,
      bundleDiscountPrice: 399000,
      bundleDiscountPercentage: 12,
      whyMatchReasons: const [
        'Perfect for today\'s 28°C weather with breathable 24s combed cotton',
        'Pairs with your owned White Canvas Sneakers (Wardrobe)',
        'Calibrated with relaxed streetwear silhouette fit and practical messenger bag',
      ],
      occasion: 'Campus',
      styleVibe: 'Casual',
      weatherNote: '28°C Sunny • Light & breathable cotton',
      curatorType: 'AI Daily Highlight',
    ),
    OutfitRecommendation(
      id: 'rec_2',
      title: 'Smart Casual Coffee Date',
      matchScore: 94,
      image: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=600&auto=format&fit=crop&q=80',
      items: [_products[4], _products[5], _products[2]],
      totalNewItemsPrice: 394000,
      bundleDiscountPrice: 349000,
      bundleDiscountPercentage: 11,
      whyMatchReasons: const [
        'Airy open camp collar linen shirt keeps you comfortable in warm weather',
        'Sharp pleated trousers elevate the aesthetic effortlessly',
        'Pairs with your owned White Sneakers from your digital wardrobe',
      ],
      occasion: 'Date',
      styleVibe: 'Smart Casual',
      weatherNote: '27°C Pleasant • Relaxed open collar',
      curatorType: 'AI Guided Recommendation',
    ),
    OutfitRecommendation(
      id: 'rec_3',
      title: 'Urban Vintage Explorer',
      matchScore: 93,
      image: 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?w=600&auto=format&fit=crop&q=80',
      items: [_products[3], _products[0], _products[11]],
      totalNewItemsPrice: 613000,
      bundleDiscountPrice: 549000,
      bundleDiscountPercentage: 10,
      whyMatchReasons: const [
        'Structured denim jacket layering for evening hangout and breezes',
        'Balanced streetwear proportions with wide leg stacking',
        'Pairs Bandung and Solo crafted premium local garments',
      ],
      occasion: 'Hangout',
      styleVibe: 'Streetwear',
      weatherNote: '25°C Evening • Structured denim layering',
      curatorType: 'AI Guided Recommendation',
    ),
    OutfitRecommendation(
      id: 'rec_4',
      title: 'Creative Modern Office',
      matchScore: 95,
      image: 'https://images.unsplash.com/photo-1603252109303-2751441dd157?w=600&auto=format&fit=crop&q=80',
      items: [_products[9], _products[5], _products[10]],
      totalNewItemsPrice: 607000,
      bundleDiscountPrice: 539000,
      bundleDiscountPercentage: 11,
      whyMatchReasons: const [
        'Crisp oversized Oxford shirt tailored for creative workplace aesthetics',
        'Wrinkle-resistant poly-viscose pleat trousers for long meetings',
        'Subtle silver Cuban chain accents open collar neatly',
      ],
      occasion: 'Office',
      styleVibe: 'Minimal',
      weatherNote: '24°C Air-Conditioned Comfort • Clean lines',
      curatorType: 'AI Professional Curated',
    ),
    OutfitRecommendation(
      id: 'rec_5',
      title: 'Seoul Street Minimalist',
      matchScore: 92,
      image: 'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=600&auto=format&fit=crop&q=80',
      items: [_products[6], _products[1], _products[7]],
      totalNewItemsPrice: 747000,
      bundleDiscountPrice: 669000,
      bundleDiscountPercentage: 10,
      whyMatchReasons: const [
        'Korean boxy knit silhouette with earthy sage and olive harmony',
        'High-comfort chunky sneakers complement relaxed trousers',
        'Modern casual vibe for weekend travel or gallery hopping',
      ],
      occasion: 'Travel',
      styleVibe: 'Korean Style',
      weatherNote: '26°C Gentle Breeze • Soft textured knit',
      curatorType: 'Trending Korean Look',
    ),
  ];

  List<OutfitRecommendation> get curatedOutfits => List.unmodifiable(_curatedOutfits);

  OutfitRecommendation get heroOutfit => _curatedOutfits[0];

  OutfitRecommendation getOutfitForOccasion(String occasion) {
    return _curatedOutfits.firstWhere(
      (o) => o.occasion.toLowerCase() == occasion.toLowerCase(),
      orElse: () => _curatedOutfits[0],
    );
  }

  // ===================== AI STYLIST CHAT =====================
  final List<ChatMessage> _chatMessages = [
    ChatMessage(
      id: 'c1',
      text: 'Halo Rahmat! Aku Fitly AI Stylist pribadimu. Ada rencana outfit apa hari ini? Mau gaya kasual, ngantor, atau hangout bareng teman?',
      isUser: false,
      timestamp: '10:00',
    ),
  ];

  List<ChatMessage> get chatMessages => List.unmodifiable(_chatMessages);

  void sendUserChatMessage(String query) {
    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    _chatMessages.add(ChatMessage(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      text: query,
      isUser: true,
      timestamp: timeStr,
    ));
    notifyListeners();

    // Generate intelligent AI response based on query
    Future.delayed(const Duration(milliseconds: 700), () {
      final q = query.toLowerCase();
      ChatMessage response;

      if (q.contains('white') || q.contains('putih') || q.contains('wear my white') || q.contains('shirt tomorrow')) {
        final jacketProduct = _products.firstWhere((p) => p.id == 'p_jacket', orElse: () => _products[0]);
        final pantsProduct = _products.firstWhere((p) => p.name.contains('Trousers') || p.id == 'p6', orElse: () => _products[1]);

        response = ChatMessage(
          id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
          text: 'Here are 3 looks using your white shirt:',
          isUser: false,
          timestamp: timeStr,
          stylistLookOptions: [
            StylistLookOption(
              id: 'look_1',
              title: 'Look 1: Clean Campus Minimalist',
              itemNames: ['White Shirt (Owned)', 'Black Straight Pants', 'White Sneakers (Owned)'],
              matchScore: 96,
              estimatedPrice: pantsProduct.price,
              weatherCompatibility: '28°C Sunny • Light & breathable',
              missingItems: [pantsProduct],
              ownedItems: [_wardrobe[0], _wardrobe[6]],
              image: 'https://images.unsplash.com/photo-1516257984-b1b4d707412e?w=600&auto=format&fit=crop&q=80',
            ),
            StylistLookOption(
              id: 'look_2',
              title: 'Look 2: Casual Everyday Denim',
              itemNames: ['White Shirt (Owned)', 'Blue Jeans (Owned)', 'Black Sneakers (Owned)'],
              matchScore: 94,
              estimatedPrice: 0,
              weatherCompatibility: '28°C Pleasant • 100% Wardrobe combo',
              missingItems: [],
              ownedItems: [_wardrobe[0], _wardrobe[4], _wardrobe[7]],
              image: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=600&auto=format&fit=crop&q=80',
            ),
            StylistLookOption(
              id: 'look_3',
              title: 'Look 3: Smart Layered Statement',
              itemNames: ['White Shirt (Owned)', 'Black Oversized Jacket', 'Black Pants'],
              matchScore: 97,
              estimatedPrice: jacketProduct.price,
              weatherCompatibility: '26°C Evening • Layered smart silhouette',
              missingItems: [jacketProduct],
              ownedItems: [_wardrobe[0], _wardrobe[3]],
              image: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=600&auto=format&fit=crop&q=80',
            ),
          ],
        );
      } else if (q.contains('besok') || q.contains('tomorrow') || q.contains('weather') || q.contains('cuaca')) {
        response = ChatMessage(
          id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
          text: 'Prakiraan besok sekitar 28°C cerah! Rekomendasi terbaikku adalah "Clean Campus Look" dengan bahan katun 24s yang adem & breathable:',
          isUser: false,
          timestamp: timeStr,
          attachedOutfit: _curatedOutfits[0],
          attachedProducts: [_products[0], _products[1], _products[8]],
        );
      } else if (q.contains('hitam') || q.contains('black') || q.contains('500') || q.contains('budget')) {
        response = ChatMessage(
          id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
          text: 'Ini kombinasi all-black / dark streetwear di bawah Rp500.000 dengan diskon voucher FITLY10:',
          isUser: false,
          timestamp: timeStr,
          attachedProducts: [_products[0], _products[11], _products[10]],
        );
      } else if (q.contains('date') || q.contains('kencan') || q.contains('formal')) {
        response = ChatMessage(
          id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
          text: 'Untuk kencan santai tapi tetap classy, kombinasikan kemeja linen natural dengan celana pleat cream. Tampak bersih dan rapi:',
          isUser: false,
          timestamp: timeStr,
          attachedOutfit: _curatedOutfits[1],
          attachedProducts: [_products[4], _products[5]],
        );
      } else {
        response = ChatMessage(
          id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
          text: 'Ini kurasi outfit rekomendasi AI yang cocok dengan profile gayamu (Smart Casual & Streetwear):',
          isUser: false,
          timestamp: timeStr,
          attachedOutfit: _curatedOutfits[2],
          attachedProducts: [_products[3], _products[0], _products[1]],
        );
      }

      _chatMessages.add(response);
      notifyListeners();
    });
  }

  // ===================== SUPPORTING TRY-ON STATE =====================
  static final List<TryOnModelAvatar> defaultAvatars = [
    const TryOnModelAvatar(
      id: 'm1',
      name: 'Rahmat (Avatar Profil)',
      gender: 'Male',
      imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600&auto=format&fit=crop&q=80',
      height: '178 cm',
      recommendedSize: 'L',
      bodyShape: 'Athletic / Regular',
    ),
    const TryOnModelAvatar(
      id: 'm2',
      name: 'Maya Putri',
      gender: 'Female',
      imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=600&auto=format&fit=crop&q=80',
      height: '165 cm',
      recommendedSize: 'S',
      bodyShape: 'Slim / Hourglass',
    ),
    const TryOnModelAvatar(
      id: 'm3',
      name: 'Kenzo Pratama',
      gender: 'Male',
      imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=600&auto=format&fit=crop&q=80',
      height: '182 cm',
      recommendedSize: 'XL',
      bodyShape: 'Broad / Tall',
    ),
  ];

  List<TryOnModelAvatar> get modelAvatars => defaultAvatars;

  TryOnModelAvatar _selectedAvatar = defaultAvatars[0];
  TryOnModelAvatar get selectedAvatar => _selectedAvatar;

  String? _customUserPhotoPath;
  String? get customUserPhotoPath => _customUserPhotoPath;

  ProductItem? _activeTryOnTop;
  ProductItem? get activeTryOnTop => _activeTryOnTop;

  ProductItem? _activeTryOnBottom;
  ProductItem? get activeTryOnBottom => _activeTryOnBottom;

  ProductItem? _activeTryOnShoes;
  ProductItem? get activeTryOnShoes => _activeTryOnShoes;

  ProductItem? _activeTryOnOuterwear;
  ProductItem? get activeTryOnOuterwear => _activeTryOnOuterwear;

  final List<TryOnResult> _tryOnHistory = [];
  List<TryOnResult> get tryOnHistory => List.unmodifiable(_tryOnHistory);

  void initializeTryOnDefaults() {
    _activeTryOnTop ??= _products[0];
    _activeTryOnBottom ??= _products[1];
    _activeTryOnShoes ??= _products[2];

    if (_tryOnHistory.isEmpty) {
      _tryOnHistory.addAll([
        TryOnResult(
          id: 'tr_1',
          title: 'Clean Campus Minimalist',
          originalImageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600&auto=format&fit=crop&q=80',
          resultImageUrl: 'https://images.unsplash.com/photo-1516257984-b1b4d707412e?w=600&auto=format&fit=crop&q=80',
          garments: [_products[0], _products[1], _products[2]],
          fitScore: 96,
          recommendedSize: 'Size L',
          date: '28 Sep 2026',
          occasion: 'Campus',
          bodyNotes: 'Shoulders fit relaxed with clean 2.5cm drop. Cargo waist sits comfortably with room for movement.',
        ),
      ]);
    }
  }

  void selectAvatar(TryOnModelAvatar avatar) {
    _selectedAvatar = avatar;
    _customUserPhotoPath = null;
    notifyListeners();
  }

  void setCustomUserPhoto(String path) {
    _customUserPhotoPath = path;
    notifyListeners();
  }

  void setTryOnGarment(ProductItem item) {
    switch (item.category) {
      case 'Tops':
        _activeTryOnTop = item;
        break;
      case 'Bottoms':
        _activeTryOnBottom = item;
        break;
      case 'Shoes':
        _activeTryOnShoes = item;
        break;
      default:
        _activeTryOnOuterwear = item;
        break;
    }
    notifyListeners();
  }

  void clearActiveTryOn() {
    _activeTryOnTop = null;
    _activeTryOnBottom = null;
    _activeTryOnShoes = null;
    _activeTryOnOuterwear = null;
    notifyListeners();
  }

  void startTryOnWithProduct(ProductItem item) {
    initializeTryOnDefaults();
    setTryOnGarment(item);
  }

  void startTryOnWithLook(List<ProductItem> items) {
    clearActiveTryOn();
    for (final item in items) {
      setTryOnGarment(item);
    }
  }

  void addTryOnResult(TryOnResult result) {
    _tryOnHistory.insert(0, result);
    notifyListeners();
  }

  List<ProductItem> get activeTryOnGarments {
    final list = <ProductItem>[];
    if (_activeTryOnOuterwear != null) list.add(_activeTryOnOuterwear!);
    if (_activeTryOnTop != null) list.add(_activeTryOnTop!);
    if (_activeTryOnBottom != null) list.add(_activeTryOnBottom!);
    if (_activeTryOnShoes != null) list.add(_activeTryOnShoes!);
    return list;
  }

  void removeTryOnGarment(String category) {
    switch (category) {
      case 'Tops':
        _activeTryOnTop = null;
        break;
      case 'Bottoms':
        _activeTryOnBottom = null;
        break;
      case 'Shoes':
        _activeTryOnShoes = null;
        break;
      default:
        _activeTryOnOuterwear = null;
        break;
    }
    notifyListeners();
  }

  // ===================== STYLING MODE HELPERS =====================
  StylingMode _activeStylingMode = StylingMode.diy;
  StylingMode get activeStylingMode => _activeStylingMode;

  void setStylingMode(StylingMode mode) {
    _activeStylingMode = mode;
    notifyListeners();
  }

  OutfitRecommendation getDailyAutopilotOutfit() => _curatedOutfits[0];

  int _shuffleIndex = 0;
  OutfitRecommendation getRandomAIOutfit() {
    _shuffleIndex = (_shuffleIndex + 1) % _curatedOutfits.length;
    return _curatedOutfits[_shuffleIndex];
  }

  List<OutfitRecommendation> getFilteredOutfits({String? occasion, String? style}) {
    return _curatedOutfits.where((outfit) {
      final matchesOccasion = occasion == null || occasion == 'All' || outfit.occasion.toLowerCase() == occasion.toLowerCase();
      final matchesStyle = style == null || style == 'All' || outfit.styleVibe.toLowerCase() == style.toLowerCase();
      return matchesOccasion && matchesStyle;
    }).toList();
  }

  void applyOutfitToTryOn(OutfitRecommendation look) {
    clearActiveTryOn();
    for (final item in look.items) {
      setTryOnGarment(item);
    }
    notifyListeners();
  }

  // ===================== USER PREFERENCE OPTIONS =====================
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

