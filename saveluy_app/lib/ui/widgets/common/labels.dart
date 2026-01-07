import 'package:flutter/material.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_dimensions.dart';

/// Section header label
class SectionLabel extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const SectionLabel({
    super.key,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: style ?? AppTextStyles.sectionLabel,
    );
  }
}

/// Form field label
class FieldLabel extends StatelessWidget {
  final String text;
  final bool required;
  final TextStyle? style;

  const FieldLabel({
    super.key,
    required this.text,
    this.required = false,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: style ?? AppTextStyles.label,
        children: [
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }
}

/// Helper text (subtitle/hint below inputs)
class HelperText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final EdgeInsetsGeometry? padding;

  const HelperText({
    super.key,
    required this.text,
    this.style,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: style ?? AppTextStyles.caption,
      ),
    );
  }
}

/// Labeled field (label + content widget)
class LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  final String? helperText;
  final bool required;
  final double spacing;

  const LabeledField({
    super.key,
    required this.label,
    required this.child,
    this.helperText,
    this.required = false,
    this.spacing = AppDimensions.paddingSmall,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(text: label, required: required),
        SizedBox(height: spacing),
        child,
        if (helperText != null) HelperText(text: helperText!),
      ],
    );
  }
}
