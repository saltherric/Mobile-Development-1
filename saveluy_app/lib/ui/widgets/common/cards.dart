import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';

/// Reusable card widget with consistent styling
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Border? border;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.elevation,
    this.borderRadius,
    this.border,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      padding: padding ?? const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: color ?? AppColors.white,
        borderRadius: borderRadius ??
            BorderRadius.circular(AppDimensions.radiusLarge),
        border: border,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius ??
            BorderRadius.circular(AppDimensions.radiusLarge),
        child: cardContent,
      );
    }

    return cardContent;
  }
}

/// Colored info/action card
class ColoredCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double? borderRadius;

  const ColoredCard({
    super.key,
    required this.child,
    required this.color,
    this.padding,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      padding: padding ?? const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius:
            BorderRadius.circular(borderRadius ?? AppDimensions.radiusMedium),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
            borderRadius ?? AppDimensions.radiusMedium),
        child: cardContent,
      );
    }

    return cardContent;
  }
}

/// Info box widget (for displaying helpful information)
class InfoBox extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color borderColor;
  final IconData? icon;

  const InfoBox({
    super.key,
    required this.text,
    this.backgroundColor = const Color(0xFFE8F5E9),
    this.borderColor = const Color(0xFF81C784),
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: borderColor, size: AppDimensions.iconMedium),
            const SizedBox(width: AppDimensions.paddingSmall),
          ],
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

/// Icon container (for displaying icons with background)
class IconContainer extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final double size;
  final double iconSize;
  final double? borderRadius;

  const IconContainer({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    this.size = 48,
    this.iconSize = 24,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
            borderRadius ?? AppDimensions.radiusSmall),
      ),
      child: Icon(icon, color: iconColor, size: iconSize),
    );
  }
}
