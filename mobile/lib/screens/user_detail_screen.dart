import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';
import 'user_form_screen.dart';

class UserDetailScreen extends StatefulWidget {
  final User user;

  const UserDetailScreen({super.key, required this.user});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    _refreshUser();
  }

  Future<void> _refreshUser() async {
    if (_currentUser?.id != null) {
      final updatedUser = await context.read<UserProvider>().getUser(
        _currentUser!.id!,
      );
      if (updatedUser != null && mounted) {
        setState(() {
          _currentUser = updatedUser;
        });
      }
    }
  }

  void _editUser() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserFormScreen(user: _currentUser),
      ),
    ).then((_) {
      _refreshUser();
    });
  }

  void _deleteUser() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${_currentUser?.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              navigator.pop();
              
              if (_currentUser?.id != null) {
                try {
                  final userProvider = context.read<UserProvider>();
                  final success = await userProvider.deleteUser(
                    _currentUser!.id!,
                  );
                  if (success && mounted) {
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('User deleted successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    navigator.pop();
                  } else if (mounted) {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          userProvider.error ?? 'Failed to delete user',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('User Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentUser!.name),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _editUser),
          PopupMenuButton(
            onSelected: (value) {
              switch (value) {
                case 'delete':
                  _deleteUser();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshUser,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Profile Avatar
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  _currentUser!.name.isNotEmpty
                      ? _currentUser!.name[0].toUpperCase()
                      : 'U',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // User Information Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'User Information',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      icon: Icons.person,
                      label: 'Name',
                      value: _currentUser!.name,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.email,
                      label: 'Email',
                      value: _currentUser!.email,
                    ),
                    if (_currentUser!.id != null) ...[
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        icon: Icons.tag,
                        label: 'ID',
                        value: _currentUser!.id.toString(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Timestamps Card
            if (_currentUser!.createdAt != null ||
                _currentUser!.updatedAt != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Timestamps',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_currentUser!.createdAt != null) ...[
                        _buildInfoRow(
                          icon: Icons.add_circle_outline,
                          label: 'Created',
                          value: _formatDateTime(_currentUser!.createdAt!),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (_currentUser!.updatedAt != null)
                        _buildInfoRow(
                          icon: Icons.update,
                          label: 'Last Updated',
                          value: _formatDateTime(_currentUser!.updatedAt!),
                        ),
                      if (_currentUser!.emailVerifiedAt != null) ...[
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          icon: Icons.verified,
                          label: 'Email Verified',
                          value: _formatDateTime(
                            _currentUser!.emailVerifiedAt!,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _editUser,
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit User'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _deleteUser,
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete User'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.outline),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
