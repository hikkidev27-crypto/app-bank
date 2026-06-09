import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              _buildExpenseDonutChart(),
              const SizedBox(height: 40),
              _buildPeriodSelector(),
              const SizedBox(height: 20),
              _buildBarChart(),
              const SizedBox(height: 100), // Space for bottom nav
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Gastos totales",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
            Text(
              "S/ 3,800.00",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(8),
          child: const Icon(Icons.notifications_none, color: Colors.white),
        )
      ],
    );
  }

  Widget _buildExpenseDonutChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 150,
            width: 150,
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 50,
                    sections: [
                      PieChartSectionData(color: AppColors.accentGreen, value: 40, radius: 12, showTitle: false),
                      PieChartSectionData(color: AppColors.primary, value: 20, radius: 12, showTitle: false),
                      PieChartSectionData(color: Colors.purple, value: 15, radius: 12, showTitle: false),
                      PieChartSectionData(color: AppColors.accentOrange, value: 10, radius: 12, showTitle: false),
                      PieChartSectionData(color: Colors.yellow, value: 8, radius: 12, showTitle: false),
                      PieChartSectionData(color: Colors.cyan, value: 7, radius: 12, showTitle: false),
                    ],
                  ),
                ),
                const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("S/ 3,800.00", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      Text("Total", style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              children: [
                _ChartLegendItem(color: AppColors.accentGreen, label: "Alimentación", amount: "S/ 1,520.00", percent: "40%"),
                _ChartLegendItem(color: AppColors.primary, label: "Transporte", amount: "S/ 760.00", percent: "20%"),
                _ChartLegendItem(color: Colors.purple, label: "Entretenimiento", amount: "S/ 570.00", percent: "15%"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Gastos por periodos",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _PeriodButton(label: "Semana"),
            _PeriodButton(label: "Mes", isSelected: true),
            _PeriodButton(label: "3 Meses"),
            _PeriodButton(label: "Año"),
          ],
        ),
      ],
    );
  }

  Widget _buildBarChart() {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 1200,
          barTouchData: BarTouchData(enabled: false),
          titlesData: const FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: _getBottomTitles,
              ),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: [
            _makeGroupData(0, 800),
            _makeGroupData(1, 1000),
            _makeGroupData(2, 600),
            _makeGroupData(3, 1100, isHighlight: true),
            _makeGroupData(4, 700),
            _makeGroupData(5, 900),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y, {bool isHighlight = false}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isHighlight ? Colors.redAccent : AppColors.primary.withOpacity(0.4),
          width: 18,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  static Widget _getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: AppColors.textSecondary, fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0: text = '1 Abr'; break;
      case 1: text = '8 Abr'; break;
      case 2: text = '15 Abr'; break;
      case 3: text = '22 Abr'; break;
      case 4: text = '29 Abr'; break;
      case 5: text = '6 May'; break;
      default: text = ''; break;
    }
    return SideTitleWidget(axisSide: meta.axisSide, child: Text(text, style: style));
  }

  Widget _buildBottomNav() {
    return BottomAppBar(
      color: AppColors.surface,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_filled, "Inicio", 0),
          _buildNavItem(Icons.security, "Metas", 1),
          const SizedBox(width: 40), // Space for FAB
          _buildNavItem(Icons.bar_chart, "Estadísticas", 2),
          _buildNavItem(Icons.person_outline, "Perfil", 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary),
          Text(label, style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontSize: 10,
          )),
        ],
      ),
    );
  }
}

class _ChartLegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String amount;
  final String percent;

  const _ChartLegendItem({
    required this.color,
    required this.label,
    required this.amount,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
          ),
          Text(amount, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Text(percent, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _PeriodButton extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _PeriodButton({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
