import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Example sensor values
  double temperature = 28.5;
  double humidity = 65.0;
  double soilMoisture = 40.0;
  double lightIntensity = 320.0;

  bool irrigationOn = false;

  // Firebase Realtime Database reference
  final DatabaseReference _sensorDataRef = FirebaseDatabase.instance.ref('sensorData');

  @override
  void initState() {
    super.initState();
    // Fetch sensor data from Firebase
    _sensorDataRef.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        setState(() {
          temperature = data['temperature'] ?? 28.5;
          humidity = data['humidity'] ?? 65.0;
          soilMoisture = data['soilMoisture'] ?? 40.0;
          lightIntensity = data['lightIntensity'] ?? 320.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("Live Sensor Data"),
            _buildSensorGrid(),
            const SizedBox(height: 24),

            _buildSectionHeader("Temperature Trend"),
            _buildLineChart([
              FlSpot(0, temperature), // Update with live data
              FlSpot(1, temperature - 0.5), // Dummy trend
              FlSpot(2, temperature + 1), // Dummy trend
            ], '°C', Colors.red),

            _buildSectionHeader("Humidity Trend"),
            _buildLineChart([
              FlSpot(0, humidity),
              FlSpot(1, humidity + 1),
              FlSpot(2, humidity - 2),
            ], '%', Colors.blue),

            _buildSectionHeader("Soil Moisture Trend"),
            _buildLineChart([
              FlSpot(0, soilMoisture),
              FlSpot(1, soilMoisture + 2),
              FlSpot(2, soilMoisture - 1),
            ], '%', Colors.brown),

            _buildSectionHeader("Light Intensity Trend"),
            _buildLineChart([
              FlSpot(0, lightIntensity),
              FlSpot(1, lightIntensity + 5),
              FlSpot(2, lightIntensity - 5),
            ], 'lx', Colors.amber),

            const SizedBox(height: 24),
            _buildSectionHeader("System Controls"),
            _buildIrrigationControl(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.green[700]),
            accountName: const Text("Admin"),
            accountEmail: const Text("admin@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.dashboard, size: 40, color: Colors.green[700]),
            ),
          ),
          ListTile(leading: const Icon(Icons.dashboard), title: const Text('Dashboard')),
          ListTile(leading: const Icon(Icons.history), title: const Text('Historical Data')),
          const Divider(),
          ListTile(leading: const Icon(Icons.settings), title: const Text('Settings')),
          ListTile(leading: const Icon(Icons.help), title: const Text('Help')),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("Dashboard"),
      backgroundColor: Colors.green[700],
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              // Force update of data
            });
          },
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSensorGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildSensorCard("Temperature", "$temperature°C", Icons.thermostat, Colors.red),
        _buildSensorCard("Humidity", "$humidity%", Icons.water_drop, Colors.blue),
        _buildSensorCard("Soil Moisture", "$soilMoisture%", Icons.grass, Colors.brown),
        _buildSensorCard("Light Intensity", "$lightIntensity lx", Icons.light_mode, Colors.amber),
      ],
    );
  }

  Widget _buildSensorCard(String title, String value, IconData icon, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 18, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart(List<FlSpot> spots, String unit, Color color) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minY: 0,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: color,
              barWidth: 3,
              belowBarData: BarAreaData(show: true, color: color.withOpacity(0.2)),
              dotData: FlDotData(show: true),
            )
          ],
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, _) => Text('${value.toInt()}:00', style: TextStyle(fontSize: 10)),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 10,
                getTitlesWidget: (value, _) => Text('${value.toInt()} $unit', style: TextStyle(fontSize: 10)),
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
        ),
      ),
    );
  }

  Widget _buildIrrigationControl() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.water, size: 36, color: Colors.green[700]),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                "Irrigation System",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Switch(
              value: irrigationOn,
              onChanged: (val) => setState(() => irrigationOn = val),
              activeColor: Colors.green[700],
            ),
          ],
        ),
      ),
    );
  }
}
