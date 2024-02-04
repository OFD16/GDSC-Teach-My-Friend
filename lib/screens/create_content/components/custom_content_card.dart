import 'dart:io';

import 'package:Sharey/constants.dart';
import 'package:Sharey/services/cloud_storage_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/image_picker_services.dart';

class CustomContentCard extends StatefulWidget {
  String? imageUrl;
  final ValueChanged<Map<String, dynamic>>? onImageUploaded;
  String? imagePath;
  CustomContentCard(
      {super.key, this.onImageUploaded, this.imageUrl, this.imagePath});

  @override
  State<CustomContentCard> createState() => _CustomContentCardState();
}

const Color inActiveIconColor = Color(0xFFB6B6B6);

class _CustomContentCardState extends State<CustomContentCard> {
  final ImagePickerService _imagePickerService = ImagePickerService();
  final CloudStorageService _cloudStorageService = CloudStorageService();
  List<String> _imageUrls = [];
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    if (widget.imageUrl != null) {
      _imageUrls.add(widget.imageUrl!);
    }
  }

  // Use this method to open the image picker for selecting multiple images.
  void _pickImages() async {
    XFile? image = await _imagePickerService.pickImageFromGallery();
    if (image != null) {
      File file = File(image.path);
      setState(() {
        _imageUrls = [];
        _isUploading = true;
      });
      String? downloadUrl = await _cloudStorageService.uploadFile(
          file,
          "${image.name}+${DateTime.now()}",
          widget.imagePath ?? "lesson_images");
      print("downloadUrl: $downloadUrl");
      setState(() {
        _imageUrls.add(downloadUrl!);
        if (widget.onImageUploaded != null) {
          widget.onImageUploaded!({"imageUrls": _imageUrls, "type": "custom"});
        }
        _isUploading = false;
      });
    }
  }

  // Use this method to open the camera for capturing an image.
  void _captureImage() async {
    XFile? image = await _imagePickerService.captureImageFromCamera();
    if (image != null) {
      File file = File(image.path);

      setState(() {
        _imageUrls = [];
        _isUploading = true;
      });
      // Process the captured image
      String? downloadUrl = await _cloudStorageService.uploadFile(
          file,
          "${image.name}+${DateTime.now()}",
          widget.imagePath ?? "lesson_images");
      print("downloadUrl: $downloadUrl");
      setState(() {
        _imageUrls.add(downloadUrl!);
        if (widget.onImageUploaded != null) {
          widget.onImageUploaded!({"imageUrls": _imageUrls, "type": "custom"});
        }
        _isUploading = false;
      });
    }
  }

  void openDialog() {
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
                _captureImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text("Select from gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImages();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_imageUrls.isNotEmpty) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: InkWell(
          onTap: () => openDialog(),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(_imageUrls[0]),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: InkWell(
        onTap: () => openDialog(),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(
              color: inActiveIconColor,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Click to add your training\n image here!",
                textAlign: TextAlign.center,
              ),
              _isUploading
                  ? const CircularProgressIndicator(color: kPrimaryColor)
                  : Expanded(
                      child: SvgPicture.asset(
                        "assets/icons/image_gallery.svg",
                        width: 50,
                        height: 50,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
