import 'package:flutter/material.dart';
import '../../../../core/widgets/shimmer_widget.dart';

class EmployeeShimmer extends StatelessWidget {
  const EmployeeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const ShimmerWidget.circular(width: 50, height: 50),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerWidget.rectangular(height: 16, width: 120),
                  const SizedBox(height: 8),
                  const ShimmerWidget.rectangular(height: 12, width: 180),
                  const SizedBox(height: 8),
                  const ShimmerWidget.rectangular(height: 12, width: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
