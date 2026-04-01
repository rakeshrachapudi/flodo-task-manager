import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../screens/task_form_screen.dart';
import '../widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      context.read<TaskProvider>().updateSearch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task Manager',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TaskFormScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          children: [
            // Row(
            //   children: [
            //     Expanded(
            //       child: TextField(
            //         controller: _searchController,
            //         onChanged: _onSearchChanged,
            //         decoration: const InputDecoration(
            //           hintText: 'Search by title',
            //           prefixIcon: Icon(Icons.search),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(width: 12),
            //     SizedBox(
            //       width: 180,
            //       child: DropdownButtonFormField<String>(
            //         value: provider.statusFilter,
            //         items: const [
            //           DropdownMenuItem(value: 'All', child: Text('All')),
            //           DropdownMenuItem(value: 'To-Do', child: Text('To-Do')),
            //           DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
            //           DropdownMenuItem(value: 'Done', child: Text('Done')),
            //         ],
            //         onChanged: (value) {
            //           if (value != null) {
            //             context.read<TaskProvider>().updateStatusFilter(value);
            //           }
            //         },
            //         decoration: const InputDecoration(
            //           prefixIcon: Icon(Icons.filter_list_rounded),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: const InputDecoration(
                      hintText: 'Search by title',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: provider.statusFilter,
                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('All')),
                      DropdownMenuItem(value: 'To-Do', child: Text('To-Do')),
                      DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
                      DropdownMenuItem(value: 'Done', child: Text('Done')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        context.read<TaskProvider>().updateStatusFilter(value);
                      }
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.filter_list_rounded),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Expanded(
              child: provider.isFetching
                  ? const Center(child: CircularProgressIndicator())
                  : provider.tasks.isEmpty
                  ? const Center(child: Text('No tasks found'))
                  : RefreshIndicator(
                onRefresh: provider.loadTasks,
                child: ListView.separated(
                  itemCount: provider.tasks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    final task = provider.tasks[index];
                    return TaskCard(task: task);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}