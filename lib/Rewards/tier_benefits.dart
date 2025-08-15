import 'package:flutter/material.dart';

class TierBenefitsPage extends StatelessWidget {
  const TierBenefitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2228),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Tier Benefits',
          style: TextStyle(
            color: Color(0xFFE6CEA1),
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tier Benefits Comparison',
              style: TextStyle(
                color: Color(0xFFE6CEA1),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(
                    const Color(0xFF2A2E35),
                  ),
                  dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                    (states) => const Color(0xFF3A3F47),
                  ),
                  headingTextStyle: const TextStyle(
                    color: Color(0xFFE6CEA1),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  dataTextStyle: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                  columns: const [
                    DataColumn(label: Text('Benefit')),
                    DataColumn(label: Text('Bronze')),
                    DataColumn(label: Text('Silver')),
                    DataColumn(label: Text('Gold')),
                    DataColumn(label: Text('Platinum')),
                  ],
                  rows: [
                    _buildRow('Bonus Miles', ['10%', '25%', '50%', '100%']),
                    _buildRow('Priority Check-in', ['✓', '✓', '✓', '✓']),
                    _buildRow('Priority Boarding', ['-', '-', '✓', '✓']),
                    _buildRow('Free Checked Bag', [
                      '-',
                      '1 Bag',
                      '2 Bags',
                      '3 Bags',
                    ]),
                    _buildRow('Lounge Access', [
                      '-',
                      '-',
                      '2/year',
                      'Unlimited',
                    ]),
                    _buildRow('Upgrade Priority', [
                      '-',
                      'Low',
                      'Medium',
                      'High',
                    ]),
                    _buildRow('Companion Ticket', ['-', '-', '-', '1/year']),
                    _buildRow('Dedicated Support', ['-', '-', '✓', '✓']),
                  ],
                  dividerThickness: 1.5,
                  showBottomBorder: true,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.03),
                    Colors.white.withOpacity(0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'How to Earn More Miles',
                    style: TextStyle(
                      color: Color(0xFFE6CEA1),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Book flights, refer friends, and participate in special promotions to earn more miles and unlock higher tiers.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static DataRow _buildRow(String benefit, List<String> values) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            benefit,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        ...values.map(
          (v) =>
              DataCell(Text(v, style: const TextStyle(color: Colors.white70))),
        ),
      ],
    );
  }
}
