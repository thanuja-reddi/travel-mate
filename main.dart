import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

void main() => runApp(const TravelMateApp());

class TravelMateApp extends StatelessWidget {
  const TravelMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TravelMate Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const SplashScreen(),
    );
  }
}

// ---------------- Splash Screen ----------------

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TravelHome()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.travel_explore, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              "TravelMate Pro",
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- Home ----------------

class TravelHome extends StatefulWidget {
  const TravelHome({super.key});

  @override
  State<TravelHome> createState() => _TravelHomeState();
}

class _TravelHomeState extends State<TravelHome> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> journeys = [];
  final List<Map<String, dynamic>> favorites = [];

  // ---------- DATA ----------
  final List<Map<String, dynamic>> flightsData = [
    {'name': 'IndiGo 6E-203', 'price': '₹4,500'},
    {'name': 'Air India AI-202', 'price': '₹5,200'},
    {'name': 'Vistara UK-721', 'price': '₹4,800'},
    {'name': 'SpiceJet SJ-405', 'price': '₹4,000'},
  ];

  final List<Map<String, dynamic>> trainsData = [
    {'name': 'Rajdhani Express', 'price': '₹1,200'},
    {'name': 'Shatabdi Express', 'price': '₹1,000'},
    {'name': 'Duronto Express', 'price': '₹1,400'},
    {'name': 'Tejas Express', 'price': '₹1,800'},
  ];

  final List<Map<String, dynamic>> hotels = [
    {
      'name': 'The Leela Palace, Udaipur',
      'image':
          'https://images.pexels.com/photos/1796724/pexels-photo-1796724.jpeg?auto=compress&cs=tinysrgb&w=800',
      'price': '₹15,000 / night'
    },
    {
      'name': 'Taj Lake Palace, Udaipur',
      'image':
          'https://images.pexels.com/photos/261102/pexels-photo-261102.jpeg?auto=compress&cs=tinysrgb&w=800',
      'price': '₹20,000 / night'
    },
  ];

  // ✅ UPDATED ATTRACTION IMAGES (from your Pexels links)
  final List<Map<String, dynamic>> attractions = [
    {
      'name': 'India Gate - Delhi',
      'desc':
          'Iconic war memorial and one of Delhi’s most visited tourist spots.',
      'image':
          'https://images.pexels.com/photos/789750/pexels-photo-789750.jpeg?auto=compress&cs=tinysrgb&w=800'
    },
    {
      'name': 'Taj Mahal - Agra',
      'desc':
          'One of the Seven Wonders of the World, symbol of eternal love and Mughal architecture.',
      'image':
          'https://images.pexels.com/photos/1603650/pexels-photo-1603650.jpeg?auto=compress&cs=tinysrgb&w=800'
    },
    {
      'name': 'Golden Temple - Amritsar',
      'desc':
          'The holiest Gurdwara of Sikhism, famous for its shimmering golden dome.',
      'image':
          'https://images.pexels.com/photos/5499899/pexels-photo-5499899.jpeg?auto=compress&cs=tinysrgb&w=800'
    },
  ];

  // ---------- SELECTIONS ----------
  String? flightFrom;
  String? flightTo;
  bool flightSearched = false;

  String? trainFrom;
  String? trainTo;
  bool trainSearched = false;

  // ---------- HANDLERS ----------
  void _onBook(Map<String, dynamic> item, String type, String details) {
    setState(() => journeys.add({
          'type': type,
          'name': item['name'],
          'details': details
        }));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$type booked successfully!')),
    );
  }

  void _onFavorite(Map<String, dynamic> item) {
    setState(() {
      if (favorites.contains(item)) {
        favorites.remove(item);
      } else {
        favorites.add(item);
      }
    });
  }

  // ---------- CARD BUILDER ----------
  Widget _buildCard(Map<String, dynamic> item, String type) {
    bool isFav = favorites.contains(item);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item['image'] != null)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: Image.network(
                item['image'],
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: const Center(
                      child: Icon(Icons.broken_image,
                          size: 40, color: Colors.grey)),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(item['name'],
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          if (item['desc'] != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(item['desc'],
                  style: const TextStyle(color: Colors.black54, fontSize: 13)),
            ),
          if (item['price'] != null)
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 5, top: 4),
              child: Text(item['price'], style: const TextStyle(fontSize: 14)),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: Colors.pinkAccent),
                  onPressed: () => _onFavorite(item)),
              Padding(
                padding: const EdgeInsets.only(right: 8.0, bottom: 8),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onPressed: () => _openBookingDialog(item, type),
                    child: const Text("Book")),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- BOOKING DIALOG ----------
  void _openBookingDialog(Map<String, dynamic> item, String type) {
    int members = 1;
    String selectedClass =
        (type == 'Flight') ? 'Economy' : (type == 'Train') ? 'Sleeper' : '';
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Book $type'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (type == 'Flight' || type == 'Train')
                  DropdownButton<String>(
                    value: selectedClass,
                    items: (type == 'Flight'
                            ? ['Economy', 'Business']
                            : ['Sleeper', 'Second AC', 'First AC'])
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => selectedClass = v!),
                  ),
                if (type == 'Hotel' || type == 'Attraction')
                  ElevatedButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2026),
                      );
                      if (date != null) setState(() => selectedDate = date);
                    },
                    child: Text(selectedDate == null
                        ? 'Select Date'
                        : DateFormat.yMMMd().format(selectedDate!)),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Members:'),
                    Expanded(
                      child: Slider(
                        value: members.toDouble(),
                        min: 1,
                        max: 10,
                        divisions: 9,
                        label: '$members',
                        onChanged: (v) => setState(() => members = v.toInt()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  final dateText = selectedDate != null
                      ? ' on ${DateFormat.yMMMd().format(selectedDate!)}'
                      : '';
                  final detail =
                      '$type | Class: $selectedClass | Members: $members$dateText';
                  _onBook(item, type, detail);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text('Confirm')),
          ],
        ),
      ),
    );
  }

  // ---------- TABS ----------
  Widget _buildFlights() {
    final cities = [
      'Delhi',
      'Mumbai',
      'Chennai',
      'Hyderabad',
      'Kolkata',
      'Jaipur',
      'Bangalore'
    ];
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton<String>(
                hint: const Text("From"),
                value: flightFrom,
                items: cities
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => flightFrom = v),
              ),
              DropdownButton<String>(
                hint: const Text("To"),
                value: flightTo,
                items: cities
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => flightTo = v),
              ),
              ElevatedButton(
                onPressed: () => setState(() => flightSearched = true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text("Search"),
              ),
            ],
          ),
          if (flightSearched)
            ...flightsData.map((e) => _buildCard(e, 'Flight')).toList(),
        ],
      ),
    );
  }

  Widget _buildTrains() {
    final cities = [
      'Delhi',
      'Mumbai',
      'Chennai',
      'Hyderabad',
      'Kolkata',
      'Jaipur',
      'Bangalore'
    ];
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton<String>(
                hint: const Text("From"),
                value: trainFrom,
                items: cities
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => trainFrom = v),
              ),
              DropdownButton<String>(
                hint: const Text("To"),
                value: trainTo,
                items: cities
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => trainTo = v),
              ),
              ElevatedButton(
                onPressed: () => setState(() => trainSearched = true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text("Search"),
              ),
            ],
          ),
          if (trainSearched)
            ...trainsData.map((e) => _buildCard(e, 'Train')).toList(),
        ],
      ),
    );
  }

  Widget _buildJourneys() => journeys.isEmpty
      ? const Center(child: Text('No journeys booked yet.'))
      : ListView(
          children: journeys
              .map((j) => ListTile(
                    leading:
                        const Icon(Icons.check_circle, color: Colors.teal),
                    title: Text(j['name']),
                    subtitle: Text(j['details']),
                  ))
              .toList(),
        );

  Widget _buildFavorites() => favorites.isEmpty
      ? const Center(child: Text('No favorites yet.'))
      : ListView(
          children: favorites
              .map((f) => ListTile(
                    leading: const Icon(Icons.favorite,
                        color: Colors.pinkAccent),
                    title: Text(f['name']),
                  ))
              .toList(),
        );

  @override
  Widget build(BuildContext context) {
    final tabs = [
      // ✅ NEW TAB ORDER: Attractions → Hotels → Flights → Trains → Journeys → Favorites
      SingleChildScrollView(
          child: Column(
              children:
                  attractions.map((e) => _buildCard(e, 'Attraction')).toList())),
      SingleChildScrollView(
          child:
              Column(children: hotels.map((e) => _buildCard(e, 'Hotel')).toList())),
      _buildFlights(),
      _buildTrains(),
      _buildJourneys(),
      _buildFavorites(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('TravelMate Pro'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.attractions), label: 'Attractions'),
          BottomNavigationBarItem(icon: Icon(Icons.hotel), label: 'Hotels'),
          BottomNavigationBarItem(icon: Icon(Icons.flight), label: 'Flights'),
          BottomNavigationBarItem(icon: Icon(Icons.train), label: 'Trains'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_added), label: 'Journeys'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
      ),
    );
  }
}

