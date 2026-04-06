class RouteMapClientModel {
  final int clientId;
  final String clientName;
  final int routeId;
  final String routeName;
  final String invoiceDate;
  final int sortOrder;
  final String profilePicUrl;
  final double latitude;
  final double longitude;

  const RouteMapClientModel({
    required this.clientId,
    required this.clientName,
    required this.routeId,
    required this.routeName,
    required this.invoiceDate,
    required this.sortOrder,
    required this.profilePicUrl,
    required this.latitude,
    required this.longitude,
  });

  factory RouteMapClientModel.fromJson(Map<String, dynamic> json) {
    return RouteMapClientModel(
      clientId: _readInt(_readValue(json, const ['clientId', 'ClientId'])),
      clientName: _readString(json, const ['clientName', 'ClientName']),
      routeId: _readInt(_readValue(json, const ['routeId', 'RouteId'])),
      routeName: _readString(json, const ['routeName', 'RouteName']),
      invoiceDate: _readString(json, const ['invoiceDate', 'InvoiceDate']),
      sortOrder: _readInt(
        _readValue(
          json,
          const ['clientSortOrder', 'ClientSortOrder', 'sortOrder'],
        ),
      ),
      profilePicUrl: _readString(
        json,
        const ['profilePicUrl', 'ProfilePicUrl'],
      ),
      latitude: _readDouble(_readValue(json, const ['latitude', 'Latitude'])),
      longitude:
          _readDouble(_readValue(json, const ['longitude', 'Longitude'])),
    );
  }

  bool get hasValidLocation => latitude != 0 && longitude != 0;

  static int _readInt(dynamic value) {
    if (value is int) {
      return value;
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _readDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static dynamic _readValue(Map<String, dynamic> json, List<String> keys) {
    for (final String key in keys) {
      if (json.containsKey(key)) {
        return json[key];
      }
    }
    return null;
  }

  static String _readString(Map<String, dynamic> json, List<String> keys) {
    final dynamic value = _readValue(json, keys);
    return value?.toString() ?? '';
  }
}
