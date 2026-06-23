import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/services/offline_storage_service.dart';
import '../../../core/services/notification_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _meditationReminder = true;
  bool _prayerReminder = false;
  String _reminderTime = '08:00';

  @override
  void initState() {
    super.initState();
    _meditationReminder = OfflineStorageService.getSetting(
            'meditation_reminder',
            defaultValue: true) ==
        true;
    _prayerReminder = OfflineStorageService.getSetting('prayer_reminder',
            defaultValue: false) ==
        true;
    _reminderTime =
        OfflineStorageService.getSetting('reminder_time', defaultValue: '08:00')
            as String;
  }

  Future<void> _setMeditationReminder(bool v) async {
    await OfflineStorageService.saveSetting('meditation_reminder', v);
    setState(() => _meditationReminder = v);
    if (v) {
      final parts = _reminderTime.split(':');
      await NotificationService.scheduleDailyMeditationReminder(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    } else {
      await NotificationService.cancelAll();
    }
  }

  Future<void> _pickReminderTime() async {
    final parts = _reminderTime.split(':');
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      ),
    );
    if (time != null && mounted) {
      final ts =
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      await OfflineStorageService.saveSetting('reminder_time', ts);
      setState(() => _reminderTime = ts);
      if (_meditationReminder) {
        await NotificationService.scheduleDailyMeditationReminder(
          hour: time.hour,
          minute: time.minute,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Görünüm ────────────────────────────────────────────
          _buildSection('Görünüm', [
            _buildToggleTile(
              icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              iconColor: isDark ? AppColors.accent : AppColors.primary,
              title: 'Karanlık Mod',
              subtitle: isDark ? 'Aktif' : 'Kapalı',
              value: isDark,
              onChanged: (_) => ref.read(themeProvider.notifier).toggle(),
            ),
          ]),
          const SizedBox(height: 16),

          // ── Bildirimler ────────────────────────────────────────
          _buildSection('Bildirimler', [
            _buildToggleTile(
              icon: Icons.self_improvement,
              iconColor: AppColors.primary,
              title: 'Meditasyon Hatırlatıcı',
              subtitle: 'Günlük meditasyon hatırlatması',
              value: _meditationReminder,
              onChanged: _setMeditationReminder,
            ),
            _buildDivider(),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.access_time_rounded,
                    color: AppColors.secondary, size: 20),
              ),
              title: const Text('Hatırlatma Saati',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(_reminderTime),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: _pickReminderTime,
            ),
            _buildDivider(),
            _buildToggleTile(
              icon: Icons.mosque_rounded,
              iconColor: AppColors.accent,
              title: 'Namaz Vakti Bildirimi',
              subtitle: 'Yakında geliyor',
              value: _prayerReminder,
              onChanged: (v) async {
                await OfflineStorageService.saveSetting('prayer_reminder', v);
                setState(() => _prayerReminder = v);
              },
            ),
          ]),
          const SizedBox(height: 16),

          // ── Premium ────────────────────────────────────────────
          _buildSection('Premium', [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Text('⭐', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Premium\'a Yükselt',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Reklamsız + tüm içerikler',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Yükselt',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 16),

          // ── Hakkında ───────────────────────────────────────────
          _buildSection('Hakkında', [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.info_outline,
                    color: AppColors.primary, size: 20),
              ),
              title: const Text('Versiyon',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('1.0.0'),
            ),
            _buildDivider(),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.favorite, color: Colors.red, size: 20),
              ),
              title: const Text('Bir Tebessüm Bin Mutluluk Derneği',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text(
                  'Bu uygulama derneğimiz tarafından geliştirilmiştir'),
            ),
          ]),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDivider() => Divider(
        height: 1,
        indent: 48,
        color: Colors.grey.shade100,
      );
}
