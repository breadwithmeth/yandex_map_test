import 'package:flutter/material.dart';
import 'package:yandex_map_test/examples/driving_page.dart';
import 'package:yandex_map_test/examples/map_controls_page.dart';
import 'package:yandex_map_test/examples/reverse_search_page.dart';
import 'package:yandex_map_test/examples/search_page.dart';
import 'package:yandex_map_test/examples/traffic_layer_page.dart';
import 'package:yandex_map_test/examples/user_layer_page.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

// class MainWidget extends StatefulWidget {
//   const MainWidget({super.key});

//   @override
//   State<MainWidget> createState() => _MainWidgetState();
// }

// class _MainWidgetState extends State<MainWidget> {
//   Widget currentWidget = Container();
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//           appBar: AppBar(
//             actions: [
//               ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       currentWidget = Container();
//                       currentWidget = MyApp(
//                           currentStore:
//                               Point(latitude: 52.271775, longitude: 76.950100));
//                     });
//                   },
//                   child: Text("Горького")),
//               ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       currentWidget = Container();
//                       currentWidget = MyApp(
//                           currentStore:
//                               Point(latitude: 52.292982, longitude: 76.941364));
//                     });
//                   },
//                   child: Text("Сатпаева"))
//             ],
//           ),
//           body: currentWidget),
//     );
//   }
// }

class MyApp extends StatefulWidget {
  MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double x = 52.271775;
  double y = 76.950100;
  double price = 0;
  double disc = 0;
  double discR = 0;
  Point gyp1 = Point(latitude: 0, longitude: 0);
  Point gyp2 = Point(latitude: 53.271775, longitude: 77.950100);
  late YandexMapController controller;
  late final List<MapObject> mapObjects = [
    PlacemarkMapObject(
      mapId: cameraMapObjectId,
      point: Point(latitude: 52.271775, longitude: 76.950100),
      icon: PlacemarkIcon.single(PlacemarkIconStyle(
          image: BitmapDescriptor.fromAssetImage('lib/assets/place.png'),
          scale: 0.75)),
      opacity: 0.5,
    ),
    PlacemarkMapObject(
      mapId: MapObjectId("123"),
      point: Point(latitude: 52.271775, longitude: 76.950100),
      icon: PlacemarkIcon.single(PlacemarkIconStyle(
          image: BitmapDescriptor.fromAssetImage('lib/assets/route_start.png'),
          scale: 0.75)),
      opacity: 0.5,
    ),
    PolylineMapObject(
        mapId: MapObjectId("gyp"), polyline: Polyline(points: [gyp1, gyp2]))
  ];

  final MapObjectId cameraMapObjectId = MapObjectId('camera_placemark');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      gyp1 = Point(latitude: 52.271775, longitude: 76.950100);
    });
  }

  void setDist(Point gyp2, Point gyp1) {
    double p = 0.017453292519943295;
    double a = 0.5 -
        cos((gyp2.latitude - gyp1.latitude) * p) / 2 +
        cos(gyp1.latitude * p) *
            cos(gyp2.latitude * p) *
            (1 - cos((gyp2.longitude - gyp1.longitude) * p)) /
            2;

    // 12742 * Math.asin(Math.sqrt(a));
    double d = acos((sin(gyp1.latitude) * sin(gyp2.latitude)) +
            cos(gyp1.latitude) *
                cos(gyp2.latitude) *
                cos(gyp2.longitude - gyp1.longitude)) *
        6371;
    setState(() {
      disc = 12742 * asin(sqrt(a));
    });
  }

  double getDisc(Point gyp2, Point gyp1) {
    double p = 0.017453292519943295;
    double a = 0.5 -
        cos((gyp2.latitude - gyp1.latitude) * p) / 2 +
        cos(gyp1.latitude * p) *
            cos(gyp2.latitude * p) *
            (1 - cos((gyp2.longitude - gyp1.longitude) * p)) /
            2;

    // 12742 * Math.asin(Math.sqrt(a));
    double d = acos((sin(gyp1.latitude) * sin(gyp2.latitude)) +
            cos(gyp1.latitude) *
                cos(gyp2.latitude) *
                cos(gyp2.longitude - gyp1.longitude)) *
        6371;
    return 12742 * asin(sqrt(a));
  }

  void setCarDist() {
    Point kat1_1 = Point(latitude: gyp1.latitude, longitude: gyp1.longitude);
    Point kat1_2 = Point(latitude: gyp1.latitude, longitude: gyp2.longitude);

    double d1 = getDisc(kat1_1, kat1_2);

    Point kat2_1 = Point(latitude: gyp2.latitude, longitude: gyp2.longitude);
    Point kat2_2 = Point(latitude: gyp1.latitude, longitude: gyp2.longitude);

    double d2 = getDisc(kat2_1, kat2_2);
    setState(() {
      discR = d1 + d2;
    });
  }

  void setPrice() {
    double temp = (discR * 1.1 * 388);
    setState(() {
      if (temp <= 700) {
        price = 700;
      } else if (temp > 700 && temp < 1000) {
        price = 1000;
      } else if (temp > 1000 && temp < 1200) {
        price = 1200;
      } else if (temp > 1200 && temp < 1500) {
        price = 1500;
      } else {
        price = temp;
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    x = x + 0.001;
                    y = y + 0.001;
                  });
                  PlacemarkMapObject placemarkMapObject = mapObjects.firstWhere(
                    (el) => el.mapId == MapObjectId("123"),
                  ) as PlacemarkMapObject;
                  mapObjects[mapObjects.indexOf(placemarkMapObject)] =
                      placemarkMapObject.copyWith(
                          point: Point(latitude: x, longitude: y));
                },
                child: Text("change")),
            Flexible(
              flex: 3,
              child: YandexMap(
                mapObjects: mapObjects,
                onMapCreated: (controller) {
                  PlacemarkMapObject placemarkMapObject = mapObjects
                          .firstWhere((el) => el.mapId == cameraMapObjectId)
                      as PlacemarkMapObject;
                  controller.moveCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(target: placemarkMapObject.point)));
                },
                onCameraPositionChanged: (cameraPosition, reason, finished) {
                  PlacemarkMapObject placemarkMapObject = mapObjects
                          .firstWhere((el) => el.mapId == cameraMapObjectId)
                      as PlacemarkMapObject;

                  PolylineMapObject _gyp = mapObjects
                          .firstWhere((el) => el.mapId == MapObjectId("gyp"))
                      as PolylineMapObject;

                  setState(() {
                    mapObjects[mapObjects.indexOf(placemarkMapObject)] =
                        placemarkMapObject.copyWith(
                            point: cameraPosition.target);
                    gyp2 = Point(
                        latitude: placemarkMapObject.point.latitude,
                        longitude: placemarkMapObject.point.longitude);
                    mapObjects[mapObjects.indexOf(_gyp)] =
                        _gyp.copyWith(polyline: Polyline(points: [gyp1, gyp2]));
                    setDist(gyp2, gyp1);
                    setCarDist();
                    setPrice();
                  });
                },
              ),
            ),
            Flexible(
                child: Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("Расстояние между двумя точками  по прямой км."),
                      Text(disc.toString())
                    ],
                  ),
                  Row(
                    children: [
                      Text("Расстояния с учетом дорог км."),
                      Text((discR * 1.1).toString())
                    ],
                  ),
                  Row(
                    children: [
                      Text("Примерная цена"),
                      Text((discR * 1.1 * 388).toString())
                    ],
                  ),
                  Row(
                    children: [
                      Text("Округленная цена"),
                      Text(price.toString())
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              gyp1 = Point(
                                  latitude: 52.271775, longitude: 76.950100);
                            });
                          },
                          child: Text("Горького")),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              gyp1 = Point(
                                  latitude: 52.292982, longitude: 76.941364);
                            });
                          },
                          child: Text("Сатпаева")),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              gyp1 = Point(
                                  latitude: 52.249676, longitude: 76.954269);
                            });
                          },
                          child: Text("Усолка"))
                    ],
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
