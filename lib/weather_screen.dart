import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:weather_app/additional_information_items.dart';
import 'package:weather_app/hourly_forecast_cards.dart';
import 'package:weather_app/main_box.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    // Replace this with your video asset path or network URL
    _videoPlayerController =
        VideoPlayerController.asset('assets/background_video.mp4');
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      showControls: false,
      playbackSpeeds: const [0.5],
      aspectRatio: MediaQuery.of(context).size.aspectRatio,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Mumbai';
      String myWeatherAPIKey = dotenv.env['myWeatherAPIKey'] ?? '';
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$myWeatherAPIKey',
        ),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'An unexpected error occured. Please try again later or try refreshing!';
      }
      return data;
      //data['list'][0]['main']['temp'] - 273.15;
    } catch (e) {
      throw e.toString();
    }
  }

  IconData _getWeatherIcon(String sky) {
    switch (sky.toLowerCase()) {
      case 'rain':
        return Icons.cloudy_snowing;
      case 'clouds':
        return Icons.cloud;
      case 'clear':
        return Icons.sunny;
      case 'thunderstorm':
        return Icons.thunderstorm;
      case 'drizzle':
        return Icons.grain;
      case 'snow':
        return Icons.snowing;
      default:
        return Icons.question_mark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Video Background
          if (_chewieController != null)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoPlayerController.value.size.width,
                  height: _videoPlayerController.value.size.height,
                  child: Chewie(controller: _chewieController!),
                ),
              ),
            ),

          // Main Content
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                floating: true,
                title: const Text(
                  'Weather App',
                  style: TextStyle(
                    fontFamily: 'Slabo',
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                    letterSpacing: 2,
                    wordSpacing: 2,
                  ),
                ),
                centerTitle: true,
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              weather = getCurrentWeather();
                            });
                          },
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: FutureBuilder(
                  future: weather,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        heightFactor: 20,
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: Colors.white,
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline_sharp,
                              size: 100,
                            ),
                            const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Text(
                                snapshot.error.toString(),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final data = snapshot.data!;
                    final currentWeatherData = data['list'][0];
                    final currentTemp =
                        currentWeatherData['main']['temp'] - 273.15;
                    final currentSky = currentWeatherData['weather'][0]['main'];
                    final currentPressure =
                        currentWeatherData['main']['pressure'];
                    final currentHumidity =
                        currentWeatherData['main']['humidity'];
                    final windSpeed = currentWeatherData['wind']['speed'];

                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 25),
                          // Main Card with transparency
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: SizedBox(
                              width: double.infinity,
                              child: Card(
                                color: theme.cardColor.withOpacity(0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 15,
                                child: MainBox(
                                  temp: '${currentTemp.toStringAsFixed(0)}°C',
                                  sky: '$currentSky',
                                  mainCardIcon: _getWeatherIcon(currentSky),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Hourly Forecast Card with transparency
                          Card(
                            color: theme.cardColor.withOpacity(0.5),
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hourly Forecast',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onSurface,
                                      fontFamily: 'Slabo',
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    height: 121.5,
                                    child: ListView.builder(
                                      itemCount: 9,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final hourlyForecast =
                                            data['list'][index + 1];
                                        final hourlySky =
                                            hourlyForecast['weather'][0]
                                                ['main'];
                                        final time = DateTime.parse(
                                            hourlyForecast['dt_txt']
                                                .toString());
                                        return HourlyForecastCards(
                                          time: DateFormat.j().format(time),
                                          icons: _getWeatherIcon(hourlySky),
                                          temperature:
                                              '${(hourlyForecast['main']['temp'] - 273.15).toStringAsFixed(0)}°C',
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Additional Information Card with transparency
                          Card(
                            color: theme.cardColor.withOpacity(0.5),
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Additional Information',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onSurface,
                                      fontFamily: 'Slabo',
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      AdditionalInformationItems(
                                        icon: Icons.water_drop_rounded,
                                        label: 'Humidity',
                                        value: currentHumidity.toString(),
                                      ),
                                      AdditionalInformationItems(
                                        icon: Icons.air,
                                        label: 'Wind Speed',
                                        value: windSpeed.toString(),
                                      ),
                                      AdditionalInformationItems(
                                        icon: Icons.beach_access_rounded,
                                        label: 'Pressure',
                                        value: currentPressure.toString(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
