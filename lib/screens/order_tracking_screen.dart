import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class OrderTrackingScreen extends StatelessWidget {
  final OrderModel order;

  const OrderTrackingScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    final steps = [
      {'title': 'Pesanan Dikonfirmasi', 'time': '29 Sep, 10:15 WIB', 'done': true},
      {'title': 'Pembayaran Terverifikasi', 'time': '29 Sep, 10:16 WIB', 'done': true},
      {'title': 'Pesanan Sedang Dikemas Seller', 'time': '29 Sep, 11:30 WIB', 'done': true},
      {'title': 'Diserahkan ke Kurir', 'time': '29 Sep, 14:00 WIB', 'done': order.status != 'Order Confirmed'},
      {'title': 'Dalam Perjalanan Menuju Hub', 'time': '29 Sep, 16:45 WIB', 'done': order.status == 'In Transit' || order.status == 'Delivered'},
      {'title': 'Kurir Mengantar ke Alamat Tujuan', 'time': 'Estimasi Besok', 'done': order.status == 'Delivered'},
      {'title': 'Pesanan Diterima', 'time': 'Estimasi 30 Sep', 'done': order.status == 'Delivered'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Lacak Pengiriman',
          style: GoogleFonts.fraunces(fontWeight: FontWeight.bold, fontSize: 19),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
        children: [
          // Order Header Status Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurpleLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        order.status,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ),
                    Text(
                      order.id,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Estimasi Tiba: ${order.estimatedDelivery}',
                  style: GoogleFonts.fraunces(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kurir: ${order.courier}',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Courier & Tracking Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryPurpleLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.local_shipping_rounded, color: AppColors.primaryPurple, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nomor Resi Pengiriman',
                        style: GoogleFonts.inter(fontSize: 11, color: AppColors.secondaryText),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        order.trackingNumber,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Nomor resi berhasil disalin!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Text(
                    'Salin',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Delivery Steps Timeline
          Text(
            'Perjalanan Paket',
            style: GoogleFonts.fraunces(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: List.generate(steps.length, (index) {
                final step = steps[index];
                final isDone = step['done'] as bool;
                final isLast = index == steps.length - 1;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: isDone ? AppColors.primaryPurple : AppColors.softSurface,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDone ? AppColors.primaryPurple : AppColors.border,
                              width: 2,
                            ),
                          ),
                          child: isDone
                              ? const Icon(Icons.check, size: 14, color: Colors.white)
                              : null,
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 38,
                            color: isDone ? AppColors.primaryPurple : AppColors.border,
                          ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step['title'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: isDone ? FontWeight.w700 : FontWeight.w500,
                                color: isDone ? AppColors.primaryText : AppColors.secondaryText,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              step['time'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.tertiaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),

          const SizedBox(height: 20),

          // Contact Seller Button
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Menghubungkan ke ${order.seller}...'),
                ),
              );
            },
            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
            label: Text('Hubungi Penjual (${order.seller})'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {
              appState.setTabIndex(0);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: AppColors.primaryPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(
              'Kembali ke Beranda',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
