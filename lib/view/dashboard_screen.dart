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
  // late final DashBoardController dashBoardController;
  // @override
  // void initState() {
  //   super.initState();
  //   dashBoardController = Get.put(DashBoardController(dioClient: dioClient)); // Provide dioClient
  //   dashBoardController.getDashboardData();
  //
  // }
  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: const CustomDrawer(),
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: ThemeUtils.primaryColor,
          centerTitle: false,
          title: const Text(
            "DASHBOARD",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          actions: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationScreen(),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerProfileScreen(),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 12.0), // adjust as needed
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),

        // backgroundColor: const Color(0xFF1A1A1A),
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
                  icon: Icons.person_outline,
                ),
              ]),
              _buildCardRow([
                _buildDashboardCard(
                  title: 'Today Profit',
                  value: '59K',
                  subTitle: '-12.4% Since last week',
                  icon: Icons.visibility_outlined,
                ),
                _buildDashboardCard(
                  title: 'Total Account',
                  value: '867',
                  progress: 0.7,
                  icon: Icons.shopping_cart_outlined,
                ),
              ]),
              _buildCardRow([
                _buildDashboardCard(
                  title: 'Pending Withdraw',
                  value: '\$52,945',
                  progress: 0.6,
                  icon: Icons.account_balance_wallet_outlined,
                ),
                _buildDashboardCard(
                  title: 'Last 7 Days Profit',
                  value: '24.5K',
                  progress: 0.5,
                  icon: Icons.lightbulb_outline,
                ),
              ]),
              _buildCardRow([
                _buildDashboardCard(
                  title: 'Last 30 Days Profit',
                  value: '869',
                  progress: 0.8,
                  icon: Icons.chat_bubble_outline,
                ),
                const SizedBox(width: 8), // empty space
              ]),
              const SizedBox(height: 20),
              _buildDailyReturnCard(),
              const SizedBox(height: 20),
              _buildBounceRateCard(
                title: "Bounce Rate",
                value: "48.32%",
                percentage: "+12.34",
                isIncrease: true,
              ),
              const SizedBox(height: 12),
              _buildBounceRateCard(
                title: "Pageviews",
                value: "52.64%",
                percentage: "+21.34",
                isIncrease: true,
              ),
              const SizedBox(height: 12),
              _buildBounceRateCard(
                title: "New Sessions",
                value: "68.23%",
                percentage: "+18.42",
                isIncrease: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardRow(List<Widget> children) {
    return Row(
      children: [
        Expanded(child: children[0]),
        const SizedBox(width: 8),
        Expanded(child: children.length > 1 ? children[1] : Container()),
      ],
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String value,
    String? subTitle,
    double? progress,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.grey.shade900.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title and Icon
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                  ),
                ),
                const SizedBox(width: 8),
                Icon(icon, color: Colors.white70),
              ],
            ),

            const SizedBox(height: 12),

            /// Value
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            /// Sub Title or Progress Bar
            subTitle != null
                ? Text(
                  subTitle,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                )
                : progress != null
                ? LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade700,
                  color: Colors.greenAccent,
                )
                : const SizedBox.shrink(),
            const SizedBox(height: 10),

            /// Mini line (fake small graph line)
            Container(
              height: 30,
              width: double.infinity,
              color: Colors.transparent,
              child: CustomPaint(painter: _FakeGraphPainter()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyReturnCard() {
    return Card(
      color: Colors.grey.shade900.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Daily Return Chart',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.more_vert, color: Colors.white70),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'in last 30 days revenue',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 16),

            /// Revenue Section
            _buildReturnItem(
              'Revenue',
              '\$4805',
              '\$1458 Since last month',
              isUp: true,
            ),
            const SizedBox(height: 8),
            _buildReturnItem(
              'Total Customers',
              '8.4K',
              '12.3% Since last month',
              isUp: true,
            ),
            const SizedBox(height: 8),
            _buildReturnItem(
              'Store Visitors',
              '59K',
              '2.4% Since last month',
              isUp: false,
            ),

            const SizedBox(height: 16),

            /// Chart Section
            SizedBox(
              height: 150,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 120,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final titles = [
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
                          if (value.toInt() < titles.length) {
                            return Text(
                              titles[value.toInt()],
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 10,
                              ),
                            );
                          }
                          return const Text('');
                        },
                        reservedSize: 24,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(9, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: (index + 5) * 10.0,
                          width: 8,
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// Legends
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendDot(color: Colors.blueAccent, title: 'Total Sales'),
                _buildLegendDot(color: Colors.greenAccent, title: 'Customers'),
                _buildLegendDot(
                  color: Colors.purpleAccent,
                  title: 'Store Visitors',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBounceRateCard({
    required String title,
    required String value,
    required String percentage,
    bool isIncrease = true,
  }) {
    return Card(
      color: Colors.grey.shade900.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title + Percentage
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "$percentage Increase",
                      style: TextStyle(
                        color:
                            isIncrease ? Colors.greenAccent : Colors.redAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "From Last Week",
                      style: TextStyle(color: Colors.white54, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// Value (e.g. 48.32%)
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            /// Line Chart
            SizedBox(
              height: 70,
              child: LineChart(
                LineChartData(
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: Colors.white,
                      barWidth: 2,
                      spots: [
                        FlSpot(0, 3),
                        FlSpot(1, 2),
                        FlSpot(2, 4),
                        FlSpot(3, 3),
                        FlSpot(4, 5),
                        FlSpot(5, 4),
                        FlSpot(6, 6),
                      ],
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReturnItem(
    String title,
    String value,
    String subText, {
    bool isUp = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 2),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Row(
              children: [
                Icon(
                  isUp ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: isUp ? Colors.greenAccent : Colors.redAccent,
                  size: 20,
                ),
                Text(
                  subText,
                  style: TextStyle(
                    color: isUp ? Colors.greenAccent : Colors.redAccent,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendDot({required Color color, required String title}) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(title, style: TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

  // Widget _buildReturnItem(String title, String value, String description) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 16),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(title, style: const TextStyle(color: Colors.white70, fontSize: 13)),
  //         const SizedBox(height: 4),
  //         Text(
  //           value,
  //           style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
  //         ),
  //         const SizedBox(height: 2),
  //         Text(
  //           description,
  //           style: const TextStyle(color: Colors.white54, fontSize: 12),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class _FakeGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white30
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height / 2);
    path.quadraticBezierTo(
      size.width * 0.25,
      0,
      size.width * 0.5,
      size.height / 2,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height,
      size.width,
      size.height / 2,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
