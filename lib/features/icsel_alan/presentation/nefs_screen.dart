import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/nefs_data.dart';

class NefsScreen extends StatelessWidget {
  const NefsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nefs Mertebeleri')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: nefsMertebeleri.length,
        itemBuilder: (context, index) {
          final nefs = nefsMertebeleri[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildNefsCard(context, nefs),
          );
        },
      ),
    );
  }

  Widget _buildNefsCard(BuildContext context, NefsMertebesi nefs) {
    final color = Color(int.parse(nefs.color.replaceFirst('#', 'FF'), radix: 16));

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        backgroundColor: color.withOpacity(0.06),
        collapsedBackgroundColor: color.withOpacity(0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: color.withOpacity(0.3)),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: color.withOpacity(0.3)),
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(nefs.emoji, style: const TextStyle(fontSize: 22)),
          ),
        ),
        title: Text(
          nefs.name,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: color,
          ),
        ),
        subtitle: Text(
          nefs.arabicName,
          style: AppTheme.arabicTextStyle(fontSize: 15, color: color.withOpacity(0.8)),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDivider(color),
                const SizedBox(height: 12),
                Text(
                  nefs.description,
                  style: const TextStyle(height: 1.5, fontSize: 14),
                ),
                const SizedBox(height: 14),
                _buildInfoRow('📖 Ayet', nefs.quranVerse, '(${nefs.quranSource})'),
                const SizedBox(height: 10),
                _buildInfoRow('☪️ Esma', nefs.esma, ''),
                const SizedBox(height: 14),
                _buildSignsSection(context, nefs.signs, color),
                const SizedBox(height: 14),
                _buildPracticeCard(context, nefs.practice, color),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(Color color) {
    return Divider(color: color.withOpacity(0.3));
  }

  Widget _buildInfoRow(String label, String value, String suffix) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        Expanded(
          child: Text(
            suffix.isNotEmpty ? '$value $suffix' : value,
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
        ),
      ],
    );
  }

  Widget _buildSignsSection(BuildContext context, List<String> signs, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bu Mertebede İşaretler:',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: signs.map((s) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Text(
                s,
                style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPracticeCard(BuildContext context, String practice, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🌱 Pratik',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            practice,
            style: const TextStyle(fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }
}
