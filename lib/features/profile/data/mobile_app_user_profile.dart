import '../../auth/data/login_model.dart';

class MobileAppUserProfile {
  final int companyId;
  final int employeeId;
  final int? userId;
  final String userName;
  final String userPassword;
  final String name;
  final String mobile;
  final String phone;
  final String emailId;
  final String address;
  final String employeeImage;
  final String localImagePath;

  const MobileAppUserProfile({
    required this.companyId,
    required this.employeeId,
    required this.userId,
    required this.userName,
    required this.userPassword,
    required this.name,
    required this.mobile,
    required this.phone,
    required this.emailId,
    required this.address,
    required this.employeeImage,
    required this.localImagePath,
  });

  factory MobileAppUserProfile.fromLogin(LoginModel loginModel) {
    return MobileAppUserProfile(
      companyId: loginModel.companyId,
      employeeId: loginModel.employeeId,
      userId: loginModel.userId,
      userName: loginModel.userName,
      userPassword: loginModel.userPassword?.toString() ?? '',
      name: loginModel.employeeName,
      mobile: '',
      phone: '',
      emailId: '',
      address: '',
      employeeImage: '',
      localImagePath: '',
    );
  }

  factory MobileAppUserProfile.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> source = _unwrapProfile(json);

    return MobileAppUserProfile(
      companyId: _readInt(_readValue(source, const ['companyId', 'CompanyId'])),
      employeeId:
          _readInt(_readValue(source, const ['employeeId', 'EmployeeId'])),
      userId: _readNullableInt(_readValue(source, const ['userId', 'UserId'])),
      userName: _readString(source, const ['userName', 'UserName', 'username']),
      userPassword: _readString(
        source,
        const ['userPassword', 'UserPassword'],
      ),
      name: _readString(source, const ['name', 'Name', 'employeeName']),
      mobile: _readString(source, const ['mobile', 'Mobile']),
      phone: _readString(source, const ['phone', 'Phone']),
      emailId: _readString(source, const ['emailId', 'EmailId', 'email']),
      address: _readString(source, const ['address', 'Address']),
      employeeImage: _readString(
        source,
        const ['employeeImage', 'EmployeeImage', 'imageUrl', 'ImageUrl'],
      ),
      localImagePath:
          _readString(source, const ['localImagePath', 'LocalImagePath']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyId': companyId,
      'employeeId': employeeId,
      'userId': userId,
      'userName': userName,
      'userPassword': userPassword,
      'name': name,
      'mobile': mobile,
      'phone': phone,
      'emailId': emailId,
      'address': address,
      'employeeImage': employeeImage,
      'localImagePath': localImagePath,
    };
  }

  Map<String, dynamic> toRequestJson() {
    return {
      'CompanyId': companyId,
      'EmployeeId': employeeId,
      'UserId': userId,
      'UserName': userName.trim(),
      'UserPassword': userPassword.trim(),
      'Name': name.trim(),
      'Mobile': mobile.trim(),
      'Phone': phone.trim(),
      'EmailId': emailId.trim(),
      'Address': address.trim(),
      'EmployeeImage': employeeImage.trim(),
    };
  }

  MobileAppUserProfile copyWith({
    int? companyId,
    int? employeeId,
    int? userId,
    String? userName,
    String? userPassword,
    String? name,
    String? mobile,
    String? phone,
    String? emailId,
    String? address,
    String? employeeImage,
    String? localImagePath,
  }) {
    return MobileAppUserProfile(
      companyId: companyId ?? this.companyId,
      employeeId: employeeId ?? this.employeeId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPassword: userPassword ?? this.userPassword,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      phone: phone ?? this.phone,
      emailId: emailId ?? this.emailId,
      address: address ?? this.address,
      employeeImage: employeeImage ?? this.employeeImage,
      localImagePath: localImagePath ?? this.localImagePath,
    );
  }

  static int _readInt(dynamic value) {
    if (value is int) {
      return value;
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int? _readNullableInt(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    return int.tryParse(value.toString());
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

  static Map<String, dynamic> _unwrapProfile(Map<String, dynamic> json) {
    final dynamic directProfile = _readValue(
      json,
      const ['mobileAppUserProfile', 'MobileAppUserProfile', 'data', 'Data'],
    );
    if (directProfile is Map<String, dynamic>) {
      return directProfile;
    }
    return json;
  }
}
