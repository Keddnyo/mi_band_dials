import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MainApp());
}

class Constants {
  static String title = 'Mi Band 8 Dials';
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final response = () async {
    var value = <http.Response>[];
    var r1 = http.get(
      Uri.parse(
        'https://watch-appstore.iot.mi.com/api/watchface/prize/tabs?model=miwear.watch.m66dsn',
      ),
    );
    var r2 = http.get(
      Uri.parse(
        'https://watch-appstore.iot.mi.com/api/watchface/prize/tabs?model=miwear.watch.m66gl',
      ),
    );
    var r3 = http.get(
      Uri.parse(
        'https://watch-appstore.iot.mi.com/api/watchface/prize/tabs?model=miwear.watch.m66',
      ),
    );
    var r4 = http.get(
      Uri.parse(
        'https://watch-appstore.iot.mi.com/api/watchface/prize/tabs?model=miwear.watch.m66nfc',
      ),
    );
    var results = await Future.wait([r1, r2, r3, r4]);
    for (var response in results) {
      value.add(response);
    }
    return value;
  }();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(Constants.title),
        ),
        body: MainContent(
          response: response,
        ),
        drawer: const Drawer(),
      ),
      title: Constants.title,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
    );
  }
}

class Drawer extends StatelessWidget {
  const Drawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: null,
      onDestinationSelected: (value) {
        switch (value) {
          case 0:
            launchUrl(
              Uri.parse('https://4pda.to/forum/index.php?showtopic=1064924'),
              mode: LaunchMode.externalApplication,
            );
            break;
          case 1:
            launchUrl(
              Uri.parse('https://4pda.to/forum/index.php?showtopic=1068539'),
              mode: LaunchMode.externalApplication,
            );
            break;
          case 2:
            launchUrl(
              Uri.parse('https://4pda.to/forum/index.php?showtopic=1068538'),
              mode: LaunchMode.externalApplication,
            );
            break;
          case 3:
            launchUrl(
              Uri.parse('https://4pda.to/forum/index.php?showtopic=1068536'),
              mode: LaunchMode.externalApplication,
            );
            break;
          case 4:
            launchUrl(
              Uri.parse('https://4pda.to/forum/index.php?showtopic=1068540'),
              mode: LaunchMode.externalApplication,
            );
            break;
          case 5:
            launchUrl(
              Uri.parse('https://4pda.to/forum/index.php?showtopic=1068541'),
              mode: LaunchMode.externalApplication,
            );
            break;
          default:
            launchUrl(
              Uri.parse('https://4pda.to/forum/index.php?showuser=8096247'),
              mode: LaunchMode.externalApplication,
            );
        }
      },
      children: [
        DrawerHeader(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Constants.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0,
                  ),
                ),
                const Text('Created by Keddnyo',
                    style: TextStyle(fontSize: 8.0)),
              ],
            ),
          ),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.forum),
          label: Text('Обсуждение'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.memory),
          label: Text('Прошивки'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.watch),
          label: Text('Циферблаты'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.shopping_cart),
          label: Text('Покупка'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.extension),
          label: Text('Аксессуары'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.construction),
          label: Text('Брак и ремонт'),
        ),
        const Divider(),
        const NavigationDrawerDestination(
          icon: Icon(Icons.account_circle),
          label: Text('Keddnyo'),
        ),
      ],
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent({
    super.key,
    required this.response,
  });

  final Future<List<http.Response>> response;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: response,
      builder: ((context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasData) {
              var watchFaceList = <WatchFace>[];

              for (var response in snapshot.data!) {
                Map<String, dynamic> json = jsonDecode(response.body);
                List<dynamic> data = json['data'];
                for (var tab in data) {
                  List<dynamic> list = tab['list'];
                  for (var dial in list) {
                    var watchface = WatchFace(
                      name: dial['display_name'],
                      icon: dial['icon'],
                      url: dial['config_file'],
                    );
                    if (!watchFaceList.contains(watchface)) {
                      watchFaceList.add(
                        watchface,
                      );
                    }
                  }
                }
              }

              watchFaceList = watchFaceList.distinctBy((e) => e.name);

              var borderRadius = const BorderRadius.all(
                Radius.circular(16.0),
              );

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 256,
                ),
                itemCount: watchFaceList.length,
                itemBuilder: (context, i) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.onBackground,
                        width: 0.5,
                      ),
                      borderRadius: borderRadius,
                    ),
                    elevation: 4.0,
                    margin: const EdgeInsets.all(12.0),
                    child: InkWell(
                      borderRadius: borderRadius,
                      onTap: () {
                        launchUrl(
                          Uri.parse(watchFaceList[i].url),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.network(
                                watchFaceList[i].icon,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                watchFaceList[i].name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
        }
      }),
    );
  }
}

class WatchFace {
  String name;
  String icon;
  String url;

  WatchFace({required this.name, required this.icon, required this.url});
}

extension IterableExtension<T> on Iterable<T> {
  List<T> distinctBy(Object Function(T e) getCompareValue) {
    var result = <T>[];
    forEach((element) {
      if (!result.any((x) => getCompareValue(x) == getCompareValue(element))) {
        result.add(element);
      }
    });

    return result;
  }
}
