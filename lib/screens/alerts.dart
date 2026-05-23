import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/alert_model.dart';
import '../services/firestore_service.dart';
import '../state/app_state.dart';
import 'live_track.dart';
import 'ai_screen.dart';
import 'profile.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  int _tab = 0; // 0 = Safety Feed, 1 = Active SOS, 2 = SOS History

  String _formatTimestamp(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${dt.day}/${dt.month} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final dbService = appState.dbService;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.0),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: _AlertsBottomNav(
          currentIndex: 1,
          onChanged: (i) {
            if (i == 0) {
              Navigator.pop(context); // back to Home
            } else if (i == 2) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const AiScreen()),
              );
            } else if (i == 3) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            }
          },
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top title row
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
                child: Row(
                  children: [
                    Text(
                      _tab == 0 ? 'Notifications Feed' : 'Emergency Alerts',
                      style: const TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    if (_tab == 0 && appState.localNotifications.isNotEmpty)
                      TextButton.icon(
                        onPressed: () {
                          appState.clearNotifications();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          backgroundColor: AppColors.danger.withOpacity(0.08),
                        ),
                        icon: const Icon(Icons.delete_sweep_rounded, size: 16, color: AppColors.danger),
                        label: const Text(
                          'Clear Feed',
                          style: TextStyle(color: AppColors.danger, fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ),
                  ],
                ),
              ),

              // Segmented control
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: _SegmentedTabs(
                  tabs: const ['Safety Feed', 'Active SOS', 'SOS History'],
                  index: _tab,
                  onChanged: (v) => setState(() => _tab = v),
                ),
              ),
              const SizedBox(height: 14),

              // Dynamic List based on selected tab
              Expanded(
                child: _tab == 0
                    ? _buildSafetyFeed(appState)
                    : StreamBuilder<List<AlertModel>>(
                        stream: _tab == 1
                            ? dbService.getActiveAlertsStream()
                            : dbService.getResolvedAlertsStream(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(color: AppColors.primaryBlue),
                            );
                          }
                          final alerts = snapshot.data ?? [];
                          if (alerts.isEmpty) {
                            return _tab == 1
                                ? const _EmptyState(
                                    title: 'No Active Alerts',
                                    description: 'There are currently no active SOS alarms or triggers broadcasted in this area.',
                                    icon: Icons.shield_rounded,
                                  )
                                : const _EmptyState(
                                    title: 'No Past Alerts',
                                    description: 'Your safety history is clean. No past incidents recorded.',
                                    icon: Icons.history_rounded,
                                  );
                          }

                          return ListView.separated(
                            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                            itemCount: alerts.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final alert = alerts[index];
                              if (_tab == 1) {
                                return _LiveIncidentCard(alert: alert, dbService: dbService);
                              } else {
                                return _PastAlertTileItem(alert: alert);
                              }
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSafetyFeed(AppState appState) {
    final localNotifs = appState.localNotifications;
    if (localNotifs.isEmpty) {
      return const _EmptyState(
        title: 'Safety Feed Clean',
        description: 'Your personal safety logs, risk zone updates, and simulation events are empty.',
        icon: Icons.security_rounded,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      itemCount: localNotifs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = localNotifs[index];
        final title = item['title'] ?? 'Alert';
        final body = item['body'] ?? '';
        final type = item['type'] ?? 'info';
        final timestamp = DateTime.tryParse(item['timestamp'] ?? '') ?? DateTime.now();
        final timeStr = _formatTimestamp(timestamp);

        Color color;
        IconData icon;
        if (type == 'sos') {
          color = AppColors.danger;
          icon = Icons.shield_rounded;
        } else if (type == 'safe_zone') {
          color = Colors.orange;
          icon = Icons.warning_rounded;
        } else if (type == 'fake_call') {
          color = AppColors.purple;
          icon = Icons.phone_in_talk_rounded;
        } else if (type == 'system') {
          color = AppColors.primaryBlue;
          icon = Icons.settings_suggest_rounded;
        } else {
          color = AppColors.textMuted;
          icon = Icons.info_rounded;
        }

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE9ECF6)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      body,
                      style: TextStyle(
                        color: AppColors.textMuted.withOpacity(0.9),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      timeStr,
                      style: TextStyle(
                        color: AppColors.textMuted.withOpacity(0.6),
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({
    required this.tabs,
    required this.index,
    required this.onChanged,
  });

  final List<String> tabs;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE9ECF6)),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final idx = entry.key;
          final title = entry.value;
          final selected = idx == index;
          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => onChanged(idx),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: selected ? AppColors.primaryBlue : AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _LiveIncidentCard extends StatefulWidget {
  final AlertModel alert;
  final FirestoreService dbService;

  const _LiveIncidentCard({
    required this.alert,
    required this.dbService,
  });

  @override
  State<_LiveIncidentCard> createState() => _LiveIncidentCardState();
}

class _LiveIncidentCardState extends State<_LiveIncidentCard> {
  StreamSubscription? _sub;
  final List<LatLng> _pathPoints = [];
  LatLng? _currentLatLng;
  final MapController _mapController = MapController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    final initialPoint = LatLng(widget.alert.latitude, widget.alert.longitude);
    _currentLatLng = initialPoint;
    _pathPoints.add(initialPoint);

    _sub = widget.dbService.getLiveLocationStream(widget.alert.userId).listen((data) {
      if (data != null) {
        final lat = (data['latitude'] as num).toDouble();
        final lng = (data['longitude'] as num).toDouble();
        final newPoint = LatLng(lat, lng);
        if (mounted) {
          setState(() {
            _currentLatLng = newPoint;
            if (_pathPoints.isEmpty || _pathPoints.last != newPoint) {
              _pathPoints.add(newPoint);
            }
          });
          _mapController.move(newPoint, 15.0);
        }
      }
    });

    _timer = Timer.periodic(const Duration(seconds: 15), (t) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _timer.cancel();
    _mapController.dispose();
    super.dispose();
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'Started just now';
    if (diff.inMinutes < 60) return 'Started ${diff.inMinutes} mins ago';
    if (diff.inHours < 24) return 'Started ${diff.inHours} hours ago';
    return 'Started ${diff.inDays} days ago';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFFB3C4), width: 1.6),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF4D77).withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Chips Row
          Row(
            children: [
              _Pill(
                text: 'EMERGENCY TRIGGERED',
                bg: const Color(0xFFF5F6FA),
                fg: AppColors.textMuted.withOpacity(0.95),
                border: const Color(0xFFE8EBF4),
              ),
              const Spacer(),
              _Pill(
                text: 'IN PROGRESS',
                bg: const Color(0xFFFFE8EF),
                fg: const Color(0xFFFF4D77),
                border: const Color(0xFFFFD1DD),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Text(
            widget.alert.address,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Icon(Icons.schedule_rounded, size: 14, color: AppColors.textMuted.withOpacity(0.9)),
              const SizedBox(width: 6),
              Text(
                _timeAgo(widget.alert.timestamp),
                style: TextStyle(
                  color: AppColors.textMuted.withOpacity(0.95),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                widget.alert.isVoiceTriggered ? Icons.mic_none_rounded : Icons.touch_app_rounded,
                size: 14,
                color: AppColors.textMuted.withOpacity(0.9),
              ),
              const SizedBox(width: 6),
              Text(
                widget.alert.isVoiceTriggered ? 'Voice Command' : 'Panic Button',
                style: TextStyle(
                  color: AppColors.textMuted.withOpacity(0.95),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Map Preview using OpenStreetMap
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 120,
              width: double.infinity,
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _currentLatLng ?? LatLng(widget.alert.latitude, widget.alert.longitude),
                  initialZoom: 15.0,
                  interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.hutter',
                  ),

                  MarkerLayer(
                    markers: [
                      if (_currentLatLng != null)
                        Marker(
                          point: _currentLatLng!,
                          width: 40,
                          height: 40,
                          child: _PulseMarker(),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Buttons
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlue.withOpacity(0.20),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const LiveTrackScreen()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.map_rounded, size: 16, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'View Live',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () async {
                      await widget.dbService.resolveAlert(
                        widget.alert.id,
                        'Emergency resolved by user via Alerts Panel.',
                      );
                      await widget.dbService.deleteLiveLocation(widget.alert.userId);
                      final appState = Provider.of<AppState>(context, listen: false);
                      if (appState.activeAlert?.id == widget.alert.id) {
                        appState.cancelSOS('1234');
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Alert marked resolved and user marked safe.')),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: const Color(0xFFE6EAF4)),
                      ),
                      child: const Center(
                        child: Text(
                          "I'm Safe",
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.text,
    required this.bg,
    required this.fg,
    required this.border,
  });

  final String text;
  final Color bg;
  final Color fg;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: fg,
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.55,
        ),
      ),
    );
  }
}

class _PulseMarker extends StatefulWidget {
  @override
  State<_PulseMarker> createState() => _PulseMarkerState();
}

class _PulseMarkerState extends State<_PulseMarker> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 14 + (20 * _controller.value),
              height: 14 + (20 * _controller.value),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(1.0 - _controller.value),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const _EmptyState({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4FA),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE9ECF6)),
              ),
              child: Icon(
                icon,
                size: 40,
                color: AppColors.primaryBlue.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PastAlertTileItem extends StatelessWidget {
  final AlertModel alert;

  const _PastAlertTileItem({required this.alert});

  String _formatTimestamp(DateTime dt) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final month = months[dt.month - 1];
    final day = dt.day;
    final hour24 = dt.hour;
    final ampm = hour24 >= 12 ? 'PM' : 'AM';
    final hour = hour24 % 12 == 0 ? 12 : hour24 % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$month $day, $hour:$minute $ampm';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE9ECF6)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Color(0xFFEFF2FF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                alert.isVoiceTriggered ? Icons.mic_none_rounded : Icons.touch_app_rounded,
                color: AppColors.primaryBlue,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alert.address,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      height: 1.12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${alert.isVoiceTriggered ? "Voice Command" : "Panic Button"} • ${alert.aiMonitoringStatus}',
                    style: TextStyle(
                      color: AppColors.textMuted.withOpacity(0.95),
                      fontSize: 10.8,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTimestamp(alert.timestamp),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.textMuted.withOpacity(0.95),
                    fontSize: 10.6,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 6),
                Icon(Icons.chevron_right_rounded,
                    size: 20, color: AppColors.textMuted.withOpacity(0.55)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertsBottomNav extends StatelessWidget {
  const _AlertsBottomNav({
    required this.currentIndex,
    required this.onChanged,
  });

  final int currentIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, -10),
          )
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onChanged,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: const Color(0xFFB5B9C7),
        selectedLabelStyle: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_rounded),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy_rounded),
            label: 'AI Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}