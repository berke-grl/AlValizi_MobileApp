import 'package:flutter/material.dart';
import 'package:graduation_app/resources/network_service.dart';
import 'package:graduation_app/screens/no_internet_screen.dart';
import 'package:graduation_app/utils/varriables.dart';
import 'package:provider/provider.dart';
import 'package:graduation_app/providers/user_provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget mobileScreenLayout;
  final Widget webScreenLayout;
  const ResponsiveLayout({
    Key? key,
    required this.mobileScreenLayout,
    required this.webScreenLayout,
  }) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var networkStatus = Provider.of<NetworkStatus>(context);

    return networkStatus == NetworkStatus.online
        ? LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > webScreenSize) {
              // 600 can be changed to 900 if you want to display tablet screen with mobile screen layout
              return widget.webScreenLayout;
            }
            return widget.mobileScreenLayout;
          })
        : const NoInternetScreen();
  }
}
