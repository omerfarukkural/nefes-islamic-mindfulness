import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:hijri/hijri_calendar.dart';
import '../../../core/theme/app_theme.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  PrayerTimes? _prayerTimes;
  String _cityName = 'İstanbul';
  String? _nextPrayerName;
  Duration? _timeUntilNext;

  late Coordinates _coordinates;
  late final CalculationParameters _params;

  static const _cities = <Map<String, dynamic>>[
    {'name': 'İstanbul', 'lat': 41.0082, 'lon': 28.9784},
    {'name': 'Ankara', 'lat': 39.9334, 'lon': 32.8597},
    {'name': 'İzmir', 'lat': 38.4237, 'lon': 27.1428},
    {'name': 'Bursa', 'lat': 40.1826, 'lon': 29.0665},
    {'name': 'Antalya', 'lat': 36.8969, 'lon': 30.7133},
    {'name': 'Konya', 'lat': 37.8746, 'lon': 32.4932},
  ];

  @override
  void initState() {
    super.initState();
    _params = CalculationMethod.turkey.getParameters()..madhab = Madhab.hanafi;
    _coordinates = Coordinates(41.0082, 28.9784);
    _calculate();
  }

  void _calculate() {
    final pt = PrayerTimes.today(_coordinates, _params);
    setState(() {
      _prayerTimes = pt;
      _calculateNext(pt);
    });
  }

  void _calculateNext(PrayerTimes pt) {
    final now = DateTime.now();
    final prayers = [
      ('İmsak', pt.fajr),
      ('Güneş', pt.sunrise),
      ('Öğle', pt.dhuhr),
      ('İkindi', pt.asr),
      ('Akşam', pt.maghrib),
      ('Yatsı', pt.isha),
    ];

    for (final p in prayers) {
      if (p.$2.isAfter(now)) {
        _nextPrayerName = p.$1;
        _timeUntilNext = p.$2.difference(now);
        return;
      }
    }
    // After isha — next day's fajr
    _nextPrayerName = 'İmsak';
    _timeUntilNext = null;
  }

  String _format(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    if (h > 0) return '$h sa $m dk';
    return '$m dk';
  }

  @override
  Widget build(BuildContext context) {
    final hijri = HijriCalendar.now();
    final monthNames = [
      'Muharrem',
      'Safer',
      'Rebiülevvel',
      'Rebiülahir',
      'Cemaziyelevvel',
      'Cemaziyelahir',
      'Recep',
      'Şaban',
      'Ramazan',
      'Şevval',
      'Zilkade',
      'Zilhicce',
    ];
    final hijriMonth = monthNames[(hijri.hMonth - 1).clamp(0, 11)];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Namaz Vakitleri'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: AppColors.headerGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on_rounded,
                          color: Colors.white70, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        _cityName,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${hijri.hDay} $hijriMonth ${hijri.hYear} H',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (_nextPrayerName != null && _timeUntilNext != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Sonraki: $_nextPrayerName',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDuration(_timeUntilNext!),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Prayer list
            if (_prayerTimes != null) ...[
              _buildPrayerTile('İmsak (Sabah)', _prayerTimes!.fajr,
                  Icons.brightness_3_rounded),
              _buildPrayerTile(
                  'Güneş', _prayerTimes!.sunrise, Icons.wb_sunny_rounded),
              _buildPrayerTile(
                  'Öğle', _prayerTimes!.dhuhr, Icons.light_mode_rounded),
              _buildPrayerTile(
                  'İkindi', _prayerTimes!.asr, Icons.wb_cloudy_rounded),
              _buildPrayerTile(
                  'Akşam', _prayerTimes!.maghrib, Icons.nights_stay_rounded),
              _buildPrayerTile(
                  'Yatsı', _prayerTimes!.isha, Icons.bedtime_rounded),
            ],
            const SizedBox(height: 16),
            _buildCitySelector(),
            const SizedBox(height: 8),
            Text(
              '* Vakitler Diyanet İşleri Başkanlığı metoduna göre hesaplanmıştır.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTile(String name, DateTime time, IconData icon) {
    final now = DateTime.now();
    final isNext = _nextPrayerName != null && name.startsWith(_nextPrayerName!);
    final isPast = time.isBefore(now);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        gradient: isNext ? AppColors.headerGradient : null,
        color: isNext ? null : Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(18),
        border: isNext
            ? null
            : Border.all(
                color: isPast
                    ? Colors.grey.shade200
                    : AppColors.primary.withOpacity(0.15),
              ),
        boxShadow: isNext
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isNext
                ? Colors.white.withOpacity(0.2)
                : AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isNext ? Colors.white : AppColors.primary,
            size: 22,
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: isNext
                ? Colors.white
                : isPast
                    ? Colors.grey.shade400
                    : null,
          ),
        ),
        trailing: Text(
          _format(time),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: isNext
                ? Colors.white
                : isPast
                    ? Colors.grey.shade400
                    : AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildCitySelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Şehir Seç',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _cities.map((city) {
              final selected = _cityName == city['name'];
              return ChoiceChip(
                label: Text(city['name'] as String),
                selected: selected,
                onSelected: (_) {
                  setState(() {
                    _cityName = city['name'] as String;
                    _coordinates = Coordinates(
                      city['lat'] as double,
                      city['lon'] as double,
                    );
                  });
                  _calculate();
                },
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : null,
                  fontWeight: FontWeight.w600,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
