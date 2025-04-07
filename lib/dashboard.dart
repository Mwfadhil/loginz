import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class GreenhouseDashboard extends StatefulWidget {
  const GreenhouseDashboard({super.key});

  @override
  State<GreenhouseDashboard> createState() => _GreenhouseDashboardState();
}

class _GreenhouseDashboardState extends State<GreenhouseDashboard> {
  // Example sensor data (replace with real data from Node-RED or Firebase)
  double temperature = 28.5;
  double humidity = 65.0;
  double soilMoisture = 40.0;
  double lightIntensity = 320.0;

  bool irrigationOn = false;
  bool fanOn = false;
  bool lightsOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Greenhouse Admin"),
              accountEmail: Text("admin@greenhouse.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.eco, size: 40, color: Colors.green),
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Greenhouse Dashboard"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Live Sensor Data", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SensorCard(title: "Temperature", value: "$temperature°C", icon: Icons.thermostat),
                SensorCard(title: "Humidity", value: "$humidity%", icon: Icons.water_drop),
                SensorCard(title: "Soil Moisture", value: "$soilMoisture%", icon: Icons.grass),
                SensorCard(title: "Light Intensity", value: "$lightIntensity lx", icon: Icons.light_mode),
              ],
            ),
            SizedBox(height: 20),
            Text("System Controls", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ControlSwitch(title: "Irrigation", icon: Icons.water, value: irrigationOn, onChanged: (val) {
                  setState(() => irrigationOn = val);
                }),
                ControlSwitch(title: "Fan", icon: Icons.air, value: fanOn, onChanged: (val) {
                  setState(() => fanOn = val);
                }),
                ControlSwitch(title: "Grow Lights", icon: Icons.lightbulb, value: lightsOn, onChanged: (val) {
                  setState(() => lightsOn = val);
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for Sensor Display
class SensorCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const SensorCard({super.key, required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.green),
              SizedBox(height: 10),
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(value, style: TextStyle(fontSize: 18, color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget for System Control Switches
class ControlSwitch extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool value;
  final Function(bool) onChanged;

  const ControlSwitch({super.key, required this.title, required this.icon, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              SizedBox(height: 10),
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Switch(value: value, onChanged: onChanged),
            ],
          ),
        ),
      ),
    );
  }
}
