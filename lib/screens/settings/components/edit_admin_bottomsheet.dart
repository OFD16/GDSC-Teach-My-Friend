import 'package:Sharey/models/User.dart';
import 'package:Sharey/screens/create_content/text_input.dart';
import 'package:Sharey/services/user_services.dart';
import 'package:flutter/material.dart';

class EditAdmin extends StatefulWidget {
  const EditAdmin({super.key});

  @override
  State<EditAdmin> createState() => _EditAdminState();
}

class _EditAdminState extends State<EditAdmin> {
  final TextEditingController _searchController = TextEditingController();

  final UserService _userService = UserService();

  List<User> users = [];
  List<User> filteredUsers = [];
  bool isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  void getUsers() async {
    setState(() {
      isLoading = true;
    });

    List<User> usersData = await _userService.getUsers();

    setState(() {
      users = usersData;
      filteredUsers = usersData; // Initially, display all users
      isLoading = false;
    });
  }

  void filterUsers(String query) {
    setState(() {
      filteredUsers = users
          .where((user) =>
              user.firstName!.toLowerCase().contains(query.toLowerCase()) ||
              user.lastName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Edit Admin'),
        TextInput(
          controller: _searchController,
          hintText: 'Search for user',
          onChanged: filterUsers,
        ),
        isLoading
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  ...List.generate(
                    filteredUsers.length,
                    (index) => ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            filteredUsers[index].photoUrl != null &&
                                    filteredUsers[index].photoUrl != null &&
                                    filteredUsers[index].photoUrl != ""
                                ? NetworkImage(filteredUsers[index].photoUrl!)
                                    as ImageProvider
                                : const AssetImage(
                                    "assets/images/profile_image.jpg"),
                        radius: 20,
                      ),
                      title: Text(
                          "${filteredUsers[index].firstName} ${filteredUsers[index].lastName}"),
                      subtitle: Text("Admin: ${filteredUsers[index].isAdmin}"),
                      trailing: Switch(
                        value: filteredUsers[index].isAdmin ?? false,
                        onChanged: (value) {
                          _userService.updateUser(
                              filteredUsers[index].copyWith(isAdmin: value));
                          setState(() {
                            filteredUsers[index].isAdmin = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              )
      ],
    );
  }
}
