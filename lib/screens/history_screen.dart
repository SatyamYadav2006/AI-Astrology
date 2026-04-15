import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/app_state_provider.dart';
import '../widgets/holographic_card.dart';
import '../widgets/celestial_background.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("CELESTIAL ARCHIVE", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 4.0, fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: () {
              Provider.of<AppStateProvider>(context, listen: false).clearHistory();
            },
          )
        ],
      ),
      body: CelestialBackground(
        child: Consumer<AppStateProvider>(
          builder: (context, appState, child) {
            final history = appState.horoscopeHistory;
            if (history.isEmpty) {
              return const Center(child: Text("No records aligned with the stars."));
            }

            return ListView.builder(
              padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + kToolbarHeight + 16, 16, 16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final h = history[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: HolographicCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(h.date.toString().substring(0, 10), style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Theme.of(context).colorScheme.tertiary, letterSpacing: 2.0)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                 decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                                 child: Text(h.mood.toUpperCase(), style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, color: Theme.of(context).colorScheme.secondary)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(h.dailySummary, style: const TextStyle(height: 1.6, fontSize: 15)),
                      ],
                    ),
                  ).animate().fade(delay: (100 * index).ms).slideX(begin: 0.05),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
