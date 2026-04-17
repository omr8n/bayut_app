import 'package:flutter/material.dart';

// import 'custom_text.dart';

// class DrawerListTile extends StatelessWidget {
//   const DrawerListTile({
//     super.key,
//     // For selecting those three line once press "Command+D"
//     required this.title,
//     required this.onTap,
//     required this.icon,
//   });

//   final String title;
//   final VoidCallback onTap;
//   final IconData icon;
//   @override
//   Widget build(BuildContext context) {
//     // final theme = Utils(context).getTheme;
//     // final color = theme == true ? Colors.white : Colors.black;

//     return ListTile(
//       onTap: onTap,
//       horizontalTitleGap: 0.0,
//       leading: Icon(icon, size: 18),
//       title: CustomText(text: title),
//     );
//   }
// }
class DrawerListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool selected;

  const DrawerListTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListTile(
        leading: Icon(icon, color: selected ? Colors.blue : Colors.grey),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            title,
            style: TextStyle(
              color: selected ? Colors.blue : Colors.black,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
