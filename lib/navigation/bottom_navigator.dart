import 'package:flutter/material.dart';
import 'package:new_app/screens/counter.dart';
import 'package:new_app/screens/home.dart';
import 'package:new_app/screens/user_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavApp extends StatefulWidget {
  const BottomNavApp({super.key});

  @override
  State<BottomNavApp> createState() => _BottomNavAppState();
}

class _BottomNavAppState extends State<BottomNavApp> {
  SharedPreferences? _prefs;
  //
  int _selectedIndex = 0;
  //
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  Color color = Colors.black;
  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  void _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _getPrefs();
  }

  void _setPrefs(Color? color) {
    if (color == null) {
      _prefs?.remove('color');
    } else {
      _prefs?.setInt('color', color.value);
    }
  }

  void _getPrefs() {
    int? _color = _prefs?.getInt('color');
    if (_color != null) {
      setState(() {
        color = Color(_color);
      });
    }
  }

  //
  final List<String> _pageTitles = [
    'Главная',
    'Список пользователей',
    'Счетчик',
  ];
  //
  final List<Color> _colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
  ];
  //
  void _onItemTapped(int index) {
    if (_selectedIndex == index && _navigatorKeys[index].currentState != null) {
      _navigatorKeys[index].currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _buildOffstageNavigator(int index, Widget screen) {
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => screen,
          );
        },
      ),
    );
  }

  //
  void _selectColor(BuildContext context) async {
    final selectedColor = await showDialog<int?>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
          title: const Center(
            child: Text('Выберите Цвет'),
          ),
          content: Flex(
            direction: Axis.vertical,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceAround,
                children: _colors
                    .map((colorItem) => GestureDetector(
                          onTap: () {
                            Navigator.pop(context, colorItem.value);
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: colorItem,
                              shape: BoxShape.circle,
                              border: colorItem.value == color.value
                                  ? Border.all(color: Colors.black, width: 2)
                                  : null,
                            ),
                          ),
                        ))
                    .toList(),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                  child: const Text('сброс'))
            ],
          )),
    );
    final Color? checkedColor =
        selectedColor != null ? Color(selectedColor) : null;

    setState(() {
      color = checkedColor ?? Colors.black;
      _setPrefs(checkedColor);
    });
  }
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _pageTitles[_selectedIndex],
              style: const TextStyle(color: Colors.white),
            ),
            ElevatedButton(
                onPressed: () => _selectColor(context),
                child: const Text('Изменить Цвет'))
          ],
        ),
        backgroundColor: color,
      ),
      body: Stack(
        children: [
          _buildOffstageNavigator(0, const HomeScreen()),
          _buildOffstageNavigator(1, const UserListScreen()),
          _buildOffstageNavigator(2, const CounterScreen()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: _pageTitles[0],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people),
            label: _pageTitles[1],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.numbers),
            label: _pageTitles[2],
          ),
        ],
      ),
    );
  }
}
