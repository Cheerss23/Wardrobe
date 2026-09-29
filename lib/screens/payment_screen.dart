import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'order_tracking_screen.dart';

class PaymentScreen extends StatefulWidget {
  final int totalAmount;
  final String recipientName;
  final String address;

  const PaymentScreen({
    super.key,
    required this.totalAmount,
    required this.recipientName,
    required this.address,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethodId = 'gopay';
  bool _isProcessing = false;
  bool _isSuccess = false;
  OrderModel? _confirmedOrder;

  final List<PaymentMethod> _methods = const [
    PaymentMethod(
      id: 'gopay',
      name: 'GoPay',
      category: 'E-Wallet',
      subtitle: 'Saldo: Rp450.000 • Terhubung',
      icon: Icons.account_balance_wallet_rounded,
    ),
    PaymentMethod(
      id: 'ovo',
      name: 'OVO',
      category: 'E-Wallet',
      subtitle: 'Instan & Bebas Biaya Admin',
      icon: Icons.wallet_rounded,
    ),
    PaymentMethod(
      id: 'dana',
      name: 'DANA',
      category: 'E-Wallet',
      subtitle: 'Saldo Terproteksi',
      icon: Icons.mobile_friendly_rounded,
    ),
    PaymentMethod(
      id: 'bca_va',
      name: 'BCA Virtual Account',
      category: 'Virtual Account',
      subtitle: 'Verifikasi Otomatis 24 Jam',
      icon: Icons.account_balance_rounded,
    ),
    PaymentMethod(
      id: 'mandiri_va',
      name: 'Mandiri Virtual Account',
      category: 'Virtual Account',
      subtitle: 'Bayar via Livin\' by Mandiri',
      icon: Icons.account_balance_rounded,
    ),
    PaymentMethod(
      id: 'credit_card',
      name: 'Kartu Kredit / Debit',
      category: 'Card',
      subtitle: 'Visa, Mastercard, JCB (Cicilan 0%)',
      icon: Icons.credit_card_rounded,
    ),
  ];

  void _handlePayment(AppState appState) async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate safe payment gateway processing
    await Future.delayed(const Duration(milliseconds: 1400));

    final selectedMethod = _methods.firstWhere((m) => m.id == _selectedPaymentMethodId);
    final order = appState.placeOrder(
      recipientName: widget.recipientName,
      address: widget.address,
      paymentMethodName: selectedMethod.name,
    );

    if (mounted) {
      setState(() {
        _isProcessing = false;
        _isSuccess = true;
        _confirmedOrder = order;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    // Processing State View
    if (_isProcessing) {
      final method = _methods.firstWhere((m) => m.id == _selectedPaymentMethodId);
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.primaryPurpleLight,
                  shape: BoxShape.circle,
                ),
                child: const SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(
                    color: AppColors.primaryPurple,
                    strokeWidth: 4,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Memproses Pembayaran...',
                style: GoogleFonts.fraunces(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Menghubungkan ke ${method.name} secara aman',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Success State View
    if (_isSuccess && _confirmedOrder != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    size: 72,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Pembayaran Berhasil!',
                  style: GoogleFonts.fraunces(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Terima kasih, pesananmu segera disiapkan oleh seller.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 24),

                // Order Receipt Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Nomor Pesanan', style: GoogleFonts.inter(color: AppColors.secondaryText, fontSize: 13)),
                          Text(_confirmedOrder!.id, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.primaryPurple)),
                        ],
                      ),
                      const Divider(height: 20, color: AppColors.border),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Dibayar', style: GoogleFonts.inter(color: AppColors.secondaryText, fontSize: 13)),
                          Text('Rp${(widget.totalAmount ~/ 1000)}.000', style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.primaryText)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Estimasi Tiba', style: GoogleFonts.inter(color: AppColors.secondaryText, fontSize: 13)),
                          Text(_confirmedOrder!.estimatedDelivery, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.primaryText)),
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // CTAs
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderTrackingScreen(order: _confirmedOrder!),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      'Lacak Pesanan (Track Order)',
                      style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {
                      appState.setTabIndex(0);
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryPurple),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      'Lanjut Belanja',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryPurple),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Default Payment Selection Screen
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Metode Pembayaran',
          style: GoogleFonts.fraunces(fontWeight: FontWeight.bold, fontSize: 19),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          // Total Amount Header Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Tagihan',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.secondaryText),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Rp${(widget.totalAmount ~/ 1000)}.000',
                      style: GoogleFonts.fraunces(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurpleLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shield_rounded, size: 14, color: AppColors.primaryPurple),
                      const SizedBox(width: 4),
                      Text(
                        '100% Aman',
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Pilih Metode Pembayaran',
            style: GoogleFonts.fraunces(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 10),

          // Payment Methods List
          ..._methods.map((method) {
            final isSelected = _selectedPaymentMethodId == method.id;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedPaymentMethodId = method.id;
                  });
                },
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryPurple : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryPurpleLight : AppColors.softSurface,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          method.icon,
                          color: isSelected ? AppColors.primaryPurple : AppColors.secondaryText,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              method.name,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryText,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              method.subtitle,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? AppColors.primaryPurple : Colors.transparent,
                          border: Border.all(
                            color: isSelected ? AppColors.primaryPurple : AppColors.secondaryText,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, size: 12, color: Colors.white)
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),

      // Sticky Bottom Pay Button
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: const Border(top: BorderSide(color: AppColors.border)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => _handlePayment(appState),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_rounded, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Bayar Rp${(widget.totalAmount ~/ 1000)}.000',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
