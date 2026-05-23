import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../main.dart';
import '../../state/app_state.dart';
import '../../models/alert_model.dart';
import '../../models/user_model.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  int _selectedTab = 0;
  final _searchController = TextEditingController();
  
  // Threat zone controllers
  final _zoneNameController = TextEditingController();
  final _zoneLatController = TextEditingController();
  final _zoneLngController = TextEditingController();
  final _zoneRadiusController = TextEditingController(text: '300');
  final _zoneDescController = TextEditingController();
  String _riskLevel = 'Moderate Risk';

  // Verification filtering index
  int _verificationFilter = 0; // 0: Pending, 1: Approved, 2: Blocked

  final MapController _adminMapController = MapController();

  @override
  void dispose() {
    _searchController.dispose();
    _zoneNameController.dispose();
    _zoneLatController.dispose();
    _zoneLngController.dispose();
    _zoneRadiusController.dispose();
    _zoneDescController.dispose();
    _adminMapController.dispose();
    super.dispose();
  }

  void _addThreatZone() async {
    if (_zoneNameController.text.isEmpty ||
        _zoneLatController.text.isEmpty ||
        _zoneLngController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out Name, Latitude, and Longitude')),
      );
      return;
    }

    final lat = double.tryParse(_zoneLatController.text);
    final lng = double.tryParse(_zoneLngController.text);
    final rad = double.tryParse(_zoneRadiusController.text) ?? 300.0;

    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Latitude and Longitude must be valid numbers')),
      );
      return;
    }

    final appState = Provider.of<AppState>(context, listen: false);
    await appState.adminAddUnsafePlace(
      _zoneNameController.text.trim(),
      lat,
      lng,
      rad,
      _riskLevel,
      _zoneDescController.text.trim(),
    );

    setState(() {
      _zoneNameController.clear();
      _zoneLatController.clear();
      _zoneLngController.clear();
      _zoneRadiusController.text = '300';
      _zoneDescController.clear();
      _riskLevel = 'Moderate Risk';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Threat Zone added successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.primaryBlue),
            ),
            const SizedBox(width: 12),
            const Text(
              'SHRI Admin Console',
              style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ],
        ),
        leading: !isDesktop 
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        actions: [
          if (isDesktop)
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.exit_to_app_rounded, size: 16),
                label: const Text('Exit to App'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryBlue,
                  side: const BorderSide(color: AppColors.primaryBlue),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar for wide screens
          if (isDesktop) _buildSidebar(),
          
          // Main content workspace
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isDesktop ? 24.0 : 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!isDesktop) _buildMobileTabs(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _buildSelectedView(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          _SidebarItem(
            icon: Icons.map_outlined,
            selectedIcon: Icons.map_rounded,
            title: 'Live Safety Map & SOS',
            selected: _selectedTab == 0,
            onTap: () => setState(() => _selectedTab = 0),
          ),
          _SidebarItem(
            icon: Icons.gpp_bad_outlined,
            selectedIcon: Icons.gpp_bad_rounded,
            title: 'Threat Hotspots',
            selected: _selectedTab == 1,
            onTap: () => setState(() => _selectedTab = 1),
          ),
          _SidebarItem(
            icon: Icons.verified_user_outlined,
            selectedIcon: Icons.verified_user_rounded,
            title: 'User Verification',
            selected: _selectedTab == 2,
            onTap: () => setState(() => _selectedTab = 2),
          ),
          _SidebarItem(
            icon: Icons.analytics_outlined,
            selectedIcon: Icons.analytics_rounded,
            title: 'Analytics Reports',
            selected: _selectedTab == 3,
            onTap: () => setState(() => _selectedTab = 3),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'v4.2.0 (Prod Build)',
              style: TextStyle(color: AppColors.textMuted.withOpacity(0.6), fontSize: 11, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildMobileTabItem(0, 'Safety Map', Icons.map_rounded),
          const SizedBox(width: 8),
          _buildMobileTabItem(1, 'Threat Zones', Icons.gpp_bad_rounded),
          const SizedBox(width: 8),
          _buildMobileTabItem(2, 'Verification', Icons.verified_user_rounded),
          const SizedBox(width: 8),
          _buildMobileTabItem(3, 'Analytics', Icons.analytics_rounded),
        ],
      ),
    );
  }

  Widget _buildMobileTabItem(int index, String title, IconData icon) {
    final isSelected = _selectedTab == index;
    return ChoiceChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: isSelected ? Colors.white : AppColors.textMuted),
          const SizedBox(width: 6),
          Text(title),
        ],
      ),
      selectedColor: AppColors.primaryBlue,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textDark,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedTab = index);
        }
      },
    );
  }

  Widget _buildSelectedView() {
    switch (_selectedTab) {
      case 0:
        return _buildRadarAndSOSLogs();
      case 1:
        return _buildThreatZonesView();
      case 2:
        return _buildUserManagementView();
      case 3:
        return _buildAnalyticsView();
      default:
        return const SizedBox();
    }
  }

  // TAB 1: Live Safety Map & SOS Logs
  Widget _buildRadarAndSOSLogs() {
    final appState = Provider.of<AppState>(context);
    final dbService = appState.dbService;
    
    final activeAlerts = appState.alertsHistory.where((a) => a.status == 'active').toList();
    final isWide = MediaQuery.of(context).size.width > 1000;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Status indicator row
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              'Live Safety Dashboard',
              style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.w800),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: activeAlerts.isNotEmpty ? AppColors.danger.withOpacity(0.1) : AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: activeAlerts.isNotEmpty ? AppColors.danger : AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    activeAlerts.isNotEmpty 
                        ? '${activeAlerts.length} Active SOS Signals' 
                        : 'System Secure – No Alerts',
                    style: TextStyle(
                      color: activeAlerts.isNotEmpty ? AppColors.danger : AppColors.success,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Expanded safety map and emergency logs panel
        Expanded(
          child: Flex(
            direction: isWide ? Axis.horizontal : Axis.vertical,
            children: [
              // Safety Map Workspace
              Expanded(
                flex: 3,
                child: Card(
                  elevation: 0.5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      // OpenStreetMap live safety tracker
                      FutureBuilder<List<UserModel>>(
                        future: dbService.adminFetchUsers(),
                        builder: (context, snapshot) {
                          final allUsers = snapshot.data ?? [];
                          
                          // Determine map initial center based on active alert or default to Pune
                          LatLng mapCenter = const LatLng(18.5204, 73.8567);
                          if (activeAlerts.isNotEmpty) {
                            mapCenter = LatLng(activeAlerts.first.latitude, activeAlerts.first.longitude);
                          } else if (appState.currentPosition != null) {
                            mapCenter = LatLng(appState.currentPosition!.latitude, appState.currentPosition!.longitude);
                          }

                          return FlutterMap(
                            mapController: _adminMapController,
                            options: MapOptions(
                              initialCenter: mapCenter,
                              initialZoom: 13.0,
                              interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.basic.hutter',
                              ),
                              
                              // Unsafe high-risk zones marked in red circles
                              CircleLayer(
                                circles: appState.unsafePlaces.map((zone) {
                                  final isHigh = zone.riskLevel == 'High Risk';
                                  return CircleMarker(
                                    point: LatLng(zone.latitude, zone.longitude),
                                    radius: zone.radius,
                                    useRadiusInMeter: true,
                                    color: isHigh ? AppColors.danger.withOpacity(0.22) : Colors.orange.withOpacity(0.22),
                                    borderColor: isHigh ? AppColors.danger.withOpacity(0.5) : Colors.orange.withOpacity(0.5),
                                    borderStrokeWidth: 1.5,
                                  );
                                }).toList(),
                              ),
                              
                              // Markers (Realtime User locations, SOS alerts, simulated guardians, incidents)
                              MarkerLayer(
                                markers: [
                                  // 1. Regular active user locations (Green markers)
                                  ...allUsers.where((u) => !u.isBlocked).map((u) {
                                    final hasActiveSos = activeAlerts.any((a) => a.userId == u.uid);
                                    if (hasActiveSos) return const Marker(point: LatLng(0,0), child: SizedBox()); // Handled by active SOS marker
                                    return Marker(
                                      point: LatLng(u.latitude, u.longitude),
                                      width: 40,
                                      height: 40,
                                      child: GestureDetector(
                                        onTap: () => _showUserDetailOverlay(u),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(4),
                                                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                                              ),
                                              child: Text(u.name, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                            ),
                                            const Icon(Icons.location_on_rounded, color: AppColors.success, size: 24),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  
                                  // 2. Active SOS Alerts (Pulsing Red markers)
                                  ...activeAlerts.map((alert) {
                                    return Marker(
                                      point: LatLng(alert.latitude, alert.longitude),
                                      width: 80,
                                      height: 80,
                                      child: GestureDetector(
                                        onTap: () => _showEmergencyAlertOverlay(alert),
                                        child: Center(
                                          child: _PulseMarkerGlow(label: alert.userName),
                                        ),
                                      ),
                                    );
                                  }).toList(),

                                  // 3. Simulated Guardian Location tracking (Blue shields)
                                  if (appState.guardianPosition != null)
                                    Marker(
                                      point: appState.guardianPosition!,
                                      width: 40,
                                      height: 40,
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryBlue,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: const Text("GUARDIAN", style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold)),
                                          ),
                                          const Icon(Icons.security_rounded, color: AppColors.primaryBlue, size: 24),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      
                      // Map center overlay actions
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "LIVE SAFETY MAP (OpenStreetMap)",
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              if (isWide) const SizedBox(width: 16) else const SizedBox(height: 16),
              
              // SOS Logs Table on Right / Bottom
              Expanded(
                flex: 2,
                child: Card(
                  elevation: 0.5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Emergency Alert Monitoring',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textDark),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: StreamBuilder<List<AlertModel>>(
                            stream: dbService.getActiveAlertsStream(),
                            builder: (context, snapshot) {
                              final active = snapshot.data ?? [];
                              if (active.isEmpty) {
                                return _buildEmptyState('No active emergency dispatches.');
                              }
                              return ListView.separated(
                                itemCount: active.length,
                                separatorBuilder: (_, __) => const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final alert = active[index];
                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                                    leading: CircleAvatar(
                                      backgroundColor: AppColors.danger.withOpacity(0.1),
                                      child: const Icon(Icons.warning_rounded, color: AppColors.danger),
                                    ),
                                    title: Text(alert.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                    subtitle: Text(
                                      '${alert.address}\nBattery: ${alert.batteryLevel}% | ${alert.isVoiceTriggered ? "VOICE SOS" : "PANIC BUTTON"}',
                                      style: const TextStyle(fontSize: 11, height: 1.3),
                                    ),
                                    trailing: TextButton(
                                      onPressed: () async {
                                        await dbService.resolveAlert(alert.id, "Emergency marked resolved by administrator.");
                                        await dbService.deleteLiveLocation(alert.userId);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('SOS resolved and dispatched units dismissed.')),
                                        );
                                      },
                                      child: const Text('RESOLVE', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 11)),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Tapping map markers details helper
  void _showUserDetailOverlay(UserModel user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.person_pin_circle_rounded, color: AppColors.success),
              const SizedBox(width: 10),
              Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Email: ${user.email}", style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 6),
              Text("Phone: ${user.phone}", style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 6),
              Text("Address: ${user.address}", style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 6),
              Text("Guardian: ${user.guardianName} (${user.guardianRelation})", style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 6),
              Text("Safety Score: ${user.safetyScore}%", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.success)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            )
          ],
        );
      },
    );
  }

  void _showEmergencyAlertOverlay(AlertModel alert) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.danger.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.emergency_share_rounded, color: AppColors.danger),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${alert.userName} - ACTIVE SOS", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.danger)),
                        Text("Triggered: ${alert.timestamp.toString().substring(11, 19)}", style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text("Location Address: ${alert.address}", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("Coordinates: (${alert.latitude.toStringAsFixed(5)}, ${alert.longitude.toStringAsFixed(5)})", style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 8),
              Text("Battery Status: ${alert.batteryLevel}%", style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 8),
              Text("Trigger Source: ${alert.isVoiceTriggered ? 'AI Background Voice Command' : 'Panic Button Interface'}", style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: () {
                        // Center map on alert location
                        _adminMapController.move(LatLng(alert.latitude, alert.longitude), 16.0);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.gps_fixed_rounded, color: Colors.white),
                      label: const Text("Focus Map", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primaryBlue), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Dismiss", style: TextStyle(color: AppColors.primaryBlue)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // TAB 2: Threat Zones
  Widget _buildThreatZonesView() {
    final appState = Provider.of<AppState>(context);
    final isWide = MediaQuery.of(context).size.width > 900;

    final listWidget = appState.unsafePlaces.isEmpty
        ? _buildEmptyState('No risk areas listed.')
        : ListView.separated(
            shrinkWrap: !isWide,
            physics: isWide ? const ScrollPhysics() : const NeverScrollableScrollPhysics(),
            itemCount: appState.unsafePlaces.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final zone = appState.unsafePlaces[index];
              final isHigh = zone.riskLevel == 'High Risk';
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isHigh ? AppColors.danger.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.gpp_bad_rounded,
                    color: isHigh ? AppColors.danger : Colors.orange,
                    size: 20,
                  ),
                ),
                title: Text(zone.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(
                  'Coordinates: (${zone.latitude.toStringAsFixed(4)}, ${zone.longitude.toStringAsFixed(4)})\nRadius: ${zone.radius.round()}m | ${zone.description}',
                  style: const TextStyle(height: 1.3),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isHigh ? AppColors.danger.withOpacity(0.15) : Colors.orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    zone.riskLevel,
                    style: TextStyle(
                      color: isHigh ? AppColors.danger : Colors.orange,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );

    final listCard = Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Active Unsafe Zones / Threat Boundaries',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textDark),
            ),
            const SizedBox(height: 16),
            isWide ? Expanded(child: listWidget) : listWidget,
          ],
        ),
      ),
    );

    final formCard = Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Add New Unsafe Boundary',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textDark),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _zoneNameController,
              decoration: InputDecoration(
                labelText: 'Zone Name / Area Name',
                hintText: 'e.g., Dark Alley behind Subway',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _zoneLatController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Latitude',
                      hintText: 'e.g., 40.7128',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _zoneLngController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Longitude',
                      hintText: 'e.g., -74.0060',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _zoneRadiusController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Threat Radius (meters)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _riskLevel,
              decoration: InputDecoration(
                labelText: 'Risk Level',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: const [
                DropdownMenuItem(value: 'High Risk', child: Text('High Risk')),
                DropdownMenuItem(value: 'Moderate Risk', child: Text('Moderate Risk')),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() => _riskLevel = val);
                }
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _zoneDescController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Boundary Description',
                hintText: 'Describe details like poor lighting or frequent reports',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _addThreatZone,
                child: const Text('Broadcast Unsafe Zone', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: listCard,
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: formCard,
          ),
        ],
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            formCard,
            const SizedBox(height: 16),
            listCard,
          ],
        ),
      );
    }
  }  // TAB 3: User Verification & Management (Approval, Rejections, Blocks, Activities, Aadhaar Viewer)
  Widget _buildUserManagementView() {
    final appState = Provider.of<AppState>(context);
    final dbService = appState.dbService;
    final isWide = MediaQuery.of(context).size.width > 900;

    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Segmented directory filters (Responsive layout)
            isWide
                ? Row(
                    children: [
                      _buildVerificationSubTab(0, "Pending Approvals"),
                      const SizedBox(width: 8),
                      _buildVerificationSubTab(1, "Verified Directory"),
                      const SizedBox(width: 8),
                      _buildVerificationSubTab(2, "Blocked Users"),
                      const Spacer(),
                      SizedBox(
                        width: 250,
                        height: 38,
                        child: TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Search by name/email...',
                            prefixIcon: const Icon(Icons.search_rounded, size: 16),
                            contentPadding: const EdgeInsets.symmetric(vertical: 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: AppColors.border),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildVerificationSubTab(0, "Pending Approvals"),
                            const SizedBox(width: 8),
                            _buildVerificationSubTab(1, "Verified Directory"),
                            const SizedBox(width: 8),
                            _buildVerificationSubTab(2, "Blocked Users"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 38,
                        child: TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Search by name/email...',
                            prefixIcon: const Icon(Icons.search_rounded, size: 16),
                            contentPadding: const EdgeInsets.symmetric(vertical: 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: AppColors.border),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 20),
            
            // User List Builder
            Expanded(
              child: FutureBuilder<List<UserModel>>(
                future: dbService.adminFetchUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue));
                  }
                  
                  final users = snapshot.data ?? [];
                  
                  // Filter users based on tab index and search query
                  final query = _searchController.text.trim().toLowerCase();
                  final filteredUsers = users.where((u) {
                    // Match tab filter
                    bool matchesFilter = false;
                    if (_verificationFilter == 0) {
                      matchesFilter = u.verificationStatus == 'pending' && !u.isBlocked;
                    } else if (_verificationFilter == 1) {
                      matchesFilter = u.verificationStatus == 'approved' && !u.isBlocked;
                    } else if (_verificationFilter == 2) {
                      matchesFilter = u.isBlocked;
                    }
                    
                    // Match search query
                    final matchesSearch = u.name.toLowerCase().contains(query) || 
                                          u.email.toLowerCase().contains(query);
                                          
                    return matchesFilter && matchesSearch;
                  }).toList();

                  if (filteredUsers.isEmpty) {
                    return _buildEmptyState('No matching users found in this directory.');
                  }

                  return ListView.separated(
                    itemCount: filteredUsers.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      
                      final aadhaarColumn = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Aadhaar Card Verification Image", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textDark)),
                          const SizedBox(height: 8),
                          user.aadhaarImageUrl.isNotEmpty
                              ? InkWell(
                                  onTap: () => _viewAadhaarDialog(user.aadhaarImageUrl, user.name),
                                  child: Container(
                                    height: 120,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: AppColors.border),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        user.aadhaarImageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image_rounded)),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Text("No Aadhaar card image uploaded", style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                  ),
                                ),
                        ],
                      );

                      final residenceColumn = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Current Residence Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textDark)),
                          const SizedBox(height: 6),
                          Text(user.address, style: const TextStyle(fontSize: 12, height: 1.3)),
                          const SizedBox(height: 12),
                          const Text("Guardian Circle Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textDark)),
                          const SizedBox(height: 6),
                          Text("Name: ${user.guardianName}\nRelationship: ${user.guardianRelation}\nEmergency Phone: ${user.guardianPhone}", style: const TextStyle(fontSize: 12, height: 1.3)),
                        ],
                      );

                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: user.isBlocked 
                                ? AppColors.danger.withOpacity(0.1) 
                                : AppColors.primaryBlue.withOpacity(0.1),
                            child: Icon(
                              user.isBlocked 
                                  ? Icons.block_rounded 
                                  : (user.verificationStatus == 'approved' ? Icons.verified_rounded : Icons.pending_actions_rounded),
                              color: user.isBlocked 
                                  ? AppColors.danger 
                                  : (user.verificationStatus == 'approved' ? AppColors.success : AppColors.primaryBlue),
                            ),
                          ),
                          title: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              Text(
                                user.email, 
                                style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.normal)
                              ),
                            ],
                          ),
                          subtitle: Text(
                            'DOB: ${user.dob} | Phone: ${user.phone}\nGuardian: ${user.guardianName} (${user.guardianRelation}) - ${user.guardianPhone}',
                            style: const TextStyle(fontSize: 11, height: 1.4),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  isWide
                                      ? Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(flex: 2, child: aadhaarColumn),
                                            const SizedBox(width: 16),
                                            Expanded(flex: 3, child: residenceColumn),
                                          ],
                                        )
                                      : Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            aadhaarColumn,
                                            const SizedBox(height: 16),
                                            residenceColumn,
                                          ],
                                        ),
                                  const SizedBox(height: 16),
                                  
                                  // User Activity Logs
                                  const Text("User Activity Track Logs", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textDark)),
                                  const SizedBox(height: 8),
                                  Container(
                                    constraints: const BoxConstraints(maxHeight: 120),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50]!,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey[200]!),
                                    ),
                                    child: user.activityLog.isEmpty
                                        ? const Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Text("No activity logs recorded.", style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                          )
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: user.activityLog.length,
                                            itemBuilder: (context, idx) {
                                              final log = user.activityLog[idx];
                                              final action = log['action'] ?? 'Unknown Action';
                                              final rawTime = log['timestamp'] ?? '';
                                              final formattedTime = rawTime.length > 19 ? rawTime.substring(0, 19).replaceFirst('T', ' ') : rawTime;
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.history_toggle_off_rounded, size: 14, color: AppColors.textMuted.withOpacity(0.8)),
                                                    const SizedBox(width: 8),
                                                    Expanded(child: Text(action, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600))),
                                                    Text(formattedTime, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Action Buttons
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (_verificationFilter == 0) ...[
                                        // Pending options
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, elevation: 0),
                                          onPressed: () async {
                                            await dbService.adminUpdateVerificationStatus(user.uid, 'approved');
                                            await dbService.logUserActivity(user.uid, 'Account verification approved by administrator.');
                                            setState(() {});
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Account for ${user.name} approved.')),
                                            );
                                          },
                                          icon: const Icon(Icons.check, size: 16, color: Colors.white),
                                          label: const Text('Approve Account', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                        ),
                                        const SizedBox(width: 8),
                                        OutlinedButton.icon(
                                          style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.danger)),
                                          onPressed: () async {
                                            await dbService.adminUpdateVerificationStatus(user.uid, 'rejected');
                                            await dbService.logUserActivity(user.uid, 'Account verification rejected by administrator.');
                                            setState(() {});
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Account for ${user.name} rejected.')),
                                            );
                                          },
                                          icon: const Icon(Icons.close, size: 16, color: AppColors.danger),
                                          label: const Text('Reject', style: TextStyle(color: AppColors.danger)),
                                        ),
                                      ] else if (_verificationFilter == 1) ...[
                                        // Approved active options
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger, elevation: 0),
                                          onPressed: () async {
                                            await dbService.adminSetBlockedStatus(user.uid, true);
                                            await dbService.logUserActivity(user.uid, 'Account suspended / blocked by administrator.');
                                            setState(() {});
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Account for ${user.name} blocked.')),
                                            );
                                          },
                                          icon: const Icon(Icons.block, size: 16, color: Colors.white),
                                          label: const Text('Block User', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                        ),
                                      ] else if (_verificationFilter == 2) ...[
                                        // Blocked options
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, elevation: 0),
                                          onPressed: () async {
                                            await dbService.adminSetBlockedStatus(user.uid, false);
                                            await dbService.logUserActivity(user.uid, 'Account suspension lifted / unblocked by administrator.');
                                            setState(() {});
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Suspension lifted for ${user.name}.')),
                                            );
                                          },
                                          icon: const Icon(Icons.refresh, size: 16, color: Colors.white),
                                          label: const Text('Lift Block / Restore', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationSubTab(int index, String title) {
    final isSelected = _verificationFilter == index;
    return ChoiceChip(
      selected: isSelected,
      label: Text(title, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : AppColors.textDark, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      selectedColor: AppColors.primaryBlue,
      onSelected: (selected) {
        if (selected) {
          setState(() => _verificationFilter = index);
        }
      },
    );
  }

  void _viewAadhaarDialog(String url, String name) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(12),
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 4.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    title: Text("$name - Aadhaar Card", style: const TextStyle(color: AppColors.textDark, fontSize: 15, fontWeight: FontWeight.bold)),
                    leading: IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textDark),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      url,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image, size: 64)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // TAB 4: Analytics
  Widget _buildAnalyticsView() {
    final isWide = MediaQuery.of(context).size.width > 800;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'System Security Index Insights',
            style: TextStyle(color: AppColors.textDark, fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          // Analytics Summary Cards (Responsive Layout)
          isWide
              ? Row(
                  children: [
                    Expanded(child: _buildMetricCard('Total System Installs', '2,481', Icons.install_mobile_rounded, AppColors.primaryBlue)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildMetricCard('Emergency Dispatches', '43 Active / 182 Total', Icons.crisis_alert_rounded, AppColors.danger)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildMetricCard('AI Safety Score Mean', '92.4 %', Icons.shield_rounded, AppColors.success)),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildMetricCard('Total System Installs', '2,481', Icons.install_mobile_rounded, AppColors.primaryBlue),
                    const SizedBox(height: 12),
                    _buildMetricCard('Emergency Dispatches', '43 Active / 182 Total', Icons.crisis_alert_rounded, AppColors.danger),
                    const SizedBox(height: 12),
                    _buildMetricCard('AI Safety Score Mean', '92.4 %', Icons.shield_rounded, AppColors.success),
                  ],
                ),
          const SizedBox(height: 24),
          // Chart Mockups
          Card(
            elevation: 0.5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Daily SOS Trigger Events (Last 7 Days)',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 180,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildBar(4, 'Mon'),
                        _buildBar(1, 'Tue'),
                        _buildBar(8, 'Wed'),
                        _buildBar(14, 'Thu', active: true),
                        _buildBar(5, 'Fri'),
                        _buildBar(12, 'Sat'),
                        _buildBar(2, 'Sun'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(value, style: const TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(int val, String day, {bool active = false}) {
    final heightFactor = val / 15.0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(val.toString(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: active ? AppColors.primaryBlue : AppColors.textMuted)),
        const SizedBox(height: 6),
        Container(
          width: 24,
          height: 130 * heightFactor,
          decoration: BoxDecoration(
            color: active ? AppColors.primaryBlue : AppColors.primaryBlue.withOpacity(0.2),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ),
        const SizedBox(height: 6),
        Text(day, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark)),
      ],
    );
  }

  Widget _buildEmptyState(String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_rounded, color: AppColors.textMuted.withOpacity(0.4), size: 40),
          const SizedBox(height: 12),
          Text(text, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.icon,
    required this.selectedIcon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryBlue.withOpacity(0.04) : Colors.transparent,
          border: selected 
              ? const Border(left: BorderSide(color: AppColors.primaryBlue, width: 4))
              : null,
        ),
        child: Row(
          children: [
            Icon(
              selected ? selectedIcon : icon,
              color: selected ? AppColors.primaryBlue : AppColors.textMuted,
              size: 22,
            ),
            const SizedBox(width: 14),
            Text(
              title,
              style: TextStyle(
                color: selected ? AppColors.primaryBlue : AppColors.textDark,
                fontWeight: selected ? FontWeight.bold : FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PulseMarkerGlow extends StatefulWidget {
  const _PulseMarkerGlow({required this.label});
  final String label;

  @override
  State<_PulseMarkerGlow> createState() => _PulseMarkerGlowState();
}

class _PulseMarkerGlowState extends State<_PulseMarkerGlow> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            return Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.danger.withOpacity(0.3 + (0.7 * _ctrl.value)),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.danger.withOpacity(0.5),
                    blurRadius: 10 * _ctrl.value,
                    spreadRadius: 3 * _ctrl.value,
                  )
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.danger,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            widget.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
