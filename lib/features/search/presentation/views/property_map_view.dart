import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

class PropertyMapView extends StatefulWidget {
  final List<PropertyEntity> properties;
  const PropertyMapView({super.key, required this.properties});

  @override
  State<PropertyMapView> createState() => _PropertyMapViewState();
}

class _PropertyMapViewState extends State<PropertyMapView> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(33.5138, 36.2765); // دمشق كبداية افتراضية

  Set<Marker> _createMarkers() {
    return widget.properties.map((property) {
      // ملاحظة: في المشروع الحقيقي يجب أن يحتوي PropertyEntity على Lat/Lng
      // هنا سنستخدم إحداثيات افتراضية قريبة من المركز للعرض فقط
      return Marker(
        markerId: MarkerId(property.id),
        position: LatLng(_center.latitude + (property.price % 0.01), _center.longitude + (property.area % 0.01)),
        infoWindow: InfoWindow(
          title: property.title,
          snippet: "${property.currency} ${property.price}",
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('استكشاف الخريطة', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => mapController = controller,
            initialCameraPosition: CameraPosition(target: _center, zoom: 12.0),
            markers: _createMarkers(),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
          ),
          Positioned(
            bottom: 20.h,
            left: 16.w,
            right: 16.w,
            child: _buildPropertyCarousel(),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyCarousel() {
    return SizedBox(
      height: 120.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.properties.length,
        itemBuilder: (context, index) {
          final property = widget.properties[index];
          return Container(
            width: 280.w,
            margin: EdgeInsets.only(right: 12.w),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    property.images.isNotEmpty ? property.images[0] : '',
                    width: 80.w,
                    height: 80.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(property.title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1),
                      Text("${property.currency} ${property.price}", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("${property.city}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          const Icon(Icons.location_on, size: 12, color: Colors.grey),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
