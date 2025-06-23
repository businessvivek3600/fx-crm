import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fx_crm/view/customer_profile_screen.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controller/app_controller.dart';
import '../controller/notification_controller.dart';
import '../widgets/bg_container.dart';
import 'component/drawer_component/custom_drawer.dart';
import 'component/notification/notification_screen.dart';

// colors: [Color(0xFF2E2E2E), Color(0xff021b43)],
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  List<String> motivationalTexts = [
    "MT5 Trading",
    "Trade More Earn More",
    "Grow Your Portfolio",
    "Invest Smartly",
    "Profit Everyday",
  ];
  int currentMessageIndex = 0;
  late Timer textTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: false);

    _animation = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: const Offset(3.5, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    textTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        currentMessageIndex =
            (currentMessageIndex + 1) % motivationalTexts.length;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    textTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customer = AppController.to.customer.value;
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: const CustomDrawer(),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Stack(
            children: [
              // Background Gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2E2E2E), Color(0xff021b43)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),

              // Lottie animation sliding left to right
              Positioned(
                top: 30,
                child: SlideTransition(
                  position: _animation,
                  child: SizedBox(
                    width: 100,
                    height: 70,
                    child: Lottie.asset(
                      'assets/json/trade-bot.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // AppBar content
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                leading: Builder(
                  builder:
                      (context) => Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => Scaffold.of(context).openDrawer(),
                          child: const Icon(Icons.menu, color: Colors.white),
                        ),
                      ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer!.firstName!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder:
                          (child, animation) =>
                              FadeTransition(opacity: animation, child: child),
                      child: Text(
                        motivationalTexts[currentMessageIndex],
                        key: ValueKey(currentMessageIndex),
                        style: const TextStyle(
                          color: Color(0xff0262f7),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
                centerTitle: false,
                actions: [
                  // 🔔 Notification with badge count
                  Obx(() {
                    final unread =
                        Get.find<NotificationController>().unreadCount.value;
                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              () => const NotificationScreen(),
                              transition: Transition.rightToLeft,
                            );
                          },
                          child: Icon(Icons.notifications_outlined),
                        ),
                        if (unread > 0)
                          Positioned(
                            right: 0,
                            top: -4,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$unread',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CustomerProfileScreen(),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
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
          /// Title and Icon
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 14, color: Colors.white60),
                ),
              ),
              Icon(icon, color: Colors.white54),
            ],
          ),
          const SizedBox(height: 12),

          /// Value
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 6),

          /// Subtitle or progress bar
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
                  backgroundColor: Colors.grey,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.white70,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 10),
          SizedBox(
            height: 30,
            width: double.infinity,
            child: CustomPaint(
              painter: _FakeGraphPainter(),
            ), // Optional: replace with actual chart
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
          /// Header
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

          /// Metrics
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

          /// Chart
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
                      getTitlesWidget:
                          (value, _) => Text(
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
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  getDrawingHorizontalLine:
                      (_) => FlLine(color: Colors.white10, strokeWidth: 0.5),
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
          style: const TextStyle(color: Colors.white60, fontSize: 13),
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
          /// Left: Title and Value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white60, fontSize: 13),
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

          /// Right: Change Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color:
                  isIncrease
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

/// Simulated mini graph for visual appeal
class _FakeGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Color(0xff0262f7)
          ..strokeWidth = 2;

    final path = Path();
    path.moveTo(0, size.height * 0.6);
    for (int i = 1; i < size.width.toInt(); i += 10) {
      path.lineTo(i.toDouble(), size.height * (0.5 + 0.1 * (i % 3)));
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
