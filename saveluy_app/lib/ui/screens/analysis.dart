import 'package:flutter/material.dart';

import '../../data/repositories/analysisRepository.dart';
import '../../data/mockData.dart';
import '../../models/analysisData.dart';

class AnalysisScreen extends StatefulWidget {
	const AnalysisScreen({super.key});

	@override
	State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
	static const Color _background = Color(0xFFF5F7FA);
	static const Color _warning = Color(0xFFFFA726);

	late AnalysisDataRepository _analysisDataRepository;
	late Future<AnalysisData?> _analysisDataFuture;

	@override
	void initState() {
		super.initState();
		_analysisDataRepository = AnalysisDataRepository();
		_analysisDataFuture = _loadAnalysisData();
	}

	Future<AnalysisData?> _loadAnalysisData() async {
		final analysisData = await _analysisDataRepository.getAnalysisData('analysis_data_default');
		if (analysisData == null) {
			// If no data exists, create default data and save it
			final defaultData = _analysisDataRepository.createNewAnalysisData(
				streaks: MockData.getDefaultStreaks(),
				categories: MockData.getDefaultCategories(),
			);
			await _analysisDataRepository.saveAnalysisData(defaultData);
			return defaultData;
		}
		return analysisData;
	}

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
			body: FutureBuilder<AnalysisData?>(
				future: _analysisDataFuture,
				builder: (context, snapshot) {
					if (snapshot.connectionState == ConnectionState.waiting) {
						return const Center(child: CircularProgressIndicator());
					}

					if (snapshot.hasError) {
						return Center(
							child: Column(
								mainAxisAlignment: MainAxisAlignment.center,
								children: [
									const Text('Error loading analysis data'),
									ElevatedButton(
										onPressed: () {
											setState(() {
												_analysisDataFuture = _loadAnalysisData();
											});
										},
										child: const Text('Retry'),
									),
								],
							),
						);
					}

					final analysisData = snapshot.data;
					if (analysisData == null) {
						return const Center(child: Text('No data available'));
					}

					return SingleChildScrollView(
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
								...analysisData.streaks.map(
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
								...analysisData.categories.map(
									(item) => Padding(
										padding: const EdgeInsets.only(bottom: 12),
										child: _CategoryCard(item: item),
									),
								),
							],
						),
					);
				},
			),
		);
	}
}

class _StreakItem {
	final String imagePath;
	final String title;
	final String subtitle;
	final int streakCount;
	final String category;

	const _StreakItem({
		required this.imagePath,
		required this.title,
		required this.subtitle,
		required this.streakCount,
		required this.category,
	});
}

class _CategoryItem {
	final String imagePath;
	final Color iconColor;
	final String label;
	final String status;
	final Color statusColor;
	final int filledDots;
	final double progress;
	final Color accentColor;

	const _CategoryItem({
		required this.imagePath,
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

	final StreakItem item;
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
							color: const Color(0xFF20C997).withOpacity(0.12),
							borderRadius: BorderRadius.circular(12),
						),
						child: ClipRRect(
							borderRadius: BorderRadius.circular(12),
							child: Image.asset(
								item.imagePath,
								fit: BoxFit.cover,
							),
						),
					),
					const SizedBox(width: 14),
					Expanded(
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
								Row(
									children: [
										Text(
											item.title,
											style: const TextStyle(
												fontSize: 16,
												fontWeight: FontWeight.w600,
											),
										),
										const SizedBox(width: 8),
										Container(
											padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
											decoration: BoxDecoration(
												color: Colors.grey.shade100,
												borderRadius: BorderRadius.circular(4),
											),
											child: Text(
												item.category,
												style: TextStyle(
													fontSize: 10,
													fontWeight: FontWeight.w500,
													color: Colors.grey.shade600,
												),
											),
										),
									],
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

	final CategoryItem item;

	Color _hexToColor(String hexString) {
		hexString = hexString.replaceAll('#', '');
		if (hexString.length == 6) {
			hexString = 'FF$hexString';
		}
		return Color(int.parse(hexString, radix: 16));
	}

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
									color: _hexToColor(item.iconColorHex).withOpacity(0.12),
									borderRadius: BorderRadius.circular(12),
								),
								child: ClipRRect(
									borderRadius: BorderRadius.circular(12),
									child: Image.asset(
										item.imagePath,
										fit: BoxFit.cover,
									),
								),
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
												color: _hexToColor(item.statusColorHex),
											),
										),
									],
								),
							),
							Row(
								children: List.generate(5, (index) => _buildDot(index < item.filledDots, _hexToColor(item.accentColorHex))),
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
							valueColor: AlwaysStoppedAnimation<Color>(_hexToColor(item.accentColorHex)),
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

