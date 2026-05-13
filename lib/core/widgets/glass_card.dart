import 'package:flutter/material.dart';

Widget glassCard({required Widget child}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      color: Colors.white.withValues(alpha: 0.04),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.4),
          blurRadius: 12,
          offset: Offset(0, 6),
        ),
      ],
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.08),
      ),
    ),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: child,
    ),
  );
}