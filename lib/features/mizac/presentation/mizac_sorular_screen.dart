import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/mizac_provider.dart';
import '../../../core/providers/profile_provider.dart';
import '../domain/mizac_questions.dart';
import '../domain/mizac_calculator.dart';
import '../domain/mizac_model.dart';

class MizacSorularScreen extends ConsumerStatefulWidget {
  const MizacSorularScreen({super.key});

  @override
  ConsumerState<MizacSorularScreen> createState() => _MizacSorularScreenState();
}

class _MizacSorularScreenState extends ConsumerState<MizacSorularScreen> {
  int _currentQ = 0;
  final List<int> _answers = [];
  bool _finished = false;
  MizacType? _result;

  void _answer(int idx) {
    setState(() {
      _answers.add(idx);
      if (_answers.length < mizacQuestions.length) {
        _currentQ++;
      } else {
        _result = MizacCalculator.fromQuestionnaireAnswers(_answers);
        _finished = true;
      }
    });
  }

  Future<void> _save() async {
    if (_result == null) return;
    await ref.read(mizacProvider.notifier).setMizac(_result!);
    await ref.read(profileProvider.notifier).updateMizac(_result!.name);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mizaç Testi'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: _finished ? _buildResult() : _buildQuestion(),
    );
  }

  Widget _buildQuestion() {
    final q = mizacQuestions[_currentQ];
    final progress = (_currentQ + 1) / mizacQuestions.length;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Soru ${_currentQ + 1}/${mizacQuestions.length}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.primary.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            q['question'] as String,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              itemCount: (q['answers'] as List).length,
              itemBuilder: (context, index) {
                final answer = (q['answers'] as List)[index] as String;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: AppColors.primary.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: () => _answer(index),
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.primary, width: 2),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + index),
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                answer,
                                style:
                                    const TextStyle(fontSize: 15, height: 1.3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    final mizac = _result!;
    final color = mizac.color;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.8), color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Text(mizac.emoji, style: const TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                const Text(
                  'Mizacın:',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  mizac.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${mizac.element} • ${mizac.season}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    mizac.description,
                    style: const TextStyle(
                        color: Colors.white, height: 1.5, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                'Mizacımı Kaydet',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              setState(() {
                _answers.clear();
                _currentQ = 0;
                _finished = false;
                _result = null;
              });
            },
            child: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }
}
