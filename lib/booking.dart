class Booking {
  final String id;
  final String from;
  final String to;
  final String flightNumber;
  final String travelClass;
  final DateTime departure;
  final String seat;
  final double price;
  final String passengerName; // ✅ Added

  Booking({
    required this.id,
    required this.from,
    required this.to,
    required this.flightNumber,
    required this.travelClass,
    required this.departure,
    required this.seat,
    required this.price,
    required this.passengerName, // ✅ Added
  });
}
