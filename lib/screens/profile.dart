import 'package:flutter/material.dart';
import 'package:new_app/models/user.dart';
import 'package:new_app/screens/add_and_update_user.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? profileUser;

  @override
  void initState() {
    super.initState();
    // Set props (widget.user) to state
    profileUser = widget.user;
  }

  void _editUser() async {
    final User? editedUser = await Navigator.push<User>(
      context,
      MaterialPageRoute(
        builder: (context) => AddAndUpdateUserScreen(
          user: profileUser,
        ),
      ),
    );
    if (editedUser != null) {
      setState(() {
        profileUser = editedUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 2,
            children: [
              Text(
                  '${profileUser?.name} ${profileUser?.surName} - ${profileUser?.age} лет'),
              IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: _editUser),
            ],
          ),
          ElevatedButton(
            child: const Text('Назад'),
            onPressed: () {
              Navigator.pop(
                  context, profileUser == widget.user ? null : profileUser);
            },
          ),
        ],
      )),
    );
  }
}
