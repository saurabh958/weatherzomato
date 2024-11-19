import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:weatherzomato/util/Constant.dart';
import 'package:weatherzomato/viewmodels/WeatherViewModel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => WeatherViewModel())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  late WeatherViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = context.read<WeatherViewModel>();
    viewModel.getCurrentDateTime();
    viewModel.requestPermission(Permission.locationWhenInUse);
    if (viewModel.isApiFailure) {
      showApiFailureSnackBar();
    }
  }

  void showApiFailureSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Api Failed!! Please Try Again Later")));
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          await viewModel.requestPermission(Permission.locationWhenInUse);
          print('refreshing please wait.....');
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: screenWidth,
                  child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      semanticContainer: true,
                      color: Colors.deepPurpleAccent[800],
                      shadowColor: Colors.deepPurpleAccent[400],
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: (viewModel.checkForApiFailure())
                                    ? const AssetImage(
                                        "assets/images/apifailed.jpg")
                                    : const AssetImage(
                                        "assets/images/nature1.jpeg"),
                                fit: BoxFit.fill,
                                alignment: Alignment.center)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            (viewModel.checkForApiFailure())
                                ? setFailureWidget()
                                : setSuccessWidget()
                          ],
                        ),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.28,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Expanded(
                        child: OtherParam(
                            otherparam: context
                                    .watch<WeatherViewModel>()
                                    .customWeatherModel
                                    .windSpeed ??
                                "NA",
                            cardType: CardType.WIND),
                      ),
                      Expanded(
                        child: OtherParam(
                            otherparam: context
                                    .watch<WeatherViewModel>()
                                    .customWeatherModel
                                    .humidity ??
                                "NA",
                            cardType: CardType.HUMIDITY),
                      ),
                      Expanded(
                        child: OtherParam(
                            otherparam: context
                                    .watch<WeatherViewModel>()
                                    .customWeatherModel
                                    .rainIntensity ??
                                "NA",
                            cardType: CardType.RAIN),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget setSuccessWidget() {
    return Column(
      children: [
        dateAndTimeWidget(context.watch<WeatherViewModel>().date,
            context.watch<WeatherViewModel>().day),
        setTemperatureWidget(
            context.watch<WeatherViewModel>().customWeatherModel.temperature ??
                "NA"),
        setLocationWidget(context.watch<WeatherViewModel>().subLocality)
      ],
    );
  }

  Widget setFailureWidget() {
    return Column(
      children: [
        dateAndTimeWidget(context.watch<WeatherViewModel>().date,
            context.watch<WeatherViewModel>().day)
      ],
    );
  }

  Widget dateAndTimeWidget(String date, String day) {
    return Container(
      padding: const EdgeInsets.only(top: 40),
      child: RichText(
          text: TextSpan(
              text: date,
              style: const TextStyle(fontSize: 22, color: Colors.white),
              children: [
            TextSpan(
                text: ' $day',
                style: const TextStyle(fontSize: 22, color: Colors.white60))
          ])),
    );
  }

  Widget setTemperatureWidget(String temp) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 100),
      child: (temp != "NA")
          ? Text("$temp°C",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 70,
                  fontWeight: FontWeight.bold))
          : Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/reload.png',
                    alignment: Alignment.center,
                    height: 50,
                    width: 50,
                  ),
                  const Text(
                    'Failed to load Data',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.normal),
                  )
                ],
              ),
            ),
    );
  }

  Widget setLocationWidget(String subLocation) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        subLocation,
        style: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.normal),
      ),
    );
  }
}
//test

class OtherParam extends StatelessWidget {
  final CardType cardType;
  final String otherparam;

  const OtherParam(
      {super.key, required this.otherparam, required this.cardType});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.20,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        semanticContainer: true,
        color: Colors.deepPurpleAccent[700],
        shadowColor: Colors.deepPurpleAccent[400],
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.blueAccent,
              Colors.deepPurpleAccent,
              Colors.deepPurple,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
          )),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Icon(
                  cardType.icons,
                  color: Colors.white,
                  size: 24.0,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  cardType.label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 15),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  cardType.getUnits(otherparam),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 15),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
