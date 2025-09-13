import 'package:flutter/material.dart';

class AsyncValueWidget extends StatelessWidget {
  final bool isLoading;
  final Object? error;
  final Widget Function() builder;
  const AsyncValueWidget({super.key, required this.isLoading, required this.error, required this.builder});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return Center(child: Text('Error: $error'));
    }
    return builder();
  }
}
