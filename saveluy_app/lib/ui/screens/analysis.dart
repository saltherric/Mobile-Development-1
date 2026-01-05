import 'package:flutter/material.dart';

class AnalysisScreen extends StatelessWidget {
	const AnalysisScreen({super.key});

	static const Color _background = Color(0xFFF5F7FA);
	static const Color _primary = Color(0xFF20C997);
	static const Color _warning = Color(0xFFFFA726);

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: _background,
			appBar: AppBar(
				backgroundColor: Colors.white,
				elevation: 0,
				leading: Navigator.canPop(context)
						? IconButton(
								icon: const Icon(Icons.arrow_back_ios_new, size: 18),
								onPressed: () => Navigator.of(context).maybePop(),
						)
						: null,
				centerTitle: true,
				title: const Text(
					'Habit Analysis',
					style: TextStyle(
						color: Colors.black,
						fontSize: 18,
						fontWeight: FontWeight.w600,
					),
				),
			),
			body: SingleChildScrollView(
				padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
								const Text(
									'Your Progress',
									style: TextStyle(
										fontSize: 18,
										fontWeight: FontWeight.w700,
									),
								),
								Container(
									padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
									decoration: BoxDecoration(
										color: Colors.grey.shade200,
										borderRadius: BorderRadius.circular(18),
									),
									child: const Text(
										'This Week',
										style: TextStyle(
											fontSize: 13,
											fontWeight: FontWeight.w600,
											color: Colors.black87,
										),
									),
								),
							],
						),
						const SizedBox(height: 20),
						const Text(
							'YOUR STREAKS',
							style: TextStyle(
								fontSize: 12,
								fontWeight: FontWeight.w600,
								letterSpacing: 0.4,
								color: Color(0xFF9E9E9E),
							),
						),
						const SizedBox(height: 12),
						..._streaks.map(
							(item) => Padding(
								padding: const EdgeInsets.only(bottom: 12),
								child: _StreakTile(item: item, highlightColor: _warning),
							),
						),
						const SizedBox(height: 12),
						const Text(
							'CATEGORY ACTIVITY',
							style: TextStyle(
								fontSize: 12,
								fontWeight: FontWeight.w600,
								letterSpacing: 0.4,
								color: Color(0xFF9E9E9E),
							),
						),
						const SizedBox(height: 12),
						..._categories.map(
							(item) => Padding(
								padding: const EdgeInsets.only(bottom: 12),
								child: _CategoryCard(item: item),
							),
						),
					],
				),
			),
		);
	}

	static const List<_StreakItem> _streaks = [
		_StreakItem(
			icon: Icons.local_cafe_outlined,
			iconColor: Color(0xFF20C997),
			title: 'Coffee Avoided',
			subtitle: 'No Coffee Today',
			streakCount: 3,
		),
		_StreakItem(
			icon: Icons.savings_outlined,
			iconColor: Color(0xFF20C997),
			title: 'Daily Savings Log',
			subtitle: 'Saved RM5 Today',
			streakCount: 5,
		),
		_StreakItem(
			icon: Icons.local_mall_outlined,
			iconColor: Color(0xFF20C997),
			title: 'Impulse Buy Avoided',
			subtitle: 'Avoided Impulse Buy',
			streakCount: 7,
		),
		_StreakItem(
			icon: Icons.phone_android,
			iconColor: Color(0xFF20C997),
			title: 'Reduced Screen Time',
			subtitle: 'Screen Time Managed',
			streakCount: 1,
		),
		_StreakItem(
			icon: Icons.local_drink,
			iconColor: Color(0xFF20C997),
			title: 'Drank Water',
			subtitle: 'Hydration Goal Hit',
			streakCount: 2,
		),
	];

	static const List<_CategoryItem> _categories = [
		_CategoryItem(
			icon: Icons.restaurant_menu,
			iconColor: Color(0xFFF44336),
			label: 'Food & Drink',
			status: 'High Activity',
			statusColor: Color(0xFFF44336),
			filledDots: 4,
			progress: 0.9,
			accentColor: Color(0xFFE53935),
		),
		_CategoryItem(
			icon: Icons.savings_outlined,
			iconColor: Color(0xFF20C997),
			label: 'Daily Savings',
			status: 'High Activity',
			statusColor: Color(0xFF20C997),
			filledDots: 6,
			progress: 0.95,
			accentColor: Color(0xFF20C997),
		),
		_CategoryItem(
			icon: Icons.shopping_cart_outlined,
			iconColor: Color(0xFFFFB300),
			label: 'Impulse Buying',
			status: 'Controlled',
			statusColor: Color(0xFFFFB300),
			filledDots: 2,
			progress: 0.35,
			accentColor: Color(0xFFFFB300),
		),
	];
}

class _StreakItem {
	final IconData icon;
	final Color iconColor;
	final String title;
	final String subtitle;
	final int streakCount;

	const _StreakItem({
		required this.icon,
		required this.iconColor,
		required this.title,
		required this.subtitle,
		required this.streakCount,
	});
}

class _CategoryItem {
	final IconData icon;
	final Color iconColor;
	final String label;
	final String status;
	final Color statusColor;
	final int filledDots;
	final double progress;
	final Color accentColor;

	const _CategoryItem({
		required this.icon,
		required this.iconColor,
		required this.label,
		required this.status,
		required this.statusColor,
		required this.filledDots,
		required this.progress,
		required this.accentColor,
	});
}

class _StreakTile extends StatelessWidget {
	const _StreakTile({
		required this.item,
		required this.highlightColor,
	});

	final _StreakItem item;
	final Color highlightColor;

	@override
	Widget build(BuildContext context) {
		return Container(
			padding: const EdgeInsets.all(16),
			decoration: BoxDecoration(
				color: Colors.white,
				borderRadius: BorderRadius.circular(16),
				boxShadow: [
					BoxShadow(
						color: Colors.black.withOpacity(0.06),
						blurRadius: 12,
						offset: const Offset(0, 4),
					),
				],
			),
			child: Row(
				children: [
					Container(
						width: 48,
						height: 48,
						decoration: BoxDecoration(
							color: item.iconColor.withOpacity(0.12),
							borderRadius: BorderRadius.circular(12),
						),
						child: Icon(item.icon, color: item.iconColor, size: 26),
					),
					const SizedBox(width: 14),
					Expanded(
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
								Text(
									item.title,
									style: const TextStyle(
										fontSize: 16,
										fontWeight: FontWeight.w600,
									),
								),
								const SizedBox(height: 4),
								Text(
									item.subtitle,
									style: const TextStyle(
										fontSize: 13,
										color: Colors.black54,
									),
								),
							],
						),
					),
					Container(
						padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
						decoration: BoxDecoration(
							color: const Color(0xFFFFF4E5),
							borderRadius: BorderRadius.circular(12),
							border: Border.all(color: highlightColor.withOpacity(0.6)),
						),
						child: Row(
							children: [
								Icon(
									Icons.local_fire_department,
									color: highlightColor,
									size: 16,
								),
								const SizedBox(width: 4),
								Text(
									'${item.streakCount}',
									style: TextStyle(
										fontSize: 14,
										fontWeight: FontWeight.w700,
										color: highlightColor,
									),
								),
							],
						),
					),
				],
			),
		);
	}
}

class _CategoryCard extends StatelessWidget {
	const _CategoryCard({required this.item});

	final _CategoryItem item;

	@override
	Widget build(BuildContext context) {
		return Container(
			padding: const EdgeInsets.all(16),
			decoration: BoxDecoration(
				color: Colors.white,
				borderRadius: BorderRadius.circular(16),
				boxShadow: [
					BoxShadow(
						color: Colors.black.withOpacity(0.06),
						blurRadius: 12,
						offset: const Offset(0, 4),
					),
				],
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Row(
						children: [
							Container(
								width: 44,
								height: 44,
								decoration: BoxDecoration(
									color: item.iconColor.withOpacity(0.12),
									borderRadius: BorderRadius.circular(12),
								),
								child: Icon(item.icon, color: item.iconColor, size: 24),
							),
							const SizedBox(width: 12),
							Expanded(
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(
											item.label,
											style: const TextStyle(
												fontSize: 16,
												fontWeight: FontWeight.w600,
											),
										),
										const SizedBox(height: 4),
										Text(
											item.status,
											style: TextStyle(
												fontSize: 13,
												fontWeight: FontWeight.w600,
												color: item.statusColor,
											),
										),
									],
								),
							),
							Row(
								children: List.generate(5, (index) => _buildDot(index < item.filledDots, item.accentColor)),
							),
						],
					),
					const SizedBox(height: 14),
					ClipRRect(
						borderRadius: BorderRadius.circular(10),
						child: LinearProgressIndicator(
							value: item.progress,
							minHeight: 8,
							backgroundColor: Colors.grey.shade200,
							valueColor: AlwaysStoppedAnimation<Color>(item.accentColor),
						),
					),
				],
			),
		);
	}

	Widget _buildDot(bool isActive, Color color) {
		return Container(
			width: 16,
			height: 16,
			margin: const EdgeInsets.only(left: 4),
			decoration: BoxDecoration(
				shape: BoxShape.circle,
				color: isActive ? color.withOpacity(0.16) : Colors.grey.shade200,
				border: Border.all(
					color: isActive ? color : Colors.grey.shade300,
					width: 1.2,
				),
			),
			child: isActive
					? Center(
							child: Container(
								width: 7,
								height: 7,
								decoration: BoxDecoration(
									color: color,
									shape: BoxShape.circle,
								),
							),
						)
					: null,
		);
	}
}

