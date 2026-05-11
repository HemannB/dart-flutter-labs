import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:questlog/core/theme.dart';
import 'package:questlog/models/goal.dart';
import 'package:questlog/models/user_profile.dart';
import 'package:questlog/providers/goals_provider.dart';
import 'package:questlog/services/hive_service.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  // Dados do formulário
  final _nameController = TextEditingController();
  String _sex = 'male';
  double _weight = 70;
  double _height = 170;
  int _age = 25;
  TimeOfDay _wakeUpTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _sleepTime = const TimeOfDay(hour: 22, minute: 0);

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    final name = _nameController.text.trim().isEmpty
        ? 'Adventurer'
        : _nameController.text.trim();

    final user = UserProfile(
      name: name,
      sex: _sex,
      weightKg: _weight,
      heightCm: _height,
      age: _age,
      wakeUpTime:
      '${_wakeUpTime.hour.toString().padLeft(2, '0')}:${_wakeUpTime.minute.toString().padLeft(2, '0')}',
      sleepTime:
      '${_sleepTime.hour.toString().padLeft(2, '0')}:${_sleepTime.minute.toString().padLeft(2, '0')}',
    );

    await ref.read(userProvider.notifier).createUser(user);

    await HiveService.saveGoal(
        Goal(id: _uuid.v4(), type: GoalType.water));
    await HiveService.saveGoal(
        Goal(id: _uuid.v4(), type: GoalType.wakeup,
            targetWakeUpTime: user.wakeUpTime));
    await HiveService.saveGoal(
        Goal(id: _uuid.v4(), type: GoalType.reading));

    await HiveService.setOnboardingDone();
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Barra de progresso
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                children: List.generate(4, (i) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: i <= _currentPage
                            ? AppTheme.primary
                            : Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Páginas
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (p) => setState(() => _currentPage = p),
                children: [
                  _WelcomePage(onNext: _nextPage),
                  _ProfilePage(
                    nameController: _nameController,
                    sex: _sex,
                    onSexChanged: (v) => setState(() => _sex = v),
                    weight: _weight,
                    onWeightChanged: (v) => setState(() => _weight = v),
                    height: _height,
                    onHeightChanged: (v) => setState(() => _height = v),
                    age: _age,
                    onAgeChanged: (v) => setState(() => _age = v),
                    onNext: _nextPage,
                  ),
                  _SchedulePage(
                    wakeUpTime: _wakeUpTime,
                    sleepTime: _sleepTime,
                    onWakeChanged: (t) => setState(() => _wakeUpTime = t),
                    onSleepChanged: (t) => setState(() => _sleepTime = t),
                    onNext: _nextPage,
                  ),
                  _DonePage(
                    sex: _sex,
                    weight: _weight,
                    wakeUpTime: _wakeUpTime,
                    onFinish: _finish,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Página 1: Welcome ─────────────────────────────────────────────────────

class _WelcomePage extends StatelessWidget {
  final VoidCallback onNext;
  const _WelcomePage({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Text('⚔️', style: TextStyle(fontSize: 80))
              .animate()
              .scale(duration: 600.ms, curve: Curves.elasticOut),
          const SizedBox(height: 32),
          Text(
            'QuestLog',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 48,
              letterSpacing: -2,
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),
          const SizedBox(height: 12),
          Text(
            'Turn your habits into\nan epic journey.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.5),
              height: 1.6,
            ),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 16),
          Text(
            '"Not all those who wander are unfocused."',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: AppTheme.primary.withValues(alpha: 0.8),
            ),
          ).animate().fadeIn(delay: 600.ms),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              child: const Text('Begin the journey'),
            ),
          ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.5),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ── Página 2: Profile ─────────────────────────────────────────────────────

class _ProfilePage extends StatelessWidget {
  final TextEditingController nameController;
  final String sex;
  final ValueChanged<String> onSexChanged;
  final double weight;
  final ValueChanged<double> onWeightChanged;
  final double height;
  final ValueChanged<double> onHeightChanged;
  final int age;
  final ValueChanged<int> onAgeChanged;
  final VoidCallback onNext;

  const _ProfilePage({
    required this.nameController,
    required this.sex,
    required this.onSexChanged,
    required this.weight,
    required this.onWeightChanged,
    required this.height,
    required this.onHeightChanged,
    required this.age,
    required this.onAgeChanged,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your profile',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 6),
          Text('We use this to calculate your daily water goal.',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 32),

          // Nome
          TextField(
            controller: nameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Your name',
              hintText: 'What should we call you?',
            ),
          ),
          const SizedBox(height: 24),

          // Sexo
          Text('Sex', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              _SexButton(
                label: 'Male',
                icon: '⚔️',
                selected: sex == 'male',
                onTap: () => onSexChanged('male'),
              ),
              const SizedBox(width: 12),
              _SexButton(
                label: 'Female',
                icon: '🌸',
                selected: sex == 'female',
                onTap: () => onSexChanged('female'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Sliders
          _SliderField(
            label: 'Weight',
            value: weight,
            unit: 'kg',
            min: 40,
            max: 150,
            onChanged: onWeightChanged,
          ),
          const SizedBox(height: 16),
          _SliderField(
            label: 'Height',
            value: height,
            unit: 'cm',
            min: 140,
            max: 220,
            onChanged: onHeightChanged,
          ),
          const SizedBox(height: 16),
          _SliderField(
            label: 'Age',
            value: age.toDouble(),
            unit: 'years',
            min: 10,
            max: 80,
            onChanged: (v) => onAgeChanged(v.round()),
            divisions: 70,
          ),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: onNext, child: const Text('Continue')),
          ),
        ],
      ),
    );
  }
}

class _SexButton extends StatelessWidget {
  final String label;
  final String icon;
  final bool selected;
  final VoidCallback onTap;

  const _SexButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? AppTheme.primary
                  : Colors.white.withValues(alpha: 0.1),
              width: selected ? 1.5 : 0.5,
            ),
            color: selected
                ? AppTheme.primary.withValues(alpha: 0.15)
                : AppTheme.surfaceCard,
          ),
          child: Column(
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: selected ? AppTheme.primary : Colors.white54,
                  fontWeight:
                  selected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliderField extends StatelessWidget {
  final String label;
  final double value;
  final String unit;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final int? divisions;

  const _SliderField({
    required this.label,
    required this.value,
    required this.unit,
    required this.min,
    required this.max,
    required this.onChanged,
    this.divisions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: Theme.of(context).textTheme.bodyMedium),
            Text(
              '${value.round()} $unit',
              style: const TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions ?? (max - min).round(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// ── Página 3: Schedule ────────────────────────────────────────────────────

class _SchedulePage extends StatelessWidget {
  final TimeOfDay wakeUpTime;
  final TimeOfDay sleepTime;
  final ValueChanged<TimeOfDay> onWakeChanged;
  final ValueChanged<TimeOfDay> onSleepChanged;
  final VoidCallback onNext;

  const _SchedulePage({
    required this.wakeUpTime,
    required this.sleepTime,
    required this.onWakeChanged,
    required this.onSleepChanged,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your schedule',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 6),
          Text(
            'We use this to spread water reminders throughout your day.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 40),
          _TimePicker(
            label: '⏰  Wake up',
            time: wakeUpTime,
            color: AppTheme.wakeUp,
            onChanged: onWakeChanged,
          ),
          const SizedBox(height: 16),
          _TimePicker(
            label: '🌙  Sleep',
            time: sleepTime,
            color: AppTheme.water,
            onChanged: onSleepChanged,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: onNext, child: const Text('Continue')),
          ),
        ],
      ),
    );
  }
}

class _TimePicker extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final Color color;
  final ValueChanged<TimeOfDay> onChanged;

  const _TimePicker({
    required this.label,
    required this.time,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final formatted =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return GestureDetector(
      onTap: () async {
        final picked =
        await showTimePicker(context: context, initialTime: time);
        if (picked != null) onChanged(picked);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppTheme.surfaceCard,
          border: Border.all(
              color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16)),
            ),
            Text(
              formatted,
              style: TextStyle(
                color: color,
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: -1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Página 4: Done ────────────────────────────────────────────────────────

class _DonePage extends StatelessWidget {
  final String sex;
  final double weight;
  final TimeOfDay wakeUpTime;
  final VoidCallback onFinish;

  const _DonePage({
    required this.sex,
    required this.weight,
    required this.wakeUpTime,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    final multiplier = sex == 'male' ? 35.0 : 31.0;
    final goalMl = (weight * multiplier).round();

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Text('🎉', style: TextStyle(fontSize: 72))
              .animate()
              .scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: 24),
          Text(
            "You're all set!",
            style: Theme.of(context).textTheme.headlineMedium,
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 32),

          // Preview meta de água
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppTheme.water.withValues(alpha: 0.1),
              border: Border.all(
                  color: AppTheme.water.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                const Text('💧',
                    style: TextStyle(fontSize: 36)),
                const SizedBox(height: 8),
                Text(
                  '$goalMl ml / day',
                  style: TextStyle(
                    color: AppTheme.water,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your daily water goal',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall,
                ),
              ],
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),

          const SizedBox(height: 16),
          Text(
            'Wake up at ${wakeUpTime.hour.toString().padLeft(2, '0')}:${wakeUpTime.minute.toString().padLeft(2, '0')} ⏰',
            style: Theme.of(context).textTheme.bodyMedium,
          ).animate().fadeIn(delay: 500.ms),

          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onFinish,
              child: const Text('Start my journey ⚔️'),
            ),
          ).animate().fadeIn(delay: 600.ms),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}