import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/neubrutalism_theme.dart';
import '../../../core/utils/health_data_store.dart';
import '../../../data/models/health_log.dart';
import '../../widgets/common/neu_card.dart';
import '../../widgets/common/neu_button.dart';

class HistoryPage extends StatefulWidget {
  final VoidCallback onAddLog;

  const HistoryPage({super.key, required this.onAddLog});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  LogType? _filterType; // null = show all

  @override
  Widget build(BuildContext context) {
    final logs = HealthDataStore.logs.where((l) {
      if (_filterType == null) return true;
      return l.primaryType == _filterType;
    }).toList();

    // Group by date
    final Map<String, List<HealthLog>> grouped = {};
    for (final log in logs) {
      final key = _dateKey(log.timestamp);
      grouped.putIfAbsent(key, () => []).add(log);
    }
    final dateKeys = grouped.keys.toList();

    return Scaffold(
      backgroundColor: NeuColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterRow(),
            Expanded(
              child: logs.isEmpty
                  ? _buildEmpty()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                      itemCount: dateKeys.length,
                      itemBuilder: (_, i) {
                        final key = dateKeys[i];
                        final dayLogs = grouped[key]!;
                        return _buildDayGroup(key, dayLogs);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Header ───────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: const BoxDecoration(
        color: NeuColors.mint,
        border: Border(
          bottom: BorderSide(color: NeuColors.black, width: NeuDimens.borderWidth),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'HISTORY',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: NeuColors.black,
            ),
          ),
          NeuButton(
            label: '+ ADD',
            color: NeuColors.black,
            textColor: NeuColors.mint,
            fontSize: 14,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            onPressed: widget.onAddLog,
          ),
        ],
      ),
    );
  }

  // ─── Filter Row ───────────────────────────────
  Widget _buildFilterRow() {
    return Container(
      height: 56,
      decoration: const BoxDecoration(
        color: NeuColors.white,
        border: Border(
          bottom: BorderSide(color: NeuColors.black, width: NeuDimens.borderWidth),
        ),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _FilterChip(
            label: 'ALL',
            isActive: _filterType == null,
            color: NeuColors.yellow,
            onTap: () => setState(() => _filterType = null),
          ),
          const SizedBox(width: 8),
          ...LogType.values.map((t) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _FilterChip(
                  label: '${t.emoji} ${t.label.toUpperCase()}',
                  isActive: _filterType == t,
                  color: t.color,
                  onTap: () => setState(() => _filterType = t),
                ),
              )),
        ],
      ),
    );
  }

  // ─── Day Group ────────────────────────────────
  Widget _buildDayGroup(String dateKey, List<HealthLog> logs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDateHeader(dateKey),
        const SizedBox(height: 10),
        ...logs.map((log) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _HistoryLogCard(log: log),
            )),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildDateHeader(String dateKey) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: const BoxDecoration(
        color: NeuColors.black,
      ),
      child: Text(
        dateKey,
        style: GoogleFonts.spaceGrotesk(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: NeuColors.yellow,
          letterSpacing: 2,
        ),
      ),
    );
  }

  // ─── Empty State ──────────────────────────────
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NeuCard(
            color: NeuColors.yellow,
            padding: const EdgeInsets.all(28),
            child: Text('📋', style: const TextStyle(fontSize: 52)),
          ),
          const SizedBox(height: 24),
          Text(
            'NO LOGS YET!',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: NeuColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + ADD to start logging.',
            style: neuText(size: 14, weight: FontWeight.w600),
          ),
          const SizedBox(height: 24),
          NeuButton(
            label: '+ ADD LOG',
            color: NeuColors.pink,
            fontSize: 16,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            onPressed: widget.onAddLog,
          ),
        ],
      ),
    );
  }

  String _dateKey(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) return 'TODAY — ${DateFormat('MMM d').format(dt).toUpperCase()}';
    if (diff == 1) return 'YESTERDAY — ${DateFormat('MMM d').format(dt).toUpperCase()}';
    return DateFormat('EEEE, MMM d').format(dt).toUpperCase();
  }
}

// ─────────────────────────────────────────────
// History Log Card (Stateless)
// ─────────────────────────────────────────────
class _HistoryLogCard extends StatelessWidget {
  final HealthLog log;

  const _HistoryLogCard({required this.log});

  @override
  Widget build(BuildContext context) {
    return NeuCard(
      color: log.primaryType.color,
      shadowX: 5,
      shadowY: 5,
      child: Row(
        children: [
          // Left: emoji + label band
          Container(
            width: 60,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: const BoxDecoration(
              color: NeuColors.black,
              border: Border(
                right: BorderSide(color: NeuColors.black, width: NeuDimens.borderWidth),
              ),
            ),
            child: Column(
              children: [
                Text(log.primaryType.emoji, style: const TextStyle(fontSize: 22)),
              ],
            ),
          ),
          // Center: metric info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    log.primaryType.label.toUpperCase(),
                    style: neuText(size: 11, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        log.formattedValue,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: NeuColors.black,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        log.primaryType.unit.toUpperCase(),
                        style: neuText(size: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Right: time
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: NeuColors.black, width: NeuDimens.borderWidth),
              ),
            ),
            child: Text(
              DateFormat('HH:mm').format(log.timestamp),
              style: neuText(size: 13, letterSpacing: 1),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Filter Chip (Stateless)
// ─────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? NeuColors.black : color,
          border: Border.all(color: NeuColors.black, width: 3),
          boxShadow: isActive
              ? []
              : [const BoxShadow(color: NeuColors.black, offset: Offset(3, 3))],
        ),
        child: Text(
          label,
          style: neuText(
            size: 11,
            letterSpacing: 1,
            color: isActive ? color : NeuColors.black,
          ),
        ),
      ),
    );
  }
}
