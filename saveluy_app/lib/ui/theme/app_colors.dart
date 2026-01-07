import 'package:flutter/material.dart';

/// App-wide color constants
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF20C997);
  static const Color background = Color(0xFFF5F7FA);
  
  // Semantic colors
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFFF6B6B);
  static const Color success = Color(0xFF20C997);
  
  // Neutral colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color black87 = Colors.black87;
  static const Color grey = Colors.grey;
  
  // UI Element colors
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color cardBackground = Colors.white;
  
  /// Get grey shade
  static Color greyShade(int shade) {
    return Colors.grey.shade100;
  }
  
  /// Get primary with opacity
  static Color primaryWithOpacity(double opacity) {
    return primary.withOpacity(opacity);
  }
  
  /// Get success with opacity
  static Color successWithOpacity(double opacity) {
    return success.withOpacity(opacity);
  }
}
