import 'package:google_maps_webservice/places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:HealthGuard/helper/string_helper.dart';

/// Passing the Google CLoud api key into google map function
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Constants.GoogleApiKey);

class PlaceDetailScreen extends StatefulWidget{
  String placeId;

  PlaceDetailScreen(String placeId){
    this.placeId = placeId;
  }

  @override
  State<StatefulWidget> createState(){
    return PlaceDetailState();
  }

}

class PlaceDetailState extends State<PlaceDetailScreen>{
  GoogleMapController mapController;
  PlacesDetailsResponse place;
  bool isLoading;
  String errorLoading;
  /// Set of markers to mark the hospital's location nearby
  Set<Marker> marker = {};

  @override
  void initState(){
    fetchPlaceDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    Widget bodyChild;
    String title;
    if(isLoading){
      title = "Loading";
      bodyChild = Center(
        child: CircularProgressIndicator(
          value: null,
        ),
      );
    }else if(errorLoading != null){
      title = "";
      bodyChild = Center(
        child: Text(errorLoading),
      );
    }else{
      final placeDetail = place.result;
      final location = place.result.geometry.location;
      final lat = location.lat;
      final lng = location.lng;
      final center = LatLng(lat, lng);

      title = placeDetail.name;
      bodyChild = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: SizedBox(
              height: 200.0,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                markers: marker..add(
                  Marker(
                      markerId: MarkerId(placeDetail.placeId),
                      position: center,
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                      /// Decide what is to be shown when the location marker has been clicked
                      infoWindow: InfoWindow(title: "${placeDetail.name}")
                  ),
                ),
                /// The initial position of the google map has been set to the location of the hospital (center)
                initialCameraPosition: CameraPosition(target: center, zoom: 15.0),
              ),
            ),
          ),
          Expanded(
            child: buildPlaceDetailList(placeDetail),
          )
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontFamily: Constants.FONTSTYLE,
            fontWeight: Constants.APPBAR_TEXT_WEIGHT,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Constants.APPBAR_COLOUR,
        centerTitle: true,
      ),
      body: bodyChild,
    );
  }

  /// Retrieving the detail of the location from google map
  void fetchPlaceDetail() async{
    setState(() {
      this.isLoading = true;
      this.errorLoading = null;
    });

    PlacesDetailsResponse place= await _places.getDetailsByPlaceId(widget.placeId);

    if(mounted){
      setState(() {
        this.isLoading = false;
        if(place.status == "OK"){
          this.place = place;
        }else{
          this.errorLoading = place.errorMessage;
        }
      });
    }
  }

  void _onMapCreated(GoogleMapController controller){
    mapController = controller;
    final location = place.result.geometry.location;
    final lat = location.lat;
    final lng = location.lng;
    final center = LatLng(lat, lng);
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: center, zoom: 15.0)));
  }

  /// Retrieve the images available for the hospital from google map
  String buildPhotoURL(String photoReference){
    return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${photoReference}&key=${Constants.GoogleApiKey}";
  }

  /// Displays the detail of the hospital in this screen
  ListView buildPlaceDetailList(PlaceDetails placeDetail){
    List<Widget> list = [];
    if(placeDetail.photos != null){
      final photos = placeDetail.photos;
      list.add(SizedBox(
        height: 100.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: photos.length,
          itemBuilder: (context, index){
            return Padding(
                padding: EdgeInsets.all(2.0),
                child: SizedBox(
                  height: 100,
                  child: Image.network(buildPhotoURL(photos[index].photoReference)),
                )
            );
          },
        ),
      ));
    }


    list.add( Padding(
      padding: EdgeInsets.only(top: 30.0, left: 4.0, bottom: 4.0),
      child: Column(
        children: <Widget>[
          Text(
            "Name : ",
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              fontFamily: Constants.FONTSTYLE,
              fontWeight: Constants.APPBAR_TEXT_WEIGHT,
            ),
          ),

          Text(
            placeDetail.name,
            style: TextStyle(
              fontSize: 18.0,
              color: Constants.TEXT_LIGHT,
              fontFamily: Constants.FONTSTYLE,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10,),
        ],
      ),
    )
    );

    if(placeDetail.formattedAddress != null){
      list.add(
          Padding(
            padding: EdgeInsets.only(left: 4.0, bottom: 4.0),
            child: Column(
              children: <Widget>[
                Text(
                  "Address : ",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontFamily: Constants.FONTSTYLE,
                    fontWeight: Constants.APPBAR_TEXT_WEIGHT,
                  ),
                ),

                Text(
                  placeDetail.formattedAddress,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Constants.TEXT_LIGHT,
                    fontFamily: Constants.FONTSTYLE,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10,),
              ],
            ),
          )
      );
    }

    if (placeDetail.types?.first != null) {
      list.add(
        Padding(
          padding: EdgeInsets.only(left: 4.0, bottom: 4.0),
          child: Column(
            children: <Widget>[
              Text(
                "Type : ",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontFamily: Constants.FONTSTYLE,
                  fontWeight: Constants.APPBAR_TEXT_WEIGHT,
                ),
              ),

              Text(
                placeDetail.types.first.capitalize(),
                style: TextStyle(
                  fontSize: 18.0,
                  color: Constants.TEXT_LIGHT,
                  fontFamily: Constants.FONTSTYLE,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
      );
    }

    if (placeDetail.formattedPhoneNumber != null) {
      list.add(
        Padding(
          padding: EdgeInsets.only(left: 4.0, bottom: 4.0),
          child: Column(
            children: <Widget>[
              Text(
                "Phone Number : ",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontFamily: Constants.FONTSTYLE,
                  fontWeight: Constants.APPBAR_TEXT_WEIGHT,
                ),
              ),

              Text(
                placeDetail.formattedPhoneNumber,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Constants.TEXT_LIGHT,
                  fontFamily: Constants.FONTSTYLE,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
      );
    }

    if (placeDetail.openingHours != null) {
      final openingHour = placeDetail.openingHours;
      var text = '';
      if (openingHour.openNow) {
        text = 'Opening Now';
      } else {
        text = 'Closed';
      }
      list.add(
          Padding(
            padding: EdgeInsets.only(left: 4.0, bottom: 4.0),
            child: Column(
              children: <Widget>[
                Text(
                  "Availability : ",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontFamily: Constants.FONTSTYLE,
                    fontWeight: Constants.APPBAR_TEXT_WEIGHT,
                  ),
                ),

                Text(
                  text,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Constants.TEXT_LIGHT,
                    fontFamily: Constants.FONTSTYLE,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10,),
              ],
            ),
          )
          );
    }

    if (placeDetail.website != null) {
      list.add(
        Padding(
          padding: EdgeInsets.only(left: 4.0, bottom: 4.0),
          child: Column(
            children: <Widget>[
              Text(
                "Website : ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontFamily: Constants.FONTSTYLE,
                  fontWeight: Constants.APPBAR_TEXT_WEIGHT,
                ),
              ),

              Text(
                placeDetail.website,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Constants.TEXT_LIGHT,
                  fontFamily: Constants.FONTSTYLE,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
      );
    }

    if (placeDetail.rating != null) {
      list.add(
      Padding(
        padding: EdgeInsets.only(left: 4.0, bottom: 4.0),
        child: Column(
          children: <Widget>[
            Text(
              "Ratings : ",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
                fontFamily: Constants.FONTSTYLE,
                fontWeight: Constants.APPBAR_TEXT_WEIGHT,
              ),
            ),

            Text(
              '${placeDetail.rating}',
              style: TextStyle(
                fontSize: 18.0,
                color: Constants.TEXT_LIGHT,
                fontFamily: Constants.FONTSTYLE,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10,),
          ],
        ),
      )
      );
    }

    return ListView(
      shrinkWrap: true,
      children: list,
    );
  }

}