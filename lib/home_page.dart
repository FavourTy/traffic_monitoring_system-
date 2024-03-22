import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:traffic/histoory.dart';
import 'package:traffic/stylles/app_text_styles.dart';

//import 'network_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key,});
   

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isRefreshing = false;
  bool hasUpdatedData = false;
   int _selectedIndex = 0; 

  int previousReadId = 0;
  int numberOfRefreshes = 0;

  String trafficStatus = '';
  final String raspberryPiUrl = 'http://<RASPBERRY_PI_IP>:5000/traffic'; // to be Replaced <RASPBERRY_PI_IP> with your Raspberry Pi's IP address

  Future<void> getUpdatedInfo() async {
    setState(() {
      isRefreshing = true;
      hasUpdatedData = false;
    });

    try {
      final response = await http.get(Uri.parse(raspberryPiUrl));
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        setState(() {
          trafficStatus = result['status']; // Adjust this based on your Raspberry Pi's JSON response
          hasUpdatedData = true;
        });
      } else {
        throw Exception('Failed to load traffic status');
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching data: $e'),
        ),
      );
    } finally {
      setState(() {
        isRefreshing = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUpdatedInfo();
    Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        getUpdatedInfo();
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HistoryPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screensize = MediaQuery.of(context).size;
    final screenWidth = screensize.width;
    final screenHeight = screensize.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Traffic Monitoring System"),
        centerTitle: true,

      ),
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isRefreshing ? 1 : 0,
                child: Row(
                  children: [
                    const CupertinoActivityIndicator(),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Refreshing data',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(),
                    ),
                  ],
                ),
              ),
            Center(
            child: Image.asset('assets/car_location_1.png',
                height: 200,),

          ),
          Text( 'Location: Futa South gate',
          style: AppTextStyle.headerTextStyle(context),
          ),
          Center(
             child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Traffic Status',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 20),
                  ),
                  Text(
                    trafficStatus.isEmpty ? '...' : '$trafficStatus traffic',
                  ),
                  // Text(
                  //   'approx less than ${valueGotten.toString()} vehicles',
                  //   style: Theme.of(context).textTheme.headlineMedium,
                  // ),
                ],
              ),
          )
          ],
          
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
        currentIndex: _selectedIndex, // New
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped, // New
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:getUpdatedInfo,
      tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
