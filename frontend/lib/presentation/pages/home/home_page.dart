import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/neubrutalism_theme.dart';
import '../../../core/utils/health_data_store.dart';
import '../../../data/models/health_log.dart';
import '../../widgets/common/neu_card.dart';
import '../../widgets/common/neu_button.dart';
import '../profile/profile_page.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onAddLog;

  const HomePage({super.key, required this.onAddLog});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final greeting = now.hour < 12
        ? 'GOOD\nMORNING!'
        : now.hour < 17
            ? 'GOOD\nAFTERNOON!'
            : 'GOOD\nEVENING!';

    return Scaffold(
      backgroundColor: NeuColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(greeting),
              const SizedBox(height: 20),
              _buildHeroCard(),
              const SizedBox(height: 20),
              _buildSectionTitle('TODAY\'S METRICS'),
              const SizedBox(height: 12),
              _buildMetricsGrid(),
              const SizedBox(height: 20),
              _buildSectionTitle('WEEKLY GOAL'),
              const SizedBox(height: 12),
              _buildWeeklyGoalCard(),
              const SizedBox(height: 20),
              _buildLogButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Header ───────────────────────────────────
  Widget _buildHeader(String greeting) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HEALTH\nSYNC',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 3,
                  color: NeuColors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                greeting,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: NeuColors.black,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfilePage()),
          ),
          child: NeuCard(
            color: NeuColors.pink,
            shadowX: 4,
            shadowY: 4,
            padding: const EdgeInsets.all(14),
            child: const Icon(Icons.person_rounded, size: 32, color: NeuColors.black),
          ),
        ),
      ],
    );
  }

  // ─── Hero Summary Card ────────────────────────
  Widget _buildHeroCard() {
    final weight = HealthDataStore.latestValue(LogType.weight);
    return NeuCard(
      color: NeuColors.pink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: const BoxDecoration(
              color: NeuColors.black,
              border: Border(
                bottom: BorderSide(color: NeuColors.black, width: NeuDimens.borderWidth),
              ),
            ),
            child: Text(
              '⚖️  WEIGHT — LATEST',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: NeuColors.yellow,
                letterSpacing: 2,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  weight.toStringAsFixed(1),
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 84,
                    fontWeight: FontWeight.w900,
                    color: NeuColors.black,
                    height: 0.9,
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Text(
                    'KG',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: NeuColors.black,
                    ),
                  ),
                ),
                const Spacer(),
                _buildStatusBadge('LOGGED', NeuColors.mint),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildStatusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: NeuColors.black, width: 3),
      ),
      child: Text(
        label,
        style: neuText(size: 12, letterSpacing: 1),
      ),
    );
  }

  // ─── Metrics Grid ─────────────────────────────
  Widget _buildMetricsGrid() {
    final metrics = [
      _MetricData(
        type: LogType.water,
        color: NeuColors.yellow,
      ),
      _MetricData(
        type: LogType.sleep,
        color: NeuColors.mint,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.1,
      ),
      itemCount: metrics.length,
      itemBuilder: (_, i) => _MetricCard(data: metrics[i]),
    );
  }

  // ─── Weekly Goal ──────────────────────────────
  Widget _buildWeeklyGoalCard() {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    const progress = [0.9, 0.7, 1.0, 0.5, 0.8, 0.3, 0.0];

    return NeuCard(
      color: NeuColors.mint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: const BoxDecoration(
              color: NeuColors.black,
              border: Border(
                bottom: BorderSide(color: NeuColors.black, width: NeuDimens.borderWidth),
              ),
            ),
            child: Text(
              '💧  WATER — THIS WEEK',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: NeuColors.mint,
                letterSpacing: 2,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (i) {
                final isToday = i == 4;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 32,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 60 * progress[i],
                          width: 32,
                          decoration: BoxDecoration(
                            color: isToday ? NeuColors.pink : NeuColors.black,
                            border: Border.all(color: NeuColors.black, width: 2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      days[i],
                      style: neuText(
                        size: 12,
                        color: isToday ? NeuColors.pink : NeuColors.black,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Log Button ───────────────────────────────
  Widget _buildLogButton() {
    return SizedBox(
      width: double.infinity,
      child: NeuButton(
        label: '+ LOG NOW',
        color: NeuColors.yellow,
        fontSize: 18,
        padding: const EdgeInsets.symmetric(vertical: 18),
        onPressed: widget.onAddLog,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.spaceGrotesk(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        letterSpacing: 2.5,
        color: NeuColors.black,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Metric Card (Stateless)
// ─────────────────────────────────────────────
class _MetricData {
  final LogType type;
  final Color color;
  const _MetricData({required this.type, required this.color});
}

class _MetricCard extends StatelessWidget {
  final _MetricData data;

  const _MetricCard({required this.data});

  @override
  Widget build(BuildContext context) {
    // Use today's accumulated total for water & sleep
    final double value;
    if (data.type == LogType.water) {
      value = HealthDataStore.todayTotalWater().toDouble();
    } else if (data.type == LogType.sleep) {
      value = HealthDataStore.todayTotalSleep();
    } else {
      value = HealthDataStore.latestValue(data.type);
    }

    final display = value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);

    return NeuCard(
      color: data.color,
      shadowX: 6,
      shadowY: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: NeuColors.black,
              border: Border(
                bottom: BorderSide(color: NeuColors.black, width: NeuDimens.borderWidth),
              ),
            ),
            child: Row(
              children: [
                Text(
                  data.type.emoji,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 6),
                Text(
                  'TODAY',
                  style: neuText(size: 9, letterSpacing: 1.5, color: NeuColors.yellow),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      display,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: NeuColors.black,
                        height: 0.95,
                      ),
                    ),
                  ),
                  Text(
                    data.type.unit.toUpperCase(),
                    style: neuText(size: 11, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data.type.label.toUpperCase(),
                    style: neuText(size: 10, letterSpacing: 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
