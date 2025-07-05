import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  String? _selectedStatus;
  String? _selectedPriority;

  @override
  void initState() {
    super.initState();
    final provider = context.read<TaskProvider>();
    _selectedStatus = provider.statusFilter;
    _selectedPriority = provider.priorityFilter;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Filter Tasks',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Status filter
          Text(
            'Status',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildFilterChip(
                label: 'All',
                isSelected: _selectedStatus == null,
                onTap: () => setState(() => _selectedStatus = null),
              ),
              _buildFilterChip(
                label: 'Pending',
                isSelected: _selectedStatus == 'pending',
                onTap: () => setState(() => _selectedStatus = 'pending'),
              ),
              _buildFilterChip(
                label: 'In Progress',
                isSelected: _selectedStatus == 'in_progress',
                onTap: () => setState(() => _selectedStatus = 'in_progress'),
              ),
              _buildFilterChip(
                label: 'Completed',
                isSelected: _selectedStatus == 'completed',
                onTap: () => setState(() => _selectedStatus = 'completed'),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Priority filter
          Text(
            'Priority',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildFilterChip(
                label: 'All',
                isSelected: _selectedPriority == null,
                onTap: () => setState(() => _selectedPriority = null),
              ),
              _buildFilterChip(
                label: 'Low',
                isSelected: _selectedPriority == 'low',
                onTap: () => setState(() => _selectedPriority = 'low'),
                color: Colors.green,
              ),
              _buildFilterChip(
                label: 'Medium',
                isSelected: _selectedPriority == 'medium',
                onTap: () => setState(() => _selectedPriority = 'medium'),
                color: Colors.orange,
              ),
              _buildFilterChip(
                label: 'High',
                isSelected: _selectedPriority == 'high',
                onTap: () => setState(() => _selectedPriority = 'high'),
                color: Colors.red,
              ),
            ],
          ),
          
          const SizedBox(height: 30),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedStatus = null;
                      _selectedPriority = null;
                    });
                  },
                  child: const Text('Clear All'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<TaskProvider>().loadTasks(
                          status: _selectedStatus,
                          priority: _selectedPriority,
                          refresh: true,
                        );
                    Navigator.pop(context);
                  },
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? color,
  }) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (color ?? theme.colorScheme.primary)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (color ?? theme.colorScheme.primary)
                : theme.colorScheme.outline,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isSelected
                ? Colors.white
                : (color ?? theme.colorScheme.onSurface),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
