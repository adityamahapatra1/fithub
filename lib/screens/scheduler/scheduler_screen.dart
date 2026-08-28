import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/workout_provider.dart';
import '../../models/timetable_block_model.dart';
import '../../widgets/timetable_block_tile.dart';
import '../../widgets/workout_slot_card.dart';
import '../../models/exercise_model.dart';

class SchedulerScreen extends StatefulWidget {
  const SchedulerScreen({super.key});
  @override
  State<SchedulerScreen> createState() => _SchedulerScreenState();
}

class _SchedulerScreenState extends State<SchedulerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedDay = 'Mon';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkoutProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Scheduler'),
        bottom: TabBar(controller: _tabController, tabs: const [Tab(text: 'My Timetable'), Tab(text: 'My Plan')]),
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(onPressed: () => _showAddBlockSheet(context), child: const Icon(Icons.add))
          : null,
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTimetableTab(provider),
          _buildPlanTab(provider),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: WorkoutProvider.weekDays.map((day) {
          final selected = day == _selectedDay;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(day),
              selected: selected,
              onSelected: (_) => setState(() => _selectedDay = day),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimetableTab(WorkoutProvider provider) {
    final dayBlocks = provider.blocksForDay(_selectedDay);
    return Column(
      children: [
        const SizedBox(height: 12),
        _buildDaySelector(),
        const SizedBox(height: 12),
        Expanded(
          child: dayBlocks.isEmpty
              ? const Center(child: Text('No classes/food/study blocks added for this day yet.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white38)))
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: dayBlocks.length,
            itemBuilder: (context, i) => TimetableBlockTile(
              block: dayBlocks[i],
              onDelete: () => provider.removeBlock(dayBlocks[i].id),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanTab(WorkoutProvider provider) {
    final split = provider.daySplit[_selectedDay] ?? SplitType.rest;
    final plans = provider.planForDay(_selectedDay);

    return Column(
      children: [
        const SizedBox(height: 12),
        _buildDaySelector(),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(split.label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              DropdownButton<SplitType>(
                value: split,
                dropdownColor: const Color(0xFF141A21),
                items: SplitType.values.map((s) => DropdownMenuItem(value: s, child: Text(s.label))).toList(),
                onChanged: (v) {
                  if (v != null) provider.setSplitForDay(_selectedDay, v);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: plans.isEmpty
              ? const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('No free gaps found — add your timetable first, or it\'s a rest day.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white38))))
              : ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: plans.length,
            itemBuilder: (context, i) => WorkoutSlotCard(plan: plans[i]),
          ),
        ),
      ],
    );
  }

  void _showAddBlockSheet(BuildContext context) {
    final provider = context.read<WorkoutProvider>();
    String day = _selectedDay;
    BlockType type = BlockType.classSession;
    TimeOfDay start = const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay end = const TimeOfDay(hour: 10, minute: 0);

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141A21),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Add Timetable Block', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: day,
                    decoration: const InputDecoration(labelText: 'Day'),
                    dropdownColor: const Color(0xFF141A21),
                    items: WorkoutProvider.weekDays.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                    onChanged: (v) => setSheetState(() => day = v!),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<BlockType>(
                    initialValue: type,
                    decoration: const InputDecoration(labelText: 'Type'),
                    dropdownColor: const Color(0xFF141A21),
                    items: BlockType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.label))).toList(),
                    onChanged: (v) => setSheetState(() => type = v!),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Start: ${start.format(context)}'),
                          onTap: () async {
                            final picked = await showTimePicker(context: context, initialTime: start);
                            if (picked != null) setSheetState(() => start = picked);
                          },
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('End: ${end.format(context)}'),
                          onTap: () async {
                            final picked = await showTimePicker(context: context, initialTime: end);
                            if (picked != null) setSheetState(() => end = picked);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final startMin = start.hour * 60 + start.minute;
                        final endMin = end.hour * 60 + end.minute;
                        if (endMin > startMin) {
                          provider.addBlock(day: day, type: type, startMinutes: startMin, endMinutes: endMin);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Add Block'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}