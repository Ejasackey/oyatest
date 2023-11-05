import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oyatest/models/trip.dart';

class Firestore {
  Firestore._();
  static final Firestore _instance = Firestore._();
  static Firestore get i => _instance;

  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  CollectionReference tripsCol = firebaseFirestore.collection('trips');

  createTripApi(Trip trip) async {
    try {
      await tripsCol.add(trip.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Trip>> getTripsApi() {
    try {
      Stream<QuerySnapshot> snaps =
          tripsCol.orderBy("date", descending: true).snapshots();
      return snaps.map((e) => e.docs
          .map((e) => Trip.fromMap(e.data() as Map<String, dynamic>, e.id))
          .toList());
    } catch (e) {
      rethrow;
    }
  }

  updateTripApi(Trip trip) async {
    try {
      await tripsCol.doc(trip.id).update(trip.toMap());
    } catch (e) {
      rethrow;
    }
  }

  deleteTripApi(String id) async {
    try {
      await tripsCol.doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }
}
