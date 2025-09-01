import 'package:flutter/material.dart';

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({
    super.key,
    required this.leadingIcon,
    required this.menuTitle,
    required this.trailingIcon,
    this.onTap,
    this.isButton = false,
  });

  final Icon leadingIcon;
  final Text menuTitle;
  final Icon trailingIcon;
  final Function()? onTap;
  final bool isButton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListTile(
        leading: leadingIcon,
        title: menuTitle,
        trailing: trailingIcon,
        onTap: isButton ? onTap : null,
      ),
    );
  }
}
