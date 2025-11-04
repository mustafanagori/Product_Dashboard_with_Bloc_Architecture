import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:product_dashboard/features/product/domain/entites/product.entity.dart';
import 'package:product_dashboard/features/product/presentation/blocs/product_cubit.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        
          Text(
            'Dashboard Overview',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your product inventory',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),

         
          BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProductLoaded) {
                final total = state.products.length;
                final inStock = state.products
                    .where((ProductEntity p) => p.inStock)
                    .length;
                final outOfStock = total - inStock;

                return Column(
                  children: [
                   
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _DashboardCard(
                            icon: Icons.inventory_2_outlined,
                            title: 'Total Products',
                            value: total.toString(),
                            background:
                                colorScheme.primaryContainer.withOpacity(0.4),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DashboardCard(
                            icon: Icons.check_circle_outline,
                            title: 'In Stock',
                            value: inStock.toString(),
                            background: Colors.green.withOpacity(0.15),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DashboardCard(
                            icon: Icons.error_outline,
                            title: 'Out of Stock',
                            value: outOfStock.toString(),
                            background: Colors.red.withOpacity(0.15),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _ChartCard(
                            title: 'Stock Distribution',
                            child: PieChart(
                              PieChartData(
                                sections: [
                                  PieChartSectionData(
                                    color: Colors.green,
                                    value: inStock.toDouble(),
                                    title: 'In',
                                    radius: 40,
                                  ),
                                  PieChartSectionData(
                                    color: Colors.red,
                                    value: outOfStock.toDouble(),
                                    title: 'Out',
                                    radius: 40,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ChartCard(
                            title: 'Stock Ratio',
                            child: BarChart(
                              BarChartData(
                                titlesData: FlTitlesData(
                                  leftTitles:
                                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  topTitles:
                                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                borderData: FlBorderData(show: false),
                                gridData: FlGridData(show: false),
                                barGroups: [
                                  BarChartGroupData(x: 1, barRods: [
                                    BarChartRodData(
                                        toY: inStock.toDouble(),
                                        color: Colors.green,
                                        width: 20)
                                  ]),
                                  BarChartGroupData(x: 2, barRods: [
                                    BarChartRodData(
                                        toY: outOfStock.toDouble(),
                                        color: Colors.red,
                                        width: 20)
                                  ]),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ChartCard(
                            title: 'Stock Overview',
                            child: Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    value: inStock / total,
                                    backgroundColor: Colors.red.withOpacity(0.3),
                                    color: Colors.green,
                                    strokeWidth: 8,
                                  ),
                                  Text(
                                    '${((inStock / total) * 100).toStringAsFixed(0)}%',
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return const Center(child: Text('No product data available'));
              }
            },
          ),
        ],
      ),
    );
  }
}


class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color background;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: colorScheme.onSurface),
          const Spacer(),
          Text(
            title,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onBackground,
            ),
          ),
        ],
      ),
    );
  }
}


class _ChartCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _ChartCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}
