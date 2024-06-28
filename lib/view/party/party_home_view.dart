import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/constants/fonts.dart';
import 'package:getx_constants/view/party/dashboard/party_dashboard.dart';
import 'package:getx_constants/view/party/tickets/party_ticket_home.dart';

class PartyHomeView extends StatefulWidget {
  const PartyHomeView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PartyHomeViewState createState() => _PartyHomeViewState();
}

class _PartyHomeViewState extends State<PartyHomeView> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    PartyDashboardView(),
    PartyTicketHomeView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.partyprimaryColor,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Team App',
              style: TextStyle(
                color: AppColor.white,
                fontWeight: FontWeight.bold,
                fontSize: CustomFontSize.extraLarge(context),
              ),
            ),
            Row(
              children: [
                Image(
                  image: const AssetImage("images/support.png"),
                  height: Get.height * 0.05,
                  width: Get.width * 0.05,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Powered By:",
                      style: TextStyle(
                        color: AppColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: CustomFontSize.medium(context),
                      ),
                    ),
                    Text(
                      "@SolutionExperts",
                      style: TextStyle(
                        color: AppColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: CustomFontSize.medium(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColor.partyprimaryColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColor.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Tickets',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
