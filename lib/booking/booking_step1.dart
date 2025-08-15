import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:skymiles_app/booking/booking_step2.dart';
import 'package:skymiles_app/screens/home_page.dart';

class BookingStep1Page extends StatefulWidget {
  final Map<String, dynamic> flight; // API flight object
  final int passengers;
  final UserData user;

  const BookingStep1Page({
    Key? key,
    required this.flight,
    required this.passengers,
    required this.user,
  }) : super(key: key);

  @override
  _BookingStep1PageState createState() => _BookingStep1PageState();
}

class _BookingStep1PageState extends State<BookingStep1Page> {
  final _nameController = TextEditingController();
  final _passportController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedCountry = 'Singapore';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passportController.dispose();
    super.dispose();
  }

  int get totalPrice {
    final price = widget.flight['price'] ?? 0.0;
    return (price * widget.passengers).toInt();
  }

  String countryNameToCode(String name) {
    switch (name) {
      case 'Singapore':
        return 'SG';
      case 'Indonesia':
        return 'ID';
      case 'Malaysia':
        return 'MY';
      case 'Thailand':
        return 'TH';
      default:
        return 'SG';
    }
  }

  Future<void> _saveBooking() async {
    setState(() => _isSaving = true);

    final url = Uri.parse('http://<YOUR_SERVER_IP>:5000/bookings');

    // Create a JSON-safe flight map
    final flightData = {
      "airline": widget.flight['airline'].toString(),
      "from": widget.flight['from'].toString(),
      "to": widget.flight['to'].toString(),
      "departure":
          widget.flight['departure'] is DateTime
              ? (widget.flight['departure'] as DateTime).toIso8601String()
              : widget.flight['departure'].toString(),
      "arrival":
          widget.flight['arrival'] is DateTime
              ? (widget.flight['arrival'] as DateTime).toIso8601String()
              : widget.flight['arrival'].toString(),
      "price": widget.flight['price'].toString(),
      "flightNumber": widget.flight['flightNumber']?.toString() ?? '',
    };

    final body = {
      "user": widget.user.name,
      "email": widget.user.email,
      "flight": flightData,
      "passengers": widget.passengers,
      "passengerName": _nameController.text,
      "passportNumber": _passportController.text,
      "citizenship": countryNameToCode(_selectedCountry),
      "passportExpiry": _selectedDate?.toIso8601String(),
      "totalPrice": totalPrice,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Booking saved successfully!"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => ClassSelectionPage(
                  flight: widget.flight,
                  passengers: widget.passengers,
                  user: widget.user,
                ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${response.statusCode}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error connecting to server: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A2E35),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2E35),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Booking Process",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStepCircle("1", "Detail\nTraveler", true),
                _buildStepCircle("2", "Seating\nPlan", false),
                _buildStepCircle("3", "Choose\nSeat", false),
                _buildStepCircle("4", "Extra\nServices", false),
                _buildStepCircle("5", "Booking\nSummary", false),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              'Booking with ${widget.flight['airline']}',
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'From: ${widget.flight['from']} → To: ${widget.flight['to']}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Text(
              'Departure: ${widget.flight['departure']} - Arrival: ${widget.flight['arrival']}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Text(
              'Passengers: ${widget.passengers}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 20),
            const Text(
              "Passenger 1 Data",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildInputField("Fullname", _nameController),
            const SizedBox(height: 16),
            _buildDropdownField("Citizenship", _selectedCountry),
            const SizedBox(height: 16),
            _buildInputField("Passport Number", _passportController),
            const SizedBox(height: 16),
            _buildDatePickerField("Expiration Date"),
            const Spacer(),
            Text(
              'Total Price: \$${totalPrice}',
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFAF7A38),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed:
                  _isSaving
                      ? null
                      : () {
                        if (_nameController.text.isEmpty ||
                            _passportController.text.isEmpty ||
                            _selectedDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please fill all fields and select date.",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        _saveBooking();
                      },
              child:
                  _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Continue", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCircle(String number, String label, bool active) {
    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor:
              active ? const Color(0xFFAF7A38) : const Color(0xFF495057),
          child: Text(number, style: const TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFFBDC6C7)),
        filled: true,
        fillColor: const Color(0xFF3A3F47),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFAF7A38)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String value) {
    return DropdownButtonFormField<String>(
      value: value,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      dropdownColor: const Color(0xFF3A3F47),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFFBDC6C7)),
        filled: true,
        fillColor: const Color(0xFF3A3F47),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: (newValue) {
        if (newValue != null) setState(() => _selectedCountry = newValue);
      },
      items:
          ["Singapore", "Indonesia", "Malaysia", "Thailand"]
              .map(
                (country) =>
                    DropdownMenuItem(child: Text(country), value: country),
              )
              .toList(),
    );
  }

  Widget _buildDatePickerField(String label) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: Color(0xFFAF7A38),
                  onPrimary: Colors.white,
                  surface: Color(0xFF3A3F47),
                  onSurface: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) setState(() => _selectedDate = picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFFBDC6C7)),
          filled: true,
          fillColor: const Color(0xFF3A3F47),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDate == null
                  ? 'Select Date'
                  : DateFormat.yMMMMd().format(_selectedDate!),
              style: const TextStyle(color: Colors.white),
            ),
            const Icon(Icons.calendar_today, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
