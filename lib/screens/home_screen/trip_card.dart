import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:oyatest/models/trip.dart';
import 'package:oyatest/screens/add_detail_bottom_sheet.dart';
import 'package:oyatest/services/firestore.dart';

class TripCard extends StatelessWidget {
  final Trip trip;
  const TripCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => AddDetailsBottomSheet(trip: trip),
        );
      },
      child: Container(
        height: 220,
        margin: const EdgeInsets.only(bottom: 25),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(.09),
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          topSection(context),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 12, bottom: 8),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  labeledText(label: "Departure: ", text: trip.startLocation!),
                  const SizedBox(height: 8),
                  labeledText(label: "Transport: ", text: trip.transportMode!),
                  const SizedBox(height: 8),
                  labeledText(label: "Distance: ", text: '${trip.distance}km'),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: labeledText(
                      label: "Price: ",
                      text: "₵${trip.expense}",
                      isPrice: true,
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }

  //--------------------------------------------------------------------------------------------
  Text labeledText(
      {required String label, required String text, isPrice = false}) {
    return Text.rich(
      TextSpan(
        text: label,
        style: TextStyle(
          fontSize: isPrice ? 14 : 16,
          color: Colors.grey.shade800,
        ),
        children: [
          TextSpan(
            text: text,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isPrice ? Colors.red.shade800 : const Color(0xFF1D1D1D)),
          ),
        ],
      ),
    );
  }

  //--------------------------------------------------------------------------------------------
  Padding topSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 7),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Trip to ${trip.destination}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D1D1D)),
                ),
                Text(
                  "on ${formatDate(trip.date!, [D, ', ', dd, ' ', MM])}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.red.shade800,
                  ),
                )
              ],
            ),
          ),
          IconButton(
              onPressed: () async {
                try {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text("Deleting trip."),
                  ));
                  await Firestore.i.deleteTripApi(trip.id!);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Couldn't delete, try again"),
                    ),
                  );
                }
              },
              icon: const Icon(
                Icons.delete_rounded,
                color: Colors.red,
              ))
        ],
      ),
    );
  }
}
