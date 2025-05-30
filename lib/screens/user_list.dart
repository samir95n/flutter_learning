import 'package:flutter/material.dart';
import 'package:new_app/models/user.dart';
import 'package:new_app/screens/add_and_update_user.dart';
import 'package:new_app/screens/profile.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final List<User> userList = [
    User('Самир', "Самиров", 20),
    User('Макс', "Максов", 21),
    User('Аня', "Максова", 22),
    User('Жека', "Максов", 23),
  ];

  void _navigateToAddUser() async {
    final newUser = await Navigator.push<User>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddAndUpdateUserScreen(user: null),
      ),
    );

    if (newUser != null) {
      setState(() {
        userList.add(newUser);
      });
    }
  }

  void _deleteUser(int index) async {
    setState(() {
      userList.removeAt(index);
    });
  }

  void _showAndEditUser(Widget Function(User user) screenBuilder,
      User selectedUser, int index) async {
    final editedUser = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => screenBuilder(selectedUser),
      ),
    );
    if (editedUser != null) {
      setState(() {
        userList[index] = editedUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
                padding: EdgeInsets.all(16.0),
                child: SearchBar(
                  leading: Icon(Icons.search),
                )),
            Expanded(
              child: ListView.builder(
                itemCount: userList.length,
                itemBuilder: (BuildContext context, int index) {
                  final user = userList[index];
                  final userFullName = '${user.name} ${user.surName}';
                  return ListTile(
                    trailing: Wrap(
                      children: [
                        IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showAndEditUser(
                                (user) => AddAndUpdateUserScreen(user: user),
                                user,
                                index)),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Удалить пользователя'),
                              content: Text(
                                  'Вы действительно хотите удалить пользователя - $userFullName'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Отмена'),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    _deleteUser(index),
                                    Navigator.pop(context, 'Cancel')
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    title: Text(userFullName),
                    subtitle: Text('Возраст: ${user.age}'),
                    onTap: () => {
                      _showAndEditUser(
                          (user) => ProfileScreen(user: user), user, index)
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _navigateToAddUser,
                child: const Text('Добавить пользователя'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
