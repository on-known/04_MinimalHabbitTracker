import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimal_habbit_tracker/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.surfaceBright,
        child: CupertinoSwitch(
          value: Provider.of<ThemeProvider>(context, listen: false).isdarkMode,
          onChanged: (value) {
            Provider.of<ThemeProvider>(context, listen: false).toggleButton();
          },
        ),
      ),
    );
  }
}
