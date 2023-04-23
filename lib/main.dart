import 'package:flutter/material.dart';
import 'package:p7_async/color_button.dart';
import 'package:p7_async/temp_bar.dart';
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
      title: 'Flutter p9 - Animation',
      theme: Provider.of<ThemeModel>(context).currentTheme,
      home: const MyHomePage(title: 'Flutter p9 - Animation'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _cityNameController = TextEditingController();
  String _weather = '';

  late AnimationController animationController;

  late final Animation<double> _sizeAnimation =
      Tween<double>(begin: 340, end: 170).animate(animationController);

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    super.initState();
  }

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

    if (animationController.isCompleted) {
      animationController.reverse();
    } else {
      animationController.forward();
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
            AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  return SizedBox(
                    width: _sizeAnimation.value,
                    child: TextField(
                      controller: _cityNameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter city name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  );
                }),
            const SizedBox(height: 16.0),
            // ElevatedButton(
            //   onPressed: _getWeather,
            //   child: const Text('Get Weather'),
            // ),
            ColorButton(controller: animationController, onPress: _getWeather),
            const SizedBox(height: 16.0),
            FutureBuilder(
              future: Weather.getWeather(_cityNameController.text),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Column(
                    children: [
                      Text(
                        snapshot.data ?? '',
                        style: const TextStyle(fontSize: 32.0),
                      ),
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Container(
                          child: TempBar.withSampleData(),
                        ),
                      ),
                    ],
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
