import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fx_crm/view/customer_profile_screen.dart';
import '../utils/theme.dart';
import '../widgets/bg_container.dart';
import 'component/drawer_component/custom_drawer.dart';
import 'component/notification/notification_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: const CustomDrawer(),
        appBar: AppBar(
          backgroundColor: ThemeUtils.primaryColor,
          surfaceTintColor: Colors.transparent,
          elevation: 4,
          leading: Builder(
            builder: (context) => InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Scaffold.of(context).openDrawer(),
              child: const Icon(Icons.menu, color: Colors.white),
            ),
          ),
          centerTitle: false,
          title: const Text(
            "Dashboard",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationScreen(),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.person_outline, color: Colors.white),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CustomerProfileScreen(),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildCardRow([
                _buildDashboardCard(
                  title: 'Active Balance',
                  value: '\$4805',
                  subTitle: '\$34 Since last week',
                  icon: Icons.account_balance_wallet_outlined,
                ),
                _buildDashboardCard(
                  title: 'Wallet Balance',
                  value: '8.4K',
                  subTitle: '14% Since last week',
                  icon: Icons.account_balance_outlined,
                ),
              ]),
              _buildCardRow([
                _buildDashboardCard(
                  title: 'Today Profit',
                  value: '59K',
                  subTitle: '-12.4% Since last week',
                  icon: Icons.trending_down_outlined,
                ),
                _buildDashboardCard(
                  title: 'Total Account',
                  value: '867',
                  progress: 0.7,
                  icon: Icons.group_outlined,
                ),
              ]),
              _buildCardRow([
                _buildDashboardCard(
                  title: 'Pending Withdraw',
                  value: '\$52,945',
                  progress: 0.6,
                  icon: Icons.pending_outlined,
                ),
                _buildDashboardCard(
                  title: 'Last 7 Days Profit',
                  value: '24.5K',
                  progress: 0.5,
                  icon: Icons.calendar_today_outlined,
                ),
              ]),
              _buildCardRow([
                _buildDashboardCard(
                  title: 'Last 30 Days Profit',
                  value: '869',
                  progress: 0.8,
                  icon: Icons.date_range_outlined,
                ),
              ]),
              const SizedBox(height: 24),
              _buildDailyReturnCard(),
              const SizedBox(height: 24),
              _buildMetricCard("Bounce Rate", "48.32%", "+12.34", true),
              _buildMetricCard("Pageviews", "52.64%", "+21.34", true),
              _buildMetricCard("New Sessions", "68.23%", "+18.42", true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardRow(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(child: children[0]),
          const SizedBox(width: 12),
          Expanded(child: children.length > 1 ? children[1] : const SizedBox()),
        ],
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String value,
    String? subTitle,
    double? progress,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromARGB(31, 149, 20, 20)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ),
              Icon(icon, color: Colors.white54),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          if (subTitle != null)
            Text(
              subTitle,
              style: const TextStyle(fontSize: 12, color: Colors.white38),
            )
          else if (progress != null)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.white12,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade800,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.white70,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 10),
          Container(
            height: 30,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const MiniLineChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyReturnCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Daily Return Chart",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Icon(Icons.more_vert, color: Colors.white70),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "in last 30 days revenue",
            style: TextStyle(
              color: Colors.white38,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 20),
          _buildReturnItem(
            "Revenue",
            "\$4805",
            "\$1458 Since last month",
            isUp: true,
          ),
          const Divider(color: Colors.white10, height: 24),
          _buildReturnItem(
            "Total Customers",
            "8.4K",
            "12.3% Since last month",
            isUp: true,
          ),
          const Divider(color: Colors.white10, height: 24),
          _buildReturnItem(
            "Store Visitors",
            "59K",
            "2.4% Since last month",
            isUp: false,
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 120,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, _) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, _) {
                        const months = [
                          'Feb',
                          'Mar',
                          'Apr',
                          'May',
                          'Jun',
                          'Jul',
                          'Aug',
                          'Sep',
                          'Oct',
                        ];
                        return value.toInt() < months.length
                            ? Text(
                                months[value.toInt()],
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 11,
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  getDrawingHorizontalLine: (_) =>
                      const FlLine(color: Colors.white10, strokeWidth: 0.5),
                ),
                barGroups: List.generate(
                  9,
                  (i) => BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: (i + 5) * 10.0,
                        width: 10,
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReturnItem(
    String title,
    String value,
    String desc, {
    required bool isUp,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                Icon(
                  isUp ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 14,
                  color: isUp ? Colors.green : Colors.red,
                ),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 11,
                    color: isUp ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String percentage,
    bool isIncrease,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isIncrease
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  isIncrease
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  color: isIncrease ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  percentage,
                  style: TextStyle(
                    color: isIncrease ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
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

class MiniLineChart extends StatelessWidget {
  const MiniLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minY: 7,
        maxY: 31,
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 9),
              FlSpot(1, 32),
              FlSpot(2, 26),
              FlSpot(3, 19),
              FlSpot(4, 20),
              FlSpot(5, 26),
              FlSpot(6, 26),
              FlSpot(7, 24),
              FlSpot(8, 22),
              FlSpot(9, 29),
              FlSpot(10, 23),
              FlSpot(11, 22),
              FlSpot(12, 18),
              FlSpot(13, 36),
              FlSpot(14, 28),
              FlSpot(15, 18),
              FlSpot(16, 26),
              FlSpot(17, 25),
              FlSpot(18, 12),
              FlSpot(19, 25),
              FlSpot(20, 18),
              FlSpot(21, 22),
              FlSpot(22, 19),
              FlSpot(23, 29),
              FlSpot(24, 22),
              FlSpot(25, 25),
              FlSpot(26, 9),
            ],
            isCurved: true,
            curveSmoothness: 0.3,
            color: const Color(0xff0262f7).withOpacity(0.7), // stronger opacity for line
            barWidth: 2,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xff0262f7).withOpacity(0.3),
            ),
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
