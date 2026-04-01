import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../services/draft_service.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;
  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final DraftService _draftService = DraftService();

  DateTime? _selectedDate;
  String _status = 'To-Do';
  int? _blockedBy;
  bool _draftLoaded = false;

  bool get isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    _initializeForm();
    _titleController.addListener(_saveDraft);
    _descriptionController.addListener(_saveDraft);
  }

  Future<void> _initializeForm() async {
    if (isEditing) {
      final task = widget.task!;
      _titleController.text = task.title;
      _descriptionController.text = task.description;
      _selectedDate = DateTime.parse(task.dueDate);
      _status = task.status;
      _blockedBy = task.blockedBy;
    } else {
      final draft = await _draftService.getDraft();
      if (draft != null) {
        _titleController.text = draft['title'] ?? '';
        _descriptionController.text = draft['description'] ?? '';
        if ((draft['dueDate'] ?? '').toString().isNotEmpty) {
          _selectedDate = DateTime.tryParse(draft['dueDate']);
        }
        _status = draft['status'] ?? 'To-Do';
        _blockedBy = draft['blockedBy'];
      }
    }

    setState(() {
      _draftLoaded = true;
    });
  }

  Future<void> _saveDraft() async {
    if (isEditing) return;

    await _draftService.saveDraft({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'dueDate': _selectedDate?.toIso8601String() ?? '',
      'status': _status,
      'blockedBy': _blockedBy,
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
      _saveDraft();
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null) return;

    final provider = context.read<TaskProvider>();

    final task = Task(
      id: widget.task?.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      dueDate: DateFormat('yyyy-MM-dd').format(_selectedDate!),
      status: _status,
      blockedBy: _blockedBy,
    );

    bool success;
    if (isEditing) {
      success = await provider.updateTask(widget.task!.id!, task);
    } else {
      success = await provider.createTask(task);
    }

    if (success && mounted) {
      if (!isEditing) {
        await _draftService.clearDraft();
      }
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final tasks = provider.tasks
        .where((t) => widget.task == null || t.id != widget.task!.id)
        .toList();

    if (!_draftLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Create Task'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          onChanged: _saveDraft,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Description is required' : null,
              ),
              const SizedBox(height: 14),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Due Date'),
                  child: Text(
                    _selectedDate == null
                        ? 'Select due date'
                        : DateFormat('dd MMM yyyy').format(_selectedDate!),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: const [
                  DropdownMenuItem(value: 'To-Do', child: Text('To-Do')),
                  DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
                  DropdownMenuItem(value: 'Done', child: Text('Done')),
                ],
                onChanged: (value) {
                  setState(() => _status = value!);
                  _saveDraft();
                },
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<int?>(
                value: _blockedBy,
                decoration: const InputDecoration(labelText: 'Blocked By (Optional)'),
                items: [
                  const DropdownMenuItem<int?>(value: null, child: Text('None')),
                  ...tasks.map(
                        (task) => DropdownMenuItem<int?>(
                      value: task.id,
                      child: Text(task.title),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() => _blockedBy = value);
                  _saveDraft();
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: provider.isSaving ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: provider.isSaving
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : Text(isEditing ? 'Save Changes' : 'Save Task'),
                ),
              ),
              if (provider.error != null) ...[
                const SizedBox(height: 12),
                Text(
                  provider.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}