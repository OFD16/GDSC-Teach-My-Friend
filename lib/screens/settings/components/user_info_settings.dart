import 'package:Sharey/local_storage/auth_storage.dart';
import 'package:Sharey/models/User.dart';
import 'package:Sharey/providers/auth_user_provider.dart';
import 'package:Sharey/screens/create_content/text_input.dart';
import 'package:Sharey/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class UserInfoSettings extends StatefulWidget {
  const UserInfoSettings({super.key});

  @override
  State<UserInfoSettings> createState() => _UserInfoSettingsState();
}

class _UserInfoSettingsState extends State<UserInfoSettings> {
  AuthStorage authStorage = AuthStorage();
  UserService userService = UserService();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void updateUser() async {
    bool checkIsNotEmpty() {
      return _firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _phoneNumberController.text.isNotEmpty &&
          _addressController.text.isNotEmpty &&
          _emailController.text.contains("@") &&
          _firstNameController.text.trim() != "" &&
          _lastNameController.text.trim() != "" &&
          _emailController.text.trim() != "" &&
          _phoneNumberController.text.trim() != "" &&
          _addressController.text.trim() != "";
    }

    AuthUserProvider authUserProvider =
        Provider.of<AuthUserProvider>(context, listen: false);
    User authUser = authUserProvider.authUser!;
    print("normal User: ${authUser.toJson()}");
    if (checkIsNotEmpty()) {
      authUser.firstName = _firstNameController.text;
      authUser.lastName = _lastNameController.text;
      authUser.email = _emailController.text;
      authUser.phoneNumber = _phoneNumberController.text;
      authUser.address = _addressController.text;
      authUser.updatedAt = DateTime.now();

      print("updated user: ${authUser.toJson()}");

      bool res = await userService.updateUser(authUser);
      if (res) {
        authUserProvider.setAuthUser(authUser);
        authStorage.setAuthUser(authUser);
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthUserProvider authUserProvider =
        Provider.of<AuthUserProvider>(context, listen: false);
    User authUser = authUserProvider.authUser!;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("User Info Settings",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          TextInput(
            controller: _firstNameController,
            title: "First Name",
            hintText: "Joe",
            prefixIcon: const Icon(Icons.person),
            initialValue: authUser.firstName,
          ),
          TextInput(
            controller: _lastNameController,
            title: "Last Name",
            hintText: "Smith",
            prefixIcon: const Icon(Icons.person),
            initialValue: authUser.lastName,
          ),
          TextInput(
            controller: _emailController,
            title: "Email",
            hintText: "user@gmail.com",
            prefixIcon: const Icon(Icons.mail),
            initialValue: authUser.email,
          ),
          Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "User Points",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "${authUser.points}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      SvgPicture.asset(
                        "assets/icons/point.svg",
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                ],
              )),
          TextInput(
            controller: _phoneNumberController,
            title: "Phone Number",
            hintText: "123-456-7890",
            prefixIcon: const Icon(Icons.phone),
            initialValue: authUser.phoneNumber,
          ),
          TextInput(
            controller: _addressController,
            title: "Address",
            hintText: "1234 Elm St",
            prefixIcon: const Icon(Icons.location_on),
            initialValue: authUser.address,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => updateUser(),
            child: const Text("Save Changes"),
          ),
        ],
      ),
    );
  }
}
