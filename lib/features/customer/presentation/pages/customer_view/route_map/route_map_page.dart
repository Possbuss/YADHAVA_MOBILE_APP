import 'dart:convert';

import 'package:Yadhava/features/auth/data/login_model.dart';
import 'package:Yadhava/features/auth/domain/login_repo.dart';
import 'package:Yadhava/core/constants/color.dart';
import 'package:Yadhava/features/customer/data/route_map_client_model.dart';
import 'package:Yadhava/features/customer/domain/client_repo.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class RouteMapPage extends StatefulWidget {
  const RouteMapPage({super.key});

  @override
  State<RouteMapPage> createState() => _RouteMapPageState();
}

class _RouteMapPageState extends State<RouteMapPage> {
  static const String _cacheKeyPrefix = 'ROUTE_MAP_CLIENTS_';

  final GetClientListRepo _clientRepo = GetClientListRepo();
  final GetLoginRepo _loginRepo = GetLoginRepo();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  bool _isRefreshing = false;
  bool _isOpeningMap = false;
  String _errorMessage = '';
  String _searchQuery = '';
  List<RouteMapClientModel> _clients = const <RouteMapClientModel>[];

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadClients() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final LoginModel? loginModel = await _loginRepo.getUserLoginResponse();
      if (loginModel == null) {
        throw Exception('User session not found.');
      }

      final List<RouteMapClientModel> cachedClients = await _getCachedClients(
        loginModel.routeId,
      );
      if (cachedClients.isNotEmpty) {
        if (!mounted) {
          return;
        }
        setState(() {
          _clients = cachedClients;
          _isLoading = false;
        });
        return;
      }

      final List<RouteMapClientModel> clients = await _fetchClientsFromApi(
        loginModel: loginModel,
      );
      await _storeCachedClients(loginModel.routeId, clients);

      if (!mounted) {
        return;
      }

      setState(() {
        _clients = clients;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshClients() async {
    final LoginModel? loginModel = await _loginRepo.getUserLoginResponse();
    if (loginModel == null) {
      _showMessage('User session not found.');
      return;
    }

    setState(() {
      _isRefreshing = true;
      _errorMessage = '';
    });

    try {
      final List<RouteMapClientModel> clients = await _fetchClientsFromApi(
        loginModel: loginModel,
      );
      await _storeCachedClients(loginModel.routeId, clients);

      if (!mounted) {
        return;
      }

      setState(() {
        _clients = clients;
      });
      _showMessage('Route map data refreshed.');
    } catch (error) {
      _showMessage('Failed to refresh route data: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  Future<List<RouteMapClientModel>> _fetchClientsFromApi({
    required LoginModel loginModel,
  }) async {
    final response = await _clientRepo.getClientListActive(
      loginModel.companyId,
      loginModel.routeId,
      0,
    );

    if (response == null ||
        (response.statusCode != 200 && response.statusCode != 201)) {
      throw Exception('Unable to load route map clients.');
    }

    final dynamic data = response.data;
    if (data is! List) {
      throw Exception('Unexpected response for route map clients.');
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(RouteMapClientModel.fromJson)
        .toList()
      ..sort((a, b) {
        if (a.sortOrder == 0 && b.sortOrder == 0) {
          return a.clientName.toLowerCase().compareTo(
                b.clientName.toLowerCase(),
              );
        }
        if (a.sortOrder == 0) {
          return 1;
        }
        if (b.sortOrder == 0) {
          return -1;
        }
        return a.sortOrder.compareTo(b.sortOrder);
      });
  }

  Future<List<RouteMapClientModel>> _getCachedClients(int routeId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? rawJson = prefs.getString('$_cacheKeyPrefix$routeId');
    if (rawJson == null || rawJson.isEmpty) {
      return const <RouteMapClientModel>[];
    }

    try {
      final dynamic decoded = json.decode(rawJson);
      if (decoded is! List) {
        return const <RouteMapClientModel>[];
      }

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(RouteMapClientModel.fromJson)
          .toList();
    } catch (_) {
      return const <RouteMapClientModel>[];
    }
  }

  Future<void> _storeCachedClients(
    int routeId,
    List<RouteMapClientModel> clients,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '$_cacheKeyPrefix$routeId',
      json.encode(
        clients
            .map(
              (client) => <String, dynamic>{
                'clientId': client.clientId,
                'clientName': client.clientName,
                'routeId': client.routeId,
                'routeName': client.routeName,
                'invoiceDate': client.invoiceDate,
                'sortOrder': client.sortOrder,
                'profilePicUrl': client.profilePicUrl,
                'latitude': client.latitude,
                'longitude': client.longitude,
              },
            )
            .toList(),
      ),
    );
  }

  List<RouteMapClientModel> get _filteredClients {
    if (_searchQuery.isEmpty) {
      return _clients;
    }

    return _clients.where((client) {
      return client.clientName.toLowerCase().contains(_searchQuery) ||
          client.sortOrder.toString().contains(_searchQuery) ||
          client.routeName.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  Future<void> _openRouteMap() async {
    final List<RouteMapClientModel> routeClients =
        _clients.where((client) => client.hasValidLocation).toList();

    if (routeClients.isEmpty) {
      _showMessage('No valid client locations found for route map.');
      return;
    }

    setState(() {
      _isOpeningMap = true;
    });

    try {
      final Uri routeUri = _buildRouteUri(routeClients);
      if (!await launchUrl(routeUri, mode: LaunchMode.externalApplication)) {
        throw Exception('Unable to open route map.');
      }
    } catch (error) {
      _showMessage('Failed to open route map: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isOpeningMap = false;
        });
      }
    }
  }

  Uri _buildRouteUri(List<RouteMapClientModel> clients) {
    final RouteMapClientModel destination = clients.last;
    final List<RouteMapClientModel> waypoints = clients.length > 1
        ? clients.sublist(0, clients.length - 1)
        : const <RouteMapClientModel>[];

    return Uri.https('www.google.com', '/maps/dir/', <String, String>{
      'api': '1',
      'destination': '${destination.latitude},${destination.longitude}',
      'travelmode': 'driving',
      if (waypoints.isNotEmpty)
        'waypoints': waypoints
            .map((client) => '${client.latitude},${client.longitude}')
            .join('|'),
    });
  }

  Future<void> _openClientMap(RouteMapClientModel client) async {
    if (!client.hasValidLocation) {
      _showMessage('Location is not available for ${client.clientName}.');
      return;
    }

    final Uri mapUri = Uri.https(
      'www.google.com',
      '/maps/search/',
      <String, String>{
        'api': '1',
        'query': '${client.latitude},${client.longitude}',
      },
    );

    if (!await launchUrl(mapUri, mode: LaunchMode.externalApplication)) {
      _showMessage('Unable to open map for ${client.clientName}.');
    }
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<RouteMapClientModel> filteredClients = _filteredClients;
    final int mappedClients =
        _clients.where((client) => client.hasValidLocation).length;
    final String routeLabel = filteredClients.isNotEmpty
        ? filteredClients.first.routeName
        : (_clients.isNotEmpty ? _clients.first.routeName : 'Route');

    return Scaffold(
      backgroundColor: Colour.pBackgroundBlack,
      appBar: AppBar(
        backgroundColor: Colour.pBackgroundBlack,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Client Route Map'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _isRefreshing ? null : _refreshClients,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF232323), Color(0xFF171717)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:
                                  Colour.pDeepLightBlue.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.alt_route,
                              color: Colour.plightpurple,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  routeLabel.isNotEmpty
                                      ? routeLabel
                                      : 'Client Route',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Sorted stop list for faster field navigation',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricCard(
                              label: 'Clients',
                              value: filteredClients.length.toString(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildMetricCard(
                              label: 'Mapped',
                              value: mappedClients.toString(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.trim().toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by client, route, or sort order',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    suffixIcon: _searchQuery.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                            icon:
                                const Icon(Icons.clear, color: Colors.white70),
                          ),
                    filled: true,
                    fillColor: const Color(0xFF1F1F1F),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Colour.plightpurple,
                      ),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed:
                        _isRefreshing || _isLoading ? null : _refreshClients,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    icon: _isRefreshing
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.sync),
                    label: Text(
                      _isRefreshing ? 'Refreshing Data...' : 'Refresh Data',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isOpeningMap || _isLoading || _isRefreshing
                        ? null
                        : _openRouteMap,
                    icon: _isOpeningMap
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.navigation_rounded),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colour.pDeepLightBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    label: Text(
                      _isOpeningMap ? 'Opening Route Map...' : 'Open Route Map',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildBody(theme, filteredClients),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
      ThemeData theme, List<RouteMapClientModel> filteredClients) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.route_outlined,
                  size: 40,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 12),
                Text(
                  _errorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadClients,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (filteredClients.isEmpty) {
      return const Center(
        child: Text(
          'No clients found for this route.',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: filteredClients.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final RouteMapClientModel client = filteredClients[index];

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: const Color(0xFFF3EDF8),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE2D3FF),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    client.sortOrder > 0 ? client.sortOrder.toString() : '-',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2D1A57),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatClientName(
                          client.clientName.isNotEmpty
                              ? client.clientName
                              : 'Unnamed Client',
                        ),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF202028),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildInfoChip(
                            icon: Icons.route_outlined,
                            label: client.routeName.isNotEmpty
                                ? client.routeName
                                : client.routeId.toString(),
                          ),
                          _buildInfoChip(
                            icon: Icons.swap_vert_rounded,
                            label:
                                'Sort ${client.sortOrder > 0 ? client.sortOrder : '-'}',
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        icon: Icons.calendar_today_outlined,
                        text: client.invoiceDate.isNotEmpty
                            ? 'Last Invoice Date: ${client.invoiceDate}'
                            : 'Last Invoice Date not available',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.82),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    tooltip: 'Navigate',
                    onPressed: client.hasValidLocation
                        ? () => _openClientMap(client)
                        : null,
                    icon: Icon(
                      Icons.location_on_outlined,
                      color: client.hasValidLocation
                          ? const Color(0xFF4B3D69)
                          : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricCard({
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF5B4C7B)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF43375D),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF6D6480)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF4F4A58),
              fontSize: 15,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  String _formatClientName(String value) {
    final List<String> words = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();

    if (words.isEmpty) {
      return value;
    }

    return words
        .map(
          (word) => word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }
}
