import 'package:flutter/material.dart';

Widget glassCard({required Widget child}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),

      // ✅ Subtle dark surface (no glow)
      color: Colors.white.withOpacity(0.04),

      // ✅ Soft elevation (depth)
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 12,
          offset: Offset(0, 6),
        ),
      ],

      // ✅ Clean border
      border: Border.all(
        color: Colors.white.withOpacity(0.08),
      ),
    ),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: child,
    ),
  );
}