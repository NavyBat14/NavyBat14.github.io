import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:skymiles_app/flights/flight_results.dart';
import 'package:skymiles_app/screens/home_page.dart';

class SearchScreen extends StatefulWidget {
  final UserData user;
  const SearchScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _fromCtrl = TextEditingController();
  final _toCtrl = TextEditingController();
  DateTime? _dep;
  DateTime? _returnDate;
  int _pax = 1;

  // Embedded airports for TypeAhead
  final List<Map<String, dynamic>> _airports = [
    {
      "name": "Hartsfield-Jackson Atlanta International Airport",
      "city": "Atlanta",
      "country": "United States",
      "iata": "ATL",
    },
    {
      "name": "Beijing Capital International Airport",
      "city": "Beijing",
      "country": "China",
      "iata": "PEK",
    },
    {
      "name": "Dubai International Airport",
      "city": "Dubai",
      "country": "UAE",
      "iata": "DXB",
    },
    {
      "name": "Tokyo Haneda Airport",
      "city": "Tokyo",
      "country": "Japan",
      "iata": "HND",
    },
    {
      "name": "Heathrow Airport",
      "city": "London",
      "country": "UK",
      "iata": "LHR",
    },
    {
      "name": "Charles de Gaulle Airport",
      "city": "Paris",
      "country": "France",
      "iata": "CDG",
    },
    {
      "name": "Los Angeles International Airport",
      "city": "Los Angeles",
      "country": "USA",
      "iata": "LAX",
    },
    {
      "name": "Singapore Changi Airport",
      "city": "Singapore",
      "country": "Singapore",
      "iata": "SIN",
    },
    {
      "name": "Frankfurt am Main Airport",
      "city": "Frankfurt",
      "country": "Germany",
      "iata": "FRA",
    },
    {
      "name": "Sydney Kingsford Smith Airport",
      "city": "Sydney",
      "country": "Australia",
      "iata": "SYD",
    },
  ];

  // Amadeus API credentials
  final String clientId = 'ZdiTmC4FGK58LaXJ7btLJpDliyPe0hLm';
  final String clientSecret = '9a5h9rBqtx1mAZmL';
  String? _accessToken;

  Future<void> _authenticateAmadeus() async {
    final response = await http.post(
      Uri.parse('https://test.api.amadeus.com/v1/security/oauth2/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'client_credentials',
        'client_id': clientId,
        'client_secret': clientSecret,
      },
    );
    if (response.statusCode == 200) {
      _accessToken = json.decode(response.body)['access_token'];
    } else {
      throw Exception('Failed to authenticate Amadeus API');
    }
  }

  Future<List<Map<String, dynamic>>> _fetchFlights() async {
    if (_dep == null) throw Exception('Departure date required');
    if (_accessToken == null) await _authenticateAmadeus();

    final params = {
      'originLocationCode': _fromCtrl.text,
      'destinationLocationCode': _toCtrl.text,
      'departureDate': DateFormat('yyyy-MM-dd').format(_dep!),
      'adults': _pax.toString(),
      'max': '10',
      if (_returnDate != null)
        'returnDate': DateFormat('yyyy-MM-dd').format(_returnDate!),
    };

    final uri = Uri.https(
      'test.api.amadeus.com',
      '/v2/shopping/flight-offers',
      params,
    );
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $_accessToken'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] ?? [];
      return data.map<Map<String, dynamic>>((f) {
        final offer = f['itineraries'][0]['segments'][0];
        return {
          'airline': offer['carrierCode'] ?? 'Unknown',
          'flightNumber': offer['number'] ?? '',
          'from': offer['departure']['iataCode'],
          'to': offer['arrival']['iataCode'],
          'departure': DateTime.parse(offer['departure']['at']),
          'arrival': DateTime.parse(offer['arrival']['at']),
          'price':
              double.tryParse(f['price']['grandTotal']?.toString() ?? '0') ??
              0.0,
        };
      }).toList();
    } else {
      throw Exception('Failed to fetch flights: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> _filterAirports(String q) async {
    final ql = q.toLowerCase();
    return _airports
        .where(
          (a) => a.values.any((v) => v.toString().toLowerCase().contains(ql)),
        )
        .toList();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dep ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder:
          (context, child) => Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFFD4AF37),
                onPrimary: Colors.black,
                surface: Color(0xFF1E1E2A),
                onSurface: Colors.white,
              ),
            ),
            child: child!,
          ),
    );
    if (picked != null) setState(() => _dep = picked);
  }

  Future<void> _pickReturnDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _returnDate ?? (_dep ?? DateTime.now()).add(const Duration(days: 1)),
      firstDate: _dep ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder:
          (context, child) => Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFFD4AF37),
                onPrimary: Colors.black,
                surface: Color(0xFF1E1E2A),
                onSurface: Colors.white,
              ),
            ),
            child: child!,
          ),
    );
    if (picked != null) setState(() => _returnDate = picked);
  }

  void _search() async {
    if (_fromCtrl.text.isEmpty || _toCtrl.text.isEmpty || _dep == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Fill all required fields')));
      return;
    }
    if (_fromCtrl.text == _toCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('From and To cannot be the same')),
      );
      return;
    }
    try {
      final flights = await _fetchFlights();
      if (flights.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No flights found')));
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => FlightResultsScreen(
                from: _fromCtrl.text,
                to: _toCtrl.text,
                departureDate: _dep!,
                passengers: _pax,
                flights: flights,
                user: widget.user,
                returnDate: _returnDate, // NEW
              ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching flights: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ts = TextStyle(
      color: Colors.amber.shade200,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    );
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Search Flights',
          style: TextStyle(
            color: Colors.amber.shade300,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            _buildGlassField('From', _fromCtrl, ts),
            const SizedBox(height: 16),
            _buildGlassField('To', _toCtrl, ts),
            const SizedBox(height: 24),
            Text('Departure Date', style: ts),
            const SizedBox(height: 8),
            _buildGlassButton(
              text:
                  _dep == null
                      ? 'Select Departure'
                      : DateFormat('yyyy-MM-dd').format(_dep!),
              onPressed: _pickDate,
            ),
            const SizedBox(height: 16),
            Text('Return Date (optional)', style: ts),
            const SizedBox(height: 8),
            _buildGlassButton(
              text:
                  _returnDate == null
                      ? 'Select Return'
                      : DateFormat('yyyy-MM-dd').format(_returnDate!),
              onPressed: _pickReturnDate,
            ),
            const SizedBox(height: 32),
            Center(
              child: _buildGlassButton(
                text: 'Search Flights',
                onPressed: _search,
                color: const Color(0xFFD4AF37),
                textColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
                glow: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassField(
    String label,
    TextEditingController ctrl,
    TextStyle ts,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: ts),
        const SizedBox(height: 8),
        TypeAheadFormField<Map<String, dynamic>>(
          textFieldConfiguration: TextFieldConfiguration(
            controller: ctrl,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter $label',
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
          suggestionsCallback: _filterAirports,
          itemBuilder:
              (_, s) => ListTile(
                title: Text(
                  '${s['name']} (${s['iata']})',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
          onSuggestionSelected: (s) => ctrl.text = s['iata'],
          noItemsFoundBuilder:
              (_) => const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'No airports found',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
        ),
      ],
    );
  }

  Widget _buildGlassButton({
    required String text,
    required VoidCallback onPressed,
    Color color = const Color(0xFF1E1E2A),
    Color textColor = Colors.white,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      vertical: 14,
      horizontal: 24,
    ),
    bool glow = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: glow ? Colors.amber.shade200 : Colors.transparent,
            width: 1.5,
          ),
          boxShadow:
              glow
                  ? [
                    BoxShadow(
                      color: Colors.yellow.withOpacity(0.6),
                      blurRadius: 16,
                      spreadRadius: 1,
                      offset: const Offset(0, 6),
                    ),
                  ]
                  : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
          gradient:
              glow
                  ? null
                  : const LinearGradient(
                    colors: [Color(0xFF1E1E2A), Color(0xFF0A0A0F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
