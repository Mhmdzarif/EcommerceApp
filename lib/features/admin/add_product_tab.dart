import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../widgets/error_snackbar.dart';
import '../catalog/catalog_providers.dart';
import 'admin_providers.dart';

class AddProductTab extends ConsumerStatefulWidget {
  const AddProductTab({super.key});

  @override
  ConsumerState<AddProductTab> createState() => _AddProductTabState();
}

class _AddProductTabState extends ConsumerState<AddProductTab> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _price = TextEditingController(); // in currency units, will convert to cents
  final _stock = TextEditingController();

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Name required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _price,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Price (e.g., 12.99)'),
              validator: (v) {
                final d = double.tryParse(v ?? '');
                if (d == null || d < 0) return 'Enter valid price';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _stock,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Stock'),
              validator: (v) {
                final n = int.tryParse(v ?? '');
                if (n == null || n < 0) return 'Enter valid stock';
                return null;
              },
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _loading ? null : () async {
                if (!_formKey.currentState!.validate()) return;
                setState(() => _loading = true);
                try {
                  final priceCents = (double.parse(_price.text) * 100).round();
                  final stock = int.parse(_stock.text);
                  await ref.read(addProductProvider((name: _name.text.trim(), priceCents: priceCents, stock: stock)).future);
                  ref.invalidate(productsProvider);
                  if (mounted) {
                    showErrorSnackBar(context, 'Product added');
                    _name.clear(); _price.clear(); _stock.clear();
                  }
                } catch (e) {
                  if (mounted) showErrorSnackBar(context, e.toString());
                } finally {
                  if (mounted) setState(() => _loading = false);
                }
              },
              child: _loading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
