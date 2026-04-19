import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/util/api_query.dart';

class ClientProfilePictureUploadResult {
  final String? profilePicUrl;

  const ClientProfilePictureUploadResult({this.profilePicUrl});
}

class ClientProfilePictureRepo {
  final Dio _dio = ApiClient().dio;
  final ApiQuery _apiQuery = ApiQuery();

  Future<ClientProfilePictureUploadResult> uploadProfilePicture({
    required int companyId,
    required int clientId,
    required XFile file,
  }) async {
    final String fileName = file.name.isNotEmpty
        ? file.name
        : 'client_$clientId.${_extensionFromPath(file.path)}';

    final formData = FormData.fromMap({
      'CompanyId': companyId,
      'ClientId': clientId,
      'File': await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    final response = await _dio.post(
      ApiConstants.uploadClientProfilePic,
      data: formData,
      options: await _apiQuery.authOptions(
        extraHeaders: const {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
          'Image upload failed with status ${response.statusCode}.');
    }

    return ClientProfilePictureUploadResult(
      profilePicUrl: _extractProfilePicUrl(response.data),
    );
  }

  String? _extractProfilePicUrl(dynamic data) {
    if (data is Map<String, dynamic>) {
      final directValue = _firstString(data, const [
        'profilePicUrl',
        'profilePictureUrl',
        'clientProfilePicUrl',
        'profilePic',
        'profilePicture',
        'imageUrl',
        'imagePath',
      ]);
      if (directValue != null && directValue.isNotEmpty) {
        return directValue;
      }

      final dynamic listValue = data['mobileAppClientsLists'];
      if (listValue is List &&
          listValue.isNotEmpty &&
          listValue.first is Map<String, dynamic>) {
        return _extractProfilePicUrl(listValue.first);
      }
    }

    return null;
  }

  String? _firstString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }

  String _extensionFromPath(String path) {
    final int index = path.lastIndexOf('.');
    if (index == -1 || index == path.length - 1) {
      return 'jpg';
    }
    return path.substring(index + 1);
  }
}
