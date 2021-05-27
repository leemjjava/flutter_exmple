import 'package:flutter/material.dart';
import 'package:flutter_kakao_map/flutter_kakao_map.dart';
import 'package:flutter_kakao_map/kakao_maps_flutter_platform_interface.dart';

class MapViewBody extends StatefulWidget {
  static const String routeName = '/examples/map_view_body';
  const MapViewBody();

  @override
  State<StatefulWidget> createState() => MapViewBodyState();
}

class MapViewBodyState extends State<MapViewBody> {
  late KakaoMapController mapController;
  MapPoint _visibleRegion = MapPoint(37.5087553, 127.0632877);
  static final CameraPosition _kInitialPosition = CameraPosition(
    target: MapPoint(37.5087553, 127.0632877),
    zoom: 5,
  );

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  int _markerIdCounter = 1;
  CameraPosition _position = _kInitialPosition;
  bool _isDrag = false;
  late MarkerId selectedMarker;

  void onMapCreated(KakaoMapController controller) async {
    final MapPoint? visibleRegion = await controller.getMapCenterPoint();
    if (visibleRegion == null) return;
    setState(() {
      mapController = controller;
      _visibleRegion = visibleRegion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter KakaoMap example')),
      body: Stack(
        children: [
          Positioned.fill(child: renderMap()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _add();
          setState(() {});
        },
        child: const Icon(Icons.navigation),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget renderMap() {
    return KakaoMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: _kInitialPosition,
      markers: Set<Marker>.of(markers.values),
    );
  }

  void _add() async {
    final int markerCount = markers.length;

    if (markerCount == 12) return;

    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final icon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      'eat_cape_town_sm.jpg',
    );

    final Marker marker = Marker(
      markerId: markerId,
      position: MapPoint(_position.target.latitude, _position.target.longitude),
      draggable: _isDrag,
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      markerType: MarkerType.markerTypeBluePin,
      markerSelectedType: MarkerSelectedType.markerSelectedTypeRedPin,
      showAnimationType: ShowAnimationType.showAnimationTypeDropFromHeaven,
      onTap: () => _onMarkerTapped(markerId),
      icon: icon,
      // onDragEnd: (MapPoint position) {
      //   _onMarkerDragEnd(markerId, position);
      // },
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  void _onMarkerTapped(MarkerId markerId) {
    final Marker? tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        if (markers.containsKey(selectedMarker)) {
          final Marker resetOld = markers[selectedMarker]!
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers[markerId] = newMarker;
      });
    }
  }
}
