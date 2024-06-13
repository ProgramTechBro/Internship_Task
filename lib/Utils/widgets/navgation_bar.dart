import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final void Function(int)? onIndexChanged;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    this.onIndexChanged,
  }) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState
    extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height*0.08,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildNavigationItem(Icons.home, 'Home', 0),
          _buildNavigationItem(Icons.favorite, 'Favorite', 1),
          _buildNavigationItem(Icons.settings, 'Settings', 2),
        ],
      ),
    );
  }

  Widget _buildNavigationItem(IconData icon, String label, int index) {
    final isSelected = widget.currentIndex == index;
    final color = isSelected ? Colors.redAccent : Colors.white;
    return InkWell(
      onTap: () {
        if (widget.onIndexChanged != null) {
          widget.onIndexChanged!(index);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 30,
          ),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
