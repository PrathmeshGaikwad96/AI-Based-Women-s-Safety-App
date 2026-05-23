import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:basic/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../state/app_state.dart';
import '../models/nearby_place.dart';
import 'package:geolocator/geolocator.dart';


class LiveTrackScreen extends StatefulWidget {
  const LiveTrackScreen({super.key});

  @override
  State<LiveTrackScreen> createState() => _LiveTrackScreenState();
}

class _LiveTrackScreenState extends State<LiveTrackScreen> {
  int _modeIndex = 0; // 0: Live, 1: Risk Heatmap, 2: Nearby
  final MapController _mapController = MapController();
  dynamic _selectedItem; // Can be UnsafePlace or NearbyPlace
  bool _autoCenter = true;
  Position? _lastAutoCenteredPosition;

  final TextEditingController _searchController = TextEditingController();
  String? _searchedAddress;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (mounted) setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<AppState>(context, listen: false);
      if (appState.currentPosition != null) {
        _mapController.move(
          LatLng(appState.currentPosition!.latitude, appState.currentPosition!.longitude),
          15.0,
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Searching for "$query" in Pune...'),
        duration: const Duration(seconds: 2),
      ),
    );

    try {
      final response = await http.get(
        Uri.parse('https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}+Pune&format=json&limit=1'),
        headers: {'User-Agent': 'com.basic.hutter'},
      ).timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final List results = jsonDecode(response.body);
        if (results.isNotEmpty) {
          final lat = double.parse(results[0]['lat']);
          final lon = double.parse(results[0]['lon']);
          final displayName = results[0]['display_name'];
          
          final nameParts = displayName.split(',');
          final shortName = nameParts.take(3).join(',').trim();

          setState(() {
            _searchedAddress = shortName;
            _autoCenter = false;
            _modeIndex = 2; // Switch to Nearby mode to view nearby resources instantly
          });

          _mapController.move(LatLng(lat, lon), 15.0);

          final appState = Provider.of<AppState>(context, listen: false);
          await appState.fetchNearbyEmergencyServices(lat, lon);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Showing results for: $shortName'),
              backgroundColor: AppColors.primaryBlue,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No places found in Pune for that search.'),
              backgroundColor: AppColors.danger,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Search failed. Please try again.'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } catch (e) {
      print('Geocoding error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Search error: $e'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  // Dial a phone number using url_launcher
  Future<void> _makeCall(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final Uri launchUri = Uri(scheme: 'tel', path: cleanPhone);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        await launchUrl(launchUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch dialer for: $phone'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  // Navigate to coordinate on external map
  Future<void> _navigateTo(double lat, double lng) async {
    final String mapUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    final Uri mapUri = Uri.parse(mapUrl);
    try {
      await launchUrl(mapUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Could not open external navigation maps.'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  // Dynamic colors/icons for Overpass place types
  IconData _getIconForType(String type) {
    switch (type) {
      case 'police':
        return Icons.local_police_rounded;
      case 'hospital':
        return Icons.local_hospital_rounded;
      case 'fire_station':
        return Icons.local_fire_department_rounded;
      case 'ngo':
        return Icons.people_alt_rounded;
      case 'shelter':
        return Icons.home_work_rounded;
      default:
        return Icons.location_on_rounded;
    }
  }

  Color _getThemeColorForType(String type) {
    switch (type) {
      case 'police':
        return AppColors.primaryBlue;
      case 'hospital':
        return AppColors.danger;
      case 'fire_station':
        return Colors.orange;
      case 'ngo':
        return AppColors.purple;
      case 'shelter':
        return AppColors.success;
      default:
        return AppColors.primaryBlue;
    }
  }

  // PIN dialog is no longer used because PIN check was removed per requirements.

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final userPos = appState.currentPosition;
    final userLatLng = userPos != null 
        ? LatLng(userPos.latitude, userPos.longitude) 
        : const LatLng(18.5204, 73.8567);

    // Auto-center camera tracking logic
    if (userPos != null && _autoCenter) {
      if (_lastAutoCenteredPosition == null ||
          _lastAutoCenteredPosition!.latitude != userPos.latitude ||
          _lastAutoCenteredPosition!.longitude != userPos.longitude) {
        _lastAutoCenteredPosition = userPos;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _mapController.move(LatLng(userPos.latitude, userPos.longitude), _mapController.camera.zoom);
          }
        });
      }
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.0),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // Main Interactive OpenStreetMap
              Positioned.fill(
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: userLatLng,
                    initialZoom: 15.0,
                    minZoom: 4.0,
                    maxZoom: 19.0,
                    onTap: (tapPos, point) {
                      setState(() {
                        _selectedItem = null;
                      });
                    },
                    onPositionChanged: (position, hasGesture) {
                      if (hasGesture && _autoCenter) {
                        setState(() {
                          _autoCenter = false;
                        });
                      }
                    },
                  ),
                  children: [
                    // OpenStreetMap Free Tile Provider
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.basic.hutter',
                      tileProvider: NetworkTileProvider(),
                    ),



                    // Danger zone Circles (Heatmap Mode)
                    if (_modeIndex == 1)
                      CircleLayer(
                        circles: appState.unsafePlaces.map((place) {
                          return CircleMarker(
                            point: LatLng(place.latitude, place.longitude),
                            radius: place.radius,
                            useRadiusInMeter: true,
                            color: place.riskLevel == 'High Risk'
                                ? AppColors.danger.withOpacity(0.24)
                                : Colors.orange.withOpacity(0.24),
                            borderColor: place.riskLevel == 'High Risk'
                                ? AppColors.danger.withOpacity(0.5)
                                : Colors.orange.withOpacity(0.5),
                            borderStrokeWidth: 1.5,
                          );
                        }).toList(),
                      ),

                    // Overpass Nearby markers (Nearby Mode)
                    if (_modeIndex == 2)
                      MarkerLayer(
                        markers: appState.nearbyPlaces.map((place) {
                          return Marker(
                            point: LatLng(place.latitude, place.longitude),
                            width: 38,
                            height: 38,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedItem = place;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.12),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    )
                                  ],
                                  border: Border.all(
                                    color: _getThemeColorForType(place.type),
                                    width: 2.2,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    _getIconForType(place.type),
                                    color: _getThemeColorForType(place.type),
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                    // Unsafe Zone Pin Indicators (Heatmap Mode)
                    if (_modeIndex == 1)
                      MarkerLayer(
                        markers: appState.unsafePlaces.map((place) {
                          return Marker(
                            point: LatLng(place.latitude, place.longitude),
                            width: 32,
                            height: 32,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedItem = place;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    )
                                  ],
                                  border: Border.all(
                                    color: place.riskLevel == 'High Risk'
                                        ? AppColors.danger
                                        : Colors.orange,
                                    width: 1.8,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.warning_amber_rounded,
                                    color: place.riskLevel == 'High Risk'
                                        ? AppColors.danger
                                        : Colors.orange,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                    // Guardian approaching dot (Live SOS simulation)
                    if (_modeIndex == 0 && appState.isSosActive && appState.guardianPosition != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: appState.guardianPosition!,
                            width: 44,
                            height: 44,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Pulsing green background
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.success.withOpacity(0.26),
                                  ),
                                ),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      )
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.security_rounded,
                                      color: AppColors.success,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),

                    // Live User current position dot
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: userLatLng,
                          width: 40,
                          height: 40,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryBlue.withOpacity(0.24),
                                ),
                              ),
                              Container(
                                width: 16,
                                height: 16,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    )
                                  ],
                                ),
                                child: Center(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primaryBlue,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              // Danger Intrusion Overlay Banner
              if (appState.isEnteringThreat && appState.nearbyThreat != null)
                Positioned(
                  left: 16,
                  right: 16,
                  top: 136,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.danger, Color(0xFFFF5E5E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.danger.withOpacity(0.35),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.error_outline_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'DANGER ZONE: ${appState.nearbyThreat!.name}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 11,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                appState.nearbyThreat!.description,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // SOS Live Broadcasting Banner Overlay
              if (appState.isSosActive)
                Positioned(
                  left: 16,
                  right: 16,
                  top: 136,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6A5CFF), Color(0xFFB066FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6A5CFF).withOpacity(0.35),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'SOS BROADCAST ACTIVE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 11,
                                  letterSpacing: 0.6,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                appState.guardianPosition != null
                                    ? 'Guardian helper approaching. Coordinates synced to database.'
                                    : 'Transmitting live telemetry & battery tracking to safety circle.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Top HUD and Controls
              Positioned(
                left: 16,
                right: 16,
                top: 10,
                child: Row(
                  children: [
                    _CircleIconButton(
                      icon: Icons.chevron_left_rounded,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 38,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: const Color(0xFFE9ECF6)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: appState.isEnteringThreat 
                                    ? AppColors.danger 
                                    : AppColors.success,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                appState.isEnteringThreat
                                    ? 'DANGER AREA • HIGH THREAT RISK'
                                    : 'SAFE ZONE • ${(_searchedAddress ?? appState.currentAddress).toUpperCase()}',
                                style: TextStyle(
                                  color: AppColors.textDark.withOpacity(0.85),
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.6,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _CircleIconButton(
                      icon: appState.isEnteringThreat
                          ? Icons.warning_rounded
                          : Icons.notifications_none_rounded,
                      iconColor: appState.isEnteringThreat ? AppColors.danger : null,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              appState.isEnteringThreat
                                  ? 'Threat Alert: You have entered ${appState.nearbyThreat?.name}. Proximity warning active!'
                                  : 'System fully operational. Nearby emergency resources mapped.',
                            ),
                            backgroundColor: appState.isEnteringThreat ? AppColors.danger : AppColors.primaryBlue,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Segmented controller for modes
              Positioned(
                left: 26,
                right: 26,
                top: 76,
                child: _ModeSegment(
                  index: _modeIndex,
                  onChanged: (v) {
                    setState(() {
                      _modeIndex = v;
                      _selectedItem = null;
                    });
                    if (v == 2) {
                      appState.fetchNearbyEmergencyServices(
                        _mapController.camera.center.latitude,
                        _mapController.camera.center.longitude,
                      );
                    }
                  },
                ),
              ),

              // AI safety metrics panel (Risk Heatmap Mode only)
              if (_modeIndex == 1)
                Positioned(
                  left: 26,
                  right: 26,
                  top: 136,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE9ECF6)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'AI Risk Projections',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textDark,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: appState.aiRiskPredictionScore > 50
                                    ? AppColors.danger.withOpacity(0.12)
                                    : AppColors.success.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                '${appState.aiRiskPredictionScore.toInt()}% Risk',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: appState.aiRiskPredictionScore > 50
                                      ? AppColors.danger
                                      : AppColors.success,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          appState.aiPredictionSummary,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textMuted,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Float Control Panel on Right Side
              Positioned(
                right: 16,
                top: 212,
                child: Column(
                  children: [
                    // Auto Center Toggle
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _autoCenter = !_autoCenter;
                        });
                        if (_autoCenter && userPos != null) {
                          _mapController.move(LatLng(userPos.latitude, userPos.longitude), _mapController.camera.zoom);
                        }
                      },
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: _autoCenter ? AppColors.primaryBlue : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFE9ECF6)),
                          boxShadow: [
                            BoxShadow(
                              color: _autoCenter 
                                  ? AppColors.primaryBlue.withOpacity(0.24) 
                                  : Colors.black.withOpacity(0.06),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.my_location_rounded,
                          size: 20,
                          color: _autoCenter ? Colors.white : AppColors.primaryBlue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _MapWhiteButton(
                      icon: Icons.add_rounded,
                      onTap: () {
                        if (mounted) {
                          _mapController.move(_mapController.camera.center, _mapController.camera.zoom + 1.0);
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    _MapWhiteButton(
                      icon: Icons.remove_rounded,
                      onTap: () {
                        if (mounted) {
                          _mapController.move(_mapController.camera.center, _mapController.camera.zoom - 1.0);
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    // Manual refresh button in Nearby Mode
                    if (_modeIndex == 2)
                      _MapWhiteButton(
                        icon: Icons.sync_rounded,
                        onTap: () {
                          appState.fetchNearbyEmergencyServices(
                            _mapController.camera.center.latitude,
                            _mapController.camera.center.longitude,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Querying local Overpass API nodes...'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),

              // Selected Place Info Details Card (Slide up from bottom)
              if (_selectedItem != null)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: appState.isSosActive ? 134 : 116,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.97),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE9ECF6)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _selectedItem is NearbyPlace
                                    ? _getThemeColorForType(_selectedItem.type).withOpacity(0.12)
                                    : AppColors.danger.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _selectedItem is NearbyPlace
                                    ? _getIconForType(_selectedItem.type)
                                    : Icons.warning_amber_rounded,
                                color: _selectedItem is NearbyPlace
                                    ? _getThemeColorForType(_selectedItem.type)
                                    : AppColors.danger,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedItem.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    _selectedItem is NearbyPlace
                                        ? _selectedItem.address
                                        : _selectedItem.description,
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      color: AppColors.textMuted,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18),
                              onPressed: () {
                                setState(() {
                                  _selectedItem = null;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            // Call Action (if available)
                            if (_selectedItem is NearbyPlace && _selectedItem.phone != null)
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _getThemeColorForType(_selectedItem.type),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  icon: const Icon(Icons.phone_in_talk_rounded, size: 16, color: Colors.white),
                                  label: const Text(
                                    'Call Support',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  onPressed: () => _makeCall(_selectedItem.phone!),
                                ),
                              ),
                            if (_selectedItem is NearbyPlace && _selectedItem.phone != null)
                              const SizedBox(width: 10),

                            // Navigation maps launcher
                            Expanded(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: BorderSide(
                                    color: _selectedItem is NearbyPlace
                                        ? _getThemeColorForType(_selectedItem.type)
                                        : AppColors.danger,
                                  ),
                                ),
                                icon: Icon(
                                  Icons.directions_rounded,
                                  size: 16,
                                  color: _selectedItem is NearbyPlace
                                      ? _getThemeColorForType(_selectedItem.type)
                                      : AppColors.danger,
                                ),
                                label: Text(
                                  'Directions',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: _selectedItem is NearbyPlace
                                        ? _getThemeColorForType(_selectedItem.type)
                                        : AppColors.danger,
                                  ),
                                ),
                                onPressed: () => _navigateTo(_selectedItem.latitude, _selectedItem.longitude),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              // Bottom Search bar overlay (hidden during SOS details to avoid overlap)
              if (!appState.isSosActive && _selectedItem == null)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 118,
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.96),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE9ECF6)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 24,
                          offset: const Offset(0, 14),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (_searchController.text.trim().isNotEmpty) {
                              _performSearch(_searchController.text);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            child: Icon(
                              Icons.search_rounded,
                              size: 18,
                              color: AppColors.textMuted.withOpacity(0.9),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onSubmitted: (value) => _performSearch(value),
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              hintText: 'Search safe routes in Pune...',
                              hintStyle: TextStyle(
                                color: AppColors.textMuted.withOpacity(0.6),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() {
                                _searchedAddress = null;
                                _autoCenter = true;
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0),
                              child: Icon(
                                Icons.clear_rounded,
                                size: 18,
                                color: AppColors.textMuted,
                              ),
                            ),
                          )
                        else
                          Container(
                            width: 34,
                            height: 34,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEFF2FF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.mic_rounded,
                              size: 18,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

              // Bottom SOS Activation button panel
              Positioned(
                left: 0,
                right: 0,
                bottom: 18,
                child: Center(
                  child: appState.isSosActive
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.danger,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                elevation: 8,
                                shadowColor: AppColors.danger.withOpacity(0.3),
                              ),
                              icon: const Icon(Icons.cancel_rounded, color: Colors.white),
                              label: const Text(
                                'CANCEL EMERGENCY ALARM',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.6,
                                  fontSize: 12,
                                ),
                              ),
                              onPressed: () async {
                                await appState.cancelSOS("0000");
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('SOS Alert successfully cancelled.'),
                                      backgroundColor: AppColors.success,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        )
                      : _SosButton(
                          onTap: () {
                            appState.triggerSOS(null);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Live SOS Triggered! Alerts sent to emergency contacts.'),
                                backgroundColor: AppColors.danger,
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeSegment extends StatelessWidget {
  const _ModeSegment({required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE9ECF6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeChip(
              selected: index == 0,
              icon: Icons.wifi_tethering_rounded,
              label: 'Live Track',
              onTap: () => onChanged(0),
            ),
          ),
          Expanded(
            child: _ModeChip(
              selected: index == 1,
              icon: Icons.warning_amber_rounded,
              label: 'Risk Heatmap',
              onTap: () => onChanged(1),
            ),
          ),
          Expanded(
            child: _ModeChip(
              selected: index == 2,
              icon: Icons.location_on_outlined,
              label: 'Nearby Safe',
              onTap: () => onChanged(2),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: selected ? Colors.white : AppColors.textMuted.withOpacity(0.9),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.textMuted.withOpacity(0.95),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE9ECF6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor ?? AppColors.textDark.withOpacity(0.9), size: 22),
      ),
    );
  }
}

class _MapWhiteButton extends StatelessWidget {
  const _MapWhiteButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE9ECF6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Icon(icon, size: 22, color: AppColors.primaryBlue),
      ),
    );
  }
}

class _SosButton extends StatelessWidget {
  const _SosButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 98,
        height: 98,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.55),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withOpacity(0.18),
              blurRadius: 30,
              offset: const Offset(0, 18),
            )
          ],
        ),
        child: Center(
          child: Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryBlue,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.22),
                  blurRadius: 26,
                  offset: const Offset(0, 16),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: const [
                    Icon(Icons.location_on_rounded, color: Colors.white, size: 24),
                    Positioned(
                      top: 5,
                      child: Icon(Icons.priority_high_rounded,
                          color: Colors.white, size: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'SOS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}