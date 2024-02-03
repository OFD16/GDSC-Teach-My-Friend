import 'dart:io';

import 'package:Sharey/models/User.dart';
import 'package:Sharey/providers/auth_user_provider.dart';
import 'package:Sharey/services/cloud_storage_services.dart';
import 'package:Sharey/services/image_picker_services.dart';
import 'package:Sharey/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  final ImagePickerService _imagePickerService = ImagePickerService();
  final CloudStorageService _cloudStorageService = CloudStorageService();
  final UserService _userService = UserService();
  List<String> _imageUrls = [];
  bool _isUploading = false;

  // Use this method to open the image picker for selecting multiple images.
  void _pickImages(User user) async {
    XFile? image = await _imagePickerService.pickImageFromGallery();
    if (image != null) {
      File file = File(image.path);
      setState(() {
        _imageUrls = [];
        _isUploading = true;
      });
      String? downloadUrl = await _cloudStorageService.uploadFile(
          file, "lessonId+${image.name}+${DateTime.now()}", "user_images");
      print("downloadUrl: $downloadUrl");

      user.photoUrl = downloadUrl;
      _userService.updateUser(user);
      setState(() {
        _imageUrls.add(downloadUrl!);

        _isUploading = false;
      });
    }
  }

  // Use this method to open the camera for capturing an image.
  void _captureImage(User user) async {
    XFile? image = await _imagePickerService.captureImageFromCamera();
    if (image != null) {
      File file = File(image.path);

      setState(() {
        _imageUrls = [];
        _isUploading = true;
      });
      // Process the captured image
      String? downloadUrl = await _cloudStorageService.uploadFile(
          file, "${image.name}+${DateTime.now()}", "lesson_images");
      print("downloadUrl: $downloadUrl");

      user.photoUrl = downloadUrl;
      _userService.updateUser(user);
      setState(() {
        _imageUrls.add(downloadUrl!);

        _isUploading = false;
      });
    }
  }

  void openDialog(User user) {
    showAdaptiveDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog.adaptive(
        title: const Text("Select an option"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Capture an image"),
              onTap: () {
                Navigator.pop(context);
                _captureImage(user);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text("Select from gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImages(user);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthUserProvider authUserProvider =
        Provider.of<AuthUserProvider>(context, listen: false);
    User? authUser = authUserProvider.authUser;
    print("authUser: $authUser");
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundImage: authUser != null &&
                    authUser.photoUrl != null &&
                    authUser.photoUrl != ""
                ? NetworkImage(authUser.photoUrl!) as ImageProvider
                : const AssetImage("assets/images/profile_image.jpg"),
          ),
          authUser != null
              ? Positioned(
                  right: -16,
                  bottom: 0,
                  child: InkWell(
                    onTap: () {
                      openDialog(authUser);
                    },
                    child: SizedBox(
                      height: 46,
                      width: 46,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: const BorderSide(color: Colors.white),
                          ),
                          backgroundColor: const Color(0xFFF5F6F9),
                        ),
                        onPressed: () {},
                        child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
