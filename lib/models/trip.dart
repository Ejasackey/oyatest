import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  String? id;
  DateTime? date;
  String? startLocation;
  String? destination;
  String? transportMode;
  int? distance;
  int? expense;
  DateTime? createdAt;

  Trip({
    this.id,
    this.date,
    this.startLocation,
    this.destination,
    this.transportMode,
    this.distance = 0,
    this.expense = 0,
    this.createdAt,
  });

  isCompletelyFilled() {
    return date != null &&
        startLocation != null &&
        destination != null &&
        transportMode != null;
  }

  factory Trip.fromMap(Map<String, dynamic> map, String id) {
    return Trip(
      id: id,
      date: (map['date'] as Timestamp).toDate(),
      startLocation: map['startLocation'],
      destination: map['destination'],
      transportMode: map['transportMode'],
      distance: map['distance'],
      expense: map['expense'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  toMap() {
    return {
      'date': date,
      'startLocation': startLocation,
      'destination': destination,
      'transportMode': transportMode,
      'distance': distance,
      'expense': expense,
      'createdAt': createdAt,
    };
  }
}
