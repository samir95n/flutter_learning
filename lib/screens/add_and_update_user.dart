import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_app/models/user.dart';

class AddAndUpdateUserScreen extends StatefulWidget {
  final User? user;
  const AddAndUpdateUserScreen({super.key, this.user});
  @override
  State<AddAndUpdateUserScreen> createState() => _AddAndUpdateUserScreenState();
}

class _AddAndUpdateUserScreenState extends State<AddAndUpdateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _surName;
  late int _age;

  @override
  void initState() {
    super.initState();
    _name = widget.user?.name ?? '';
    _surName = widget.user?.surName ?? '';
    _age = widget.user?.age ?? 0;
  }

  //
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newUser = User(_name, _surName, _age);
      // Возвращаем пользователя обратно
      Navigator.pop(context, newUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextFormField(
                  initialValue: _name,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Введите Имя',
                    labelText: 'Имя *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Заполните поле';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                TextFormField(
                  initialValue: _surName,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Введите Фамилию',
                    labelText: 'Фамилия *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Заполните поле';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _surName = value!;
                  },
                ),
                TextFormField(
                  initialValue: _age.toString(),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.numbers_outlined),
                    hintText: 'Введите возраст',
                    labelText: 'Возраст *',
                  ),
                  // initialValue: widget.user!.age.toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Заполните поле';
                    } else if (int.tryParse(value) == null ||
                        int.parse(value) < 0) {
                      return 'Введите корректный возраст';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _age = int.parse(value!);
                  },
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(widget.user == null
                      ? 'Добавить пользователя'
                      : 'Редактировать пользователя'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
