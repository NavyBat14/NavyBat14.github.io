import 'dart:math';
import 'package:flutter/material.dart';
import 'package:skymiles_app/booking/booking_step4.dart'; // ExtraServicesPage
import 'package:skymiles_app/screens/home_page.dart'; // UserData import

class SeatSelectionPage extends StatefulWidget {
  final Map<String, dynamic> flight;
  final Map<String, dynamic>? returnFlight; // optional return flight
  final String selectedClass;
  final int finalPrice;
  final int passengers;
  final UserData user;

  const SeatSelectionPage({
    super.key,
    required this.flight,
    required this.selectedClass,
    required this.finalPrice,
    required this.passengers,
    required this.user,
    this.returnFlight,
  });

  @override
  State<SeatSelectionPage> createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  String? selectedSeat;
  String? selectedReturnSeat;

  final List<String> economyColumns = ['A', 'B', 'C', 'D', 'E', 'F'];
  final List<String> firstClassColumns = ['A', 'B', 'E', 'F'];
  final List<int> seatRows = List.generate(20, (index) => index + 1);

  late List<String> unavailableSeats;
  late List<String> unavailableReturnSeats;

  @override
  void initState() {
    super.initState();
    final random = Random();

    final Set<String> tempSeats = {};
    while (tempSeats.length < 20) {
      int row = seatRows[random.nextInt(seatRows.length)];
      String col = economyColumns[random.nextInt(economyColumns.length)];
      tempSeats.add('$row$col');
    }
    unavailableSeats = tempSeats.toList();

    // Generate unavailable seats for return flight if exists
    if (widget.returnFlight != null) {
      final Set<String> tempReturnSeats = {};
      while (tempReturnSeats.length < 20) {
        int row = seatRows[random.nextInt(seatRows.length)];
        String col = economyColumns[random.nextInt(economyColumns.length)];
        tempReturnSeats.add('$row$col');
      }
      unavailableReturnSeats = tempReturnSeats.toList();
    }
  }

  Color getSeatColor(String seat, {bool isReturn = false}) {
    if (isReturn && selectedReturnSeat == seat) return const Color(0xFFFFD700);
    if (!isReturn && selectedSeat == seat) return const Color(0xFFFFD700);

    List<String> takenSeats =
        isReturn ? unavailableReturnSeats : unavailableSeats;
    if (takenSeats.contains(seat)) return Colors.grey.shade800;

    return const Color(0xFFE6CEA1);
  }

  Widget buildSeatRow(int row, {bool isReturn = false}) {
    bool isFirstClass = row <= 2;
    List<String> columns = isFirstClass ? firstClassColumns : economyColumns;

    List<String> left = columns.sublist(0, columns.length ~/ 2);
    List<String> right = columns.sublist(columns.length ~/ 2);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              '$row',
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFFBDC6C7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children:
                      left
                          .map(
                            (col) => seatButton('$row$col', isReturn: isReturn),
                          )
                          .toList(),
                ),
                const SizedBox(width: 24),
                Row(
                  children:
                      right
                          .map(
                            (col) => seatButton('$row$col', isReturn: isReturn),
                          )
                          .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget seatButton(String seatId, {bool isReturn = false}) {
    List<String> takenSeats =
        isReturn ? unavailableReturnSeats : unavailableSeats;
    String? currentSelected = isReturn ? selectedReturnSeat : selectedSeat;

    bool isTaken = takenSeats.contains(seatId);
    bool isSelected = currentSelected == seatId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap:
            isTaken
                ? null
                : () {
                  setState(() {
                    if (isReturn) {
                      selectedReturnSeat = seatId;
                    } else {
                      selectedSeat = seatId;
                    }
                  });
                },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient:
                isSelected
                    ? LinearGradient(
                      colors: [Colors.amber.shade400, Colors.orange.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                    : null,
            color:
                isSelected
                    ? null
                    : isTaken
                    ? Colors.grey.shade800
                    : const Color(0xFFE6CEA1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? Colors.white : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    isSelected
                        ? Colors.amber.withOpacity(0.6)
                        : Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child:
                isTaken
                    ? const Icon(Icons.close, size: 16, color: Colors.black45)
                    : null,
          ),
        ),
      ),
    );
  }

  Widget buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        legendItem(Colors.grey.shade800, 'Taken'),
        legendItem(const Color(0xFFE6CEA1), 'Available'),
        legendItem(const Color(0xFFFFD700), 'Selected'),
      ],
    );
  }

  Widget legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final flight = widget.flight;
    final returnFlight = widget.returnFlight;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1F26),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: Column(
          children: [
            const Text(
              'Select Your Seat',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              '${flight['from']} → ${flight['to']}',
              style: const TextStyle(fontSize: 14, color: Color(0xFFBDC6C7)),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            '${widget.selectedClass} Class',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amberAccent,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: InteractiveViewer(
              boundaryMargin: const EdgeInsets.all(24),
              minScale: 1,
              maxScale: 2.5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    ...seatRows.map((row) {
                      if (row == 10) {
                        return Column(
                          children: [
                            const SizedBox(height: 12),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.exit_to_app,
                                  color: Colors.orange,
                                  size: 20,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Exit Row',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            buildSeatRow(row),
                          ],
                        );
                      }
                      return buildSeatRow(row);
                    }).toList(),
                    const SizedBox(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wc, color: Colors.blueGrey, size: 20),
                        SizedBox(width: 6),
                        Text(
                          'Lavatory',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: buildLegend(),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900.withOpacity(0.85),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 12,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  selectedSeat != null
                      ? 'Selected Seat: $selectedSeat'
                      : 'No Seat Selected',
                  style: const TextStyle(
                    color: Colors.amberAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      selectedSeat == null
                          ? null
                          : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ExtraServicesPage(
                                      flight: flight,
                                      selectedSeat: selectedSeat!,
                                      selectedClass: widget.selectedClass,
                                      price: widget.finalPrice,
                                      passengers: widget.passengers,
                                      user: widget.user,
                                      returnFlight:
                                          returnFlight, // Pass return flight
                                      onBookingComplete: (earnedMiles) {},
                                    ),
                              ),
                            );
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    disabledBackgroundColor: Colors.grey.shade700,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                    shadowColor: Colors.amberAccent.withOpacity(0.6),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
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
