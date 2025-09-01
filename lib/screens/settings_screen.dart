import 'package:flutter/material.dart';
import 'package:maverick/services/auth_service.dart';
import 'package:maverick/widgets/button.dart';
import 'package:maverick/widgets/settings_menu.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _showDataCleanDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('You are about to clear app data'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                //Warning Icon
                Icon(Icons.warning, color: Colors.grey, size: 40),
                Column(
                  children: [
                    Text(
                      "You are are about to clear groups and transaction data.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Would you like to proceed",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                button(
                  buttonTxt: "Approve",
                  buttonW: 130,
                  onPressed: () {},
                  buttonTxtStyle: TextStyle(fontSize: 16, color: Colors.grey),
                  buttonColor: Color.fromRGBO(255, 144, 94, 1),
                ),

                button(
                  buttonTxt: "Cancel",
                  buttonW: 130,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  buttonTxtStyle: TextStyle(fontSize: 16, color: Colors.grey),
                  buttonColor: Color.fromRGBO(255, 144, 94, 1),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _showLogOutDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('You are about to logout'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                //Warning Icon
                Icon(Icons.login_rounded, color: Colors.grey, size: 40),
                Column(
                  children: [
                    Text(
                      "You are are about to logout.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Would you like to proceed",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                button(
                  buttonTxt: "Approve",
                  buttonW: 130,
                  onPressed: () {
                    AuthService().logOut();
                    Navigator.pop(context);
                  },
                  buttonTxtStyle: TextStyle(fontSize: 16, color: Colors.grey),
                  buttonColor: Color.fromRGBO(255, 144, 94, 1),
                ),

                button(
                  buttonTxt: "Cancel",
                  buttonW: 130,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  buttonTxtStyle: TextStyle(fontSize: 16, color: Colors.grey),
                  buttonColor: Color.fromRGBO(255, 144, 94, 1),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerSection(
                sectionTitle: "Clear App data",
                sectionTextStyle: TextStyle(fontSize: 18, color: Colors.grey),
              ),

              SettingsMenu(
                leadingIcon: Icon(Icons.data_object),
                menuTitle: Text("Clear application data"),
                trailingIcon: Icon(Icons.keyboard_arrow_right_sharp, size: 30),
                isButton: true,
                onTap: _showDataCleanDialog,
              ),

              headerSection(
                sectionTitle: "Resources",
                sectionTextStyle: TextStyle(fontSize: 18, color: Colors.grey),
              ),

              SettingsMenu(
                leadingIcon: Icon(Icons.logout_rounded),
                menuTitle: Text("LogOut"),
                trailingIcon: Icon(Icons.keyboard_arrow_right_sharp, size: 30),
                isButton: true,
                onTap: _showLogOutDialog,
              ),

              SettingsMenu(
                leadingIcon: Icon(Icons.data_thresholding),
                menuTitle: Text("Data reports"),
                trailingIcon: Icon(Icons.keyboard_arrow_right_sharp, size: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget headerSection({
    required String sectionTitle,
    required TextStyle sectionTextStyle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(sectionTitle, style: sectionTextStyle),
    );
  }
}
