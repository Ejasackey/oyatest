import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:oyatest/models/trip.dart';
import 'package:oyatest/services/firestore.dart';
import 'package:oyatest/shared.dart';

// ignore: must_be_immutable
class AddDetailsBottomSheet extends StatefulWidget {
  Trip? trip;
  AddDetailsBottomSheet({super.key, this.trip});

  @override
  State<AddDetailsBottomSheet> createState() => _AddDetailsBottomSheetState();
}

class _AddDetailsBottomSheetState extends State<AddDetailsBottomSheet> {
  late Trip trip;
  bool isLoading = false;
  bool isError = false;
  String errorMsg = "";
  List<String> places = [
    'Accra',
    'Kumasi',
    'Cape Coast',
    'Sunyani',
    'Techiman',
    'Goaso',
    'Koforidua',
    'Tamale',
    'Wa',
    'Ho',
    'Takoradi',
  ];
  List<int> distances = [212, 146, 87, 342, 254, 98, 122];
  List<int> prices = [80, 100, 120, 75, 2000, 1222, 220, 321];
  Random rand = Random();

  @override
  void initState() {
    super.initState();
    if (widget.trip == null) {
      trip = Trip();
    } else {
      trip = widget.trip!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              height: 5,
              width: 38,
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(20)),
            ),
            const Text(
              "Plan a trip",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1D1D1D)),
            ),
            const SizedBox(height: 15),
            datePicker(context),
            const SizedBox(height: 12),
            placeSelector(isDestination: true),
            const SizedBox(height: 12),
            placeSelector(),
            const SizedBox(height: 12),
            transportSelector(),
            const SizedBox(height: 12),
            distanceAndPrice(),
            const SizedBox(height: 5),
            if (isError)
              const Text(
                "Please complete all fields",
                style: TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),
            actionButton(
                text: widget.trip == null ? "Create trip" : "Update trip",
                isLoading: isLoading,
                onPressed: () async {
                  setState(() => isLoading = true);
                  try {
                    if (trip.isCompletelyFilled()) {
                      if (widget.trip == null) {
                        trip.createdAt = DateTime.now();
                        await Firestore.i.createTripApi(trip);
                      } else {
                        await Firestore.i.updateTripApi(trip);
                      }
                      Navigator.of(context).pop();
                    } else {
                      throw "Please complete all fields.";
                    }
                  } catch (e) {
                    errorMsg = e.toString();
                    setState(() => isError = true);
                  }
                  setState(() => isLoading = false);
                }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  //--------------------------------------------------------------------------------------------
  distanceAndPrice() {
    return fieldContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(
            TextSpan(
              text: 'Distance: ',
              children: [
                TextSpan(
                    text: '${trip.distance ?? "_"}km',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ))
              ],
            ),
            style: const TextStyle(fontSize: 16),
          ),
          Text.rich(
            TextSpan(
              text: 'Price: ',
              children: [
                TextSpan(
                  text: '₵${trip.expense}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade800,
                  ),
                )
              ],
            ),
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  //--------------------------------------------------------------------------------------------
  transportSelector() {
    return fieldContainer(
        child: Row(
      children: [
        if (trip.transportMode != null)
          const Text(
            "By: ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        Expanded(
          child: DropdownButton(
            value: trip.transportMode,
            isExpanded: true,
            borderRadius: BorderRadius.circular(15),
            iconEnabledColor: Colors.red.shade800,
            underline: const SizedBox.shrink(),
            hint: const Text("Choose transportation"),
            items: ['Bus', 'Train', 'Plane']
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ),
                )
                .toList(),
            onChanged: (newVal) {
              trip.transportMode = newVal;
              if (trip.transportMode != null &&
                  trip.destination != null &&
                  trip.startLocation != null) {
                trip.expense = prices[rand.nextInt(8)];
              }
              setState(() {});
            },
          ),
        ),
      ],
    ));
  }

  //--------------------------------------------------------------------------------------------
  fieldContainer({required Widget child}) {
    return Container(
      height: 55,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: child,
    );
  }

  //--------------------------------------------------------------------------------------------
  Container placeSelector({bool isDestination = false}) {
    return fieldContainer(
      child: Row(
        children: [
          if (isDestination && trip.destination != null ||
              !isDestination && trip.startLocation != null)
            Text(
              isDestination ? "To: " : "From: ",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          Expanded(
            child: DropdownButton<String>(
              value: isDestination ? trip.destination : trip.startLocation,
              underline: const SizedBox.shrink(),
              borderRadius: BorderRadius.circular(15),
              isExpanded: true,
              iconEnabledColor: Colors.red.shade800,
              hint: Text(isDestination ? "Where to?" : "From where?"),
              items: places
                  .map((e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (e) {
                if (isDestination && e != trip.startLocation) {
                  trip.destination = e;
                } else if (!isDestination && e != trip.destination) {
                  trip.startLocation = e;
                }
                if (trip.destination != null && trip.startLocation != null) {
                  trip.distance = distances[rand.nextInt(7)];
                }
                if (trip.transportMode != null &&
                    trip.destination != null &&
                    trip.startLocation != null) {
                  trip.expense = prices[rand.nextInt(8)];
                }
                setState(() {});
              },
            ),
          )
        ],
      ),
    );
  }

  //--------------------------------------------------------------------------------------------
  GestureDetector datePicker(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          DateTime? tempDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 1000)),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    datePickerTheme: DatePickerThemeData(
                      backgroundColor: Colors.white,
                      surfaceTintColor: Colors.white,
                      headerBackgroundColor: Colors.red.shade800,
                      headerForegroundColor: Colors.white,
                      dayOverlayColor: MaterialStateProperty.all(
                        Colors.red.shade800.withOpacity(.1),
                      ),
                    ),
                  ),
                  child: child!,
                );
              });
          if (tempDate != null) {
            trip.date = tempDate;
            setState(() {});
          }
        },
        child: fieldContainer(
          child: Text(
            trip.date == null
                ? "When will it be?"
                : "Date: ${formatDate(trip.date!, [D, ', ', dd, " ", MM])}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: trip.date == null
                  ? Colors.grey.shade700
                  : const Color(0xFF1D1D1D),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ));
  }
}
