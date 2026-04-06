import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:Yadhava/core/constants/api_constants.dart';
import 'package:Yadhava/core/constants/color.dart';
import 'package:Yadhava/features/profile/data/mobile_app_user_profile.dart';
import 'package:Yadhava/features/profile/domain/mobile_app_user_profile_repo.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
    required this.initialProfile,
  });

  final MobileAppUserProfile initialProfile;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final MobileAppUserProfileRepo _profileRepo = MobileAppUserProfileRepo();
  final ImagePicker _imagePicker = ImagePicker();

  late final TextEditingController _nameController;
  late final TextEditingController _userNameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _mobileController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;

  String _employeeImage = '';
  String _localImagePath = '';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialProfile.name);
    _userNameController =
        TextEditingController(text: widget.initialProfile.userName);
    _passwordController =
        TextEditingController(text: widget.initialProfile.userPassword);
    _mobileController =
        TextEditingController(text: widget.initialProfile.mobile);
    _phoneController = TextEditingController(text: widget.initialProfile.phone);
    _emailController =
        TextEditingController(text: widget.initialProfile.emailId);
    _addressController =
        TextEditingController(text: widget.initialProfile.address);
    _employeeImage = widget.initialProfile.employeeImage;
    _localImagePath = widget.initialProfile.localImagePath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    _mobileController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colour.pBackgroundBlack,
      appBar: AppBar(
        backgroundColor: Colour.pContainerBlack,
        foregroundColor: Colors.white,
        title: const Text('Edit Profile'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickProfileImage,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colour.plightpurple,
                                  width: 3,
                                ),
                              ),
                              child: ClipOval(child: _buildProfileImage()),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Colour.pDeepLightBlue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _pickProfileImage,
                        child: const Text('Change Profile Image'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildField(
                  controller: _nameController,
                  label: 'Name',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                _buildField(
                  controller: _userNameController,
                  label: 'User Name',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'User name is required';
                    }
                    return null;
                  },
                ),
                _buildField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: true,
                ),
                _buildField(
                  controller: _mobileController,
                  label: 'Mobile',
                  keyboardType: TextInputType.phone,
                ),
                _buildField(
                  controller: _phoneController,
                  label: 'Phone',
                  keyboardType: TextInputType.phone,
                ),
                _buildField(
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                _buildField(
                  controller: _addressController,
                  label: 'Address',
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colour.pDeepLightBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Update Profile'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool obscureText = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        obscureText: obscureText,
        maxLines: obscureText ? 1 : maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colour.pTextBoxColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          errorStyle: const TextStyle(color: Colors.orangeAccent),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    if (_localImagePath.isNotEmpty) {
      return Image.file(
        File(_localImagePath),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildAvatarFallback(),
      );
    }

    final Uint8List? memoryImage = _tryDecodeBase64Image(_employeeImage);
    if (memoryImage != null) {
      return Image.memory(
        memoryImage,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildAvatarFallback(),
      );
    }

    final String resolvedImageUrl = _resolveImageUrl(_employeeImage);
    if (resolvedImageUrl.isNotEmpty) {
      return Image.network(
        resolvedImageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildAvatarFallback(),
      );
    }

    return _buildAvatarFallback();
  }

  Uint8List? _tryDecodeBase64Image(String value) {
    if (value.trim().isEmpty) {
      return null;
    }

    final String normalizedValue =
        value.contains(',') ? value.substring(value.indexOf(',') + 1) : value;

    try {
      return base64Decode(normalizedValue);
    } catch (_) {
      return null;
    }
  }

  String _resolveImageUrl(String value) {
    final String trimmedValue = value.trim();
    if (trimmedValue.isEmpty) {
      return '';
    }

    if (trimmedValue.startsWith('http://') ||
        trimmedValue.startsWith('https://')) {
      return trimmedValue;
    }

    final String normalizedBaseUrl = ApiConstants.baseUrl.endsWith('/')
        ? ApiConstants.baseUrl
        : '${ApiConstants.baseUrl}/';
    final String normalizedPath =
        trimmedValue.startsWith('/') ? trimmedValue.substring(1) : trimmedValue;
    return '$normalizedBaseUrl$normalizedPath';
  }

  Widget _buildAvatarFallback() {
    final String name = _nameController.text.trim().isNotEmpty
        ? _nameController.text.trim()
        : widget.initialProfile.name;
    final String initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

    return Container(
      color: Colour.pContainerBlack,
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 34,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _pickProfileImage() async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Open Camera'),
                onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose From Gallery'),
                onTap: () =>
                    Navigator.of(sheetContext).pop(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (source == null) {
      return;
    }

    final XFile? file = await _imagePicker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1600,
      maxHeight: 1600,
      preferredCameraDevice: CameraDevice.front,
    );

    if (file == null) {
      return;
    }

    final String base64Image = base64Encode(await file.readAsBytes());
    final String localPath = await _saveProfileImageLocally(file);

    if (!mounted) {
      return;
    }

    setState(() {
      _employeeImage = base64Image;
      _localImagePath = localPath;
    });
  }

  Future<String> _saveProfileImageLocally(XFile file) async {
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final Directory profileDirectory = Directory(
      path.join(appDirectory.path, 'employee_profile_images'),
    );

    if (!await profileDirectory.exists()) {
      await profileDirectory.create(recursive: true);
    }

    final String extension = path.extension(file.path).isNotEmpty
        ? path.extension(file.path)
        : '.jpg';
    final String targetPath = path.join(
      profileDirectory.path,
      'employee_${widget.initialProfile.employeeId}$extension',
    );
    final File targetFile = File(targetPath);

    if (await targetFile.exists()) {
      await targetFile.delete();
    }

    await File(file.path).copy(targetPath);
    return targetPath;
  }

  Future<void> _saveProfile() async {
    if (_isSaving || !_formKey.currentState!.validate()) {
      return;
    }

    final MobileAppUserProfile updatedProfile = widget.initialProfile.copyWith(
      userName: _userNameController.text,
      userPassword: _passwordController.text,
      name: _nameController.text,
      mobile: _mobileController.text,
      phone: _phoneController.text,
      emailId: _emailController.text,
      address: _addressController.text,
      employeeImage: _employeeImage,
      localImagePath: _localImagePath,
    );

    setState(() {
      _isSaving = true;
    });

    try {
      await _profileRepo.updateProfile(updatedProfile);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully.')),
      );
      Navigator.of(context).pop(updatedProfile);
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}
