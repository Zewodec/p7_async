import 'package:flutter/material.dart';
import 'package:p7_async/weather.dart';
import 'package:provider/provider.dart';

import 'ThemeModel.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter p7 - Async',
      theme: Provider.of<ThemeModel>(context).currentTheme,
      home: const MyHomePage(title: 'Flutter p7 - Async'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _cityNameController = TextEditingController();
  String _weather = '';

  void _getWeather() async {
    final cityName = _cityNameController.text;

    try {
      final weather = await Weather.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      setState(() {
        _weather = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter City',
              style: TextStyle(fontSize: 24.0),
            ),
            const SizedBox(height: 16.0),
            SizedBox(width: 340,
              child: TextField(
                controller: _cityNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter city name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _getWeather,
              child: const Text('Get Weather'),
            ),
            const SizedBox(height: 16.0),
            FutureBuilder(
              future: Weather.getWeather(_cityNameController.text),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text(
                    snapshot.data ?? '',
                    style: const TextStyle(fontSize: 32.0),
                  );
                }
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            SwitchListTile(
              title: const Text('Dark Theme'),
              value: Provider.of<ThemeModel>(context).isDarkTheme,
              onChanged: (value) {
                Provider.of<ThemeModel>(context, listen: false)
                    .toggleTheme(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
