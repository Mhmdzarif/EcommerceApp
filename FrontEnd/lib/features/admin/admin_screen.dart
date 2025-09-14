import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'add_product_tab.dart';
import 'all_orders_tab.dart';
import 'low_stock_tab.dart';

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 3, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await ref.read(authActionsProvider).logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
        bottom: TabBar(controller: _tab, tabs: const [
          Tab(text: 'Add Product'),
          Tab(text: 'All Orders'),
          Tab(text: 'Low Stock'),
        ]),
      ),
      body: TabBarView(
        controller: _tab,
        children: const [
          AddProductTab(),
          AllOrdersTab(),
          LowStockTab(),
        ],
      ),
    );
  }
}
