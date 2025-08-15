import 'package:flutter/material.dart';
import 'package:skymiles_app/Profile/add_payment.dart';

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cardData = [
      {
        'type': 'Visa',
        'number': '**** 4242',
        'name': 'Alex Johnson',
        'expiry': '05/25',
        'default': true,
        'iconUrl':
            'https://upload.wikimedia.org/wikipedia/commons/5/5e/Visa_Inc._logo.svg',
      },
      {
        'type': 'Visa',
        'number': '**** 7332',
        'name': 'Alex Johnson',
        'expiry': '07/27',
        'default': false,
        'iconUrl':
            'https://upload.wikimedia.org/wikipedia/commons/5/5e/Visa_Inc._logo.svg',
      },
      {
        'type': 'Master Card',
        'number': '**** 7327',
        'name': 'Alex Johnson',
        'expiry': '03/26',
        'default': false,
        'iconUrl':
            'https://upload.wikimedia.org/wikipedia/commons/0/04/Mastercard-logo.png',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1E1F23),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Payment Methods',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Cards',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...cardData.map((card) => _buildCardTile(context, card)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddPaymentMethodPage(),
                  ),
                );
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add New Payment Method'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFAF7A38),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                shadowColor: Colors.black54,
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Your payment information is securely stored and encrypted.',
                style: TextStyle(color: Colors.white60, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardTile(BuildContext context, Map<String, dynamic> card) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.02),
            Colors.white.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.network(
                card['iconUrl'],
                height: 28,
                width: 48,
                color: Colors.white,
                colorBlendMode: BlendMode.srcIn,
                errorBuilder:
                    (_, __, ___) =>
                        const Icon(Icons.credit_card, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${card['type']} ending in ${card['number'].toString().substring(card['number'].toString().length - 4)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              if (card['default'] == true)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFAF7A38),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Default',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Name on Card',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              Text(
                card['name'],
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Expires',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              Text(
                card['expiry'],
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Edit',
                  style: TextStyle(color: Color(0xFFAF7A38)),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Remove',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
