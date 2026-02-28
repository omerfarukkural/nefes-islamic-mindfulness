import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _meditationReminder = true;
  bool _prayerReminder = true;
  bool _darkMode = false;
  String _reminderTime = '08:00';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Bildirimler'),
          SwitchListTile(
            title: const Text('Meditasyon Hatırlatıcı'),
            subtitle: const Text('Günlük meditasyon hatırlatması'),
            value: _meditationReminder,
            onChanged: (v) => setState(() => _meditationReminder = v),
            activeColor: AppColors.primary,
          ),
          SwitchListTile(
            title: const Text('Namaz Vakti Bildirimi'),
            subtitle: const Text('Namaz vakti geldiğinde bildirim'),
            value: _prayerReminder,
            onChanged: (v) => setState(() => _prayerReminder = v),
            activeColor: AppColors.primary,
          ),
          ListTile(
            title: const Text('Hatırlatma Saati'),
            subtitle: Text(_reminderTime),
            trailing: const Icon(Icons.access_time),
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 8, minute: 0),
              );
              if (time != null) {
                setState(() => _reminderTime =
                    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}');
              }
            },
          ),
          const Divider(),
          _buildSectionHeader('Görünüm'),
          SwitchListTile(
            title: const Text('Karanlık Mod'),
            subtitle: const Text('Gece modu için karanlık tema'),
            value: _darkMode,
            onChanged: (v) => setState(() => _darkMode = v),
            activeColor: AppColors.primary,
          ),
          const Divider(),
          _buildSectionHeader('Premium'),
          ListTile(
            leading: Icon(Icons.star, color: AppColors.accent),
            title: const Text('Premium\'a Yükselt'),
            subtitle: const Text('Reklamsız deneyim + tüm içerikler'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Show premium purchase dialog
            },
          ),
          const Divider(),
          _buildSectionHeader('Hakkında'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Versiyon'),
            subtitle: Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: const Text('Bir Tebessüm Bin Mutluluk Derneği'),
            subtitle: const Text('Bu uygulama derneğimiz tarafından geliştirilmiştir'),
            onTap: () {
              // TODO: Open website
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          )),
    );
  }
}
