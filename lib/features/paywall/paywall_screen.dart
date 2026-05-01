import 'package:flutter/material.dart';
import '../../core/services/purchase_service.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Logo / İkon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF82),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.self_improvement, size: 48, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Nefes Premium',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'İslami mindfulness yolculuğunun tamamına erişin',
                style: TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Özellikler
              _FeatureRow(icon: Icons.auto_awesome, text: 'Sınırsız AI destekli zikir & dua seansları'),
              _FeatureRow(icon: Icons.headphones, text: '200+ rehberli meditasyon (Türkçe & Arapça)'),
              _FeatureRow(icon: Icons.bar_chart, text: 'Gelişmiş ruh hali takibi ve raporları'),
              _FeatureRow(icon: Icons.book, text: 'Kişiselleştirilmiş Kuran okuma planı'),
              _FeatureRow(icon: Icons.block, text: 'Reklamsız deneyim'),
              const Spacer(),
              // Abonelik seçenekleri
              _PricingCard(
                title: 'Aylık',
                price: PurchaseService.getMonthlyPrice(),
                subtitle: 'Ayda bir ödeme',
                onTap: () => PurchaseService.buyMonthly(),
                isHighlighted: false,
              ),
              const SizedBox(height: 12),
              _PricingCard(
                title: 'Yıllık',
                price: PurchaseService.getYearlyPrice(),
                subtitle: 'Aylık sadece ₺33,33 • %58 indirim',
                onTap: () => PurchaseService.buyYearly(),
                isHighlighted: true,
              ),
              const SizedBox(height: 12),
              _PricingCard(
                title: 'Ömür Boyu',
                price: PurchaseService.getLifetimePrice(),
                subtitle: 'Tek seferlik ödeme • Sonsuza kadar',
                onTap: () => PurchaseService.buyLifetime(),
                isHighlighted: false,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => PurchaseService.restorePurchases(),
                child: const Text('Satın alımları geri yükle',
                    style: TextStyle(color: Colors.white54)),
              ),
              const SizedBox(height: 8),
              const Text(
                'İstediğiniz zaman iptal edebilirsiniz',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4CAF82), size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14))),
        ],
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  final String title;
  final String price;
  final String subtitle;
  final VoidCallback onTap;
  final bool isHighlighted;

  const _PricingCard({
    required this.title,
    required this.price,
    required this.subtitle,
    required this.onTap,
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isHighlighted ? const Color(0xFF4CAF82) : const Color(0xFF1E2D3D),
          borderRadius: BorderRadius.circular(16),
          border: isHighlighted
              ? null
              : Border.all(color: Colors.white24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                      color: isHighlighted ? Colors.white : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                Text(subtitle,
                    style: TextStyle(
                      color: isHighlighted ? Colors.white70 : Colors.white54,
                      fontSize: 12,
                    )),
              ],
            ),
            Text(price,
                style: TextStyle(
                  color: isHighlighted ? Colors.white : const Color(0xFF4CAF82),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
          ],
        ),
      ),
    );
  }
}