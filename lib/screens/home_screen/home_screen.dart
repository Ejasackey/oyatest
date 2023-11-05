import 'package:flutter/material.dart';
import 'package:oyatest/screens/add_detail_bottom_sheet.dart';
import 'package:oyatest/screens/home_screen/trip_card.dart';
import 'package:oyatest/services/auth.dart';
import 'package:oyatest/services/firestore.dart';
import 'package:oyatest/shared.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      floatingActionButton: floatingActionButton(context),
      body: StreamBuilder(
        stream: Firestore.i.getTripsApi(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: Colors.red.shade800));
          } else if (snap.hasError) {
            return errorWidget();
          } else {
            if (snap.data!.isEmpty) {
              return const Center(
                  child: Text(
                "Tap + to create trip",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ));
            } else {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30)),
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 15, bottom: 50),
                  itemCount: snap.data!.length,
                  itemBuilder: (context, index) {
                    return TripCard(trip: snap.data![index]);
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }

  //--------------------------------------------------------------------------------------------
  Column errorWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Couldn't load trips",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 15),
        actionButton(
          text: "Reload",
          margin: 30,
          onPressed: () {
            setState(() {});
          },
        )
      ],
    );
  }

  //--------------------------------------------------------------------------------------------
  FloatingActionButton floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.red.shade800,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => AddDetailsBottomSheet(),
        );
      },
      child: const Icon(Icons.add_rounded, size: 30, color: Colors.white),
    );
  }

  //--------------------------------------------------------------------------------------------
  AppBar appBar() {
    return AppBar(
      title: const Text("OyaTest"),
      titleTextStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 23,
        color: Color(0xFF1D1D1D),
      ),
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text("Sign out"),
                onTap: () async {
                  try {
                    await Auth.i.signOut();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Couldn't sign out, try again")));
                  }
                },
              )
            ],
            icon: Icon(
              Icons.person,
              color: Colors.red.shade800,
            ),
          ),
        )
      ],
    );
  }
}
