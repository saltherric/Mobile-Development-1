import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Reusable AppBar widget for the app
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Widget? titleWidget;

  const AppAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.titleWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: centerTitle,
      leading: leading ??
          (showBackButton && Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                  onPressed: () => Navigator.of(context).maybePop(),
                  color: AppColors.black,
                )
              : null),
      title: titleWidget ??
          Text(
            title,
            style: AppTextStyles.appBarTitle,
          ),
      actions: actions,
      foregroundColor: AppColors.black,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// AppBar with logo (for home screen)
class AppAppBarWithLogo extends StatelessWidget implements PreferredSizeWidget {
  final String appName;
  final String logoAssetPath;

  const AppAppBarWithLogo({
    super.key,
    required this.appName,
    this.logoAssetPath = 'assets/images/Logo.png',
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            logoAssetPath,
            height: 60,
            fit: BoxFit.contain,
          ),
          Text(
            appName,
            style: AppTextStyles.heading2,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
