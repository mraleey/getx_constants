import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/card.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/constants/fonts.dart';
import 'package:getx_constants/view_models/login_controller.dart';
import 'package:getx_constants/constants/button.dart';
import 'package:getx_constants/controller/party/dashboard/party_dashboard_controller.dart';
import 'package:getx_constants/controller/party/dashboard/party_ticket_enum.dart';
import 'package:getx_constants/view/party/dashboard/party_ticket_details_view.dart';
import 'package:getx_constants/view/commen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PartyDashboardView extends StatelessWidget {
  final LoginController loginController = Get.find<LoginController>();
  final SharedPreferences sharedPreferences = Get.find<SharedPreferences>();
  final PartyDashboardController dashboardController =
      Get.put(PartyDashboardController());

  PartyDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        dashboardController.fetchAllTicketsData(
            sharedPreferences.getString("USERNAME").toString());
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      sharedPreferences.getString("NAME").toString(),
                      style: TextStyle(
                        fontSize: CustomFontSize.extraLarge(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  CustomButton(
                    color: AppColor.red,
                    width: Get.width / 3,
                    height: Get.height / 20,
                    title: "Log Out",
                    onPressed: () {
                      loginController.isLogin(false);
                      Get.offAll(LogInView());
                    },
                    isLoading: false,
                  ),
                ],
              ),
              SizedBox(height: Get.height / 30),
              SizedBox(height: Get.height / 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        dashboardController.ticketClosedData(
                            sharedPreferences.getString("USERNAME").toString());
                        Get.to(() => PartyTicketDetailsView(
                            ticketType: PartyTicketType.Closed));
                      },
                      child: Obx(
                        () => CustomCard(
                          borderColor: AppColor.pendingCardColor,
                          cardName: 'Closed',
                          icon: Icons.done_all,
                          cardContent:
                              '${dashboardController.ticketClosedCount} Tickets',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: Get.width / 30),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        dashboardController.ticketPendingData(
                            sharedPreferences.getString("USERNAME").toString());
                        Get.to(() => PartyTicketDetailsView(
                              ticketType: PartyTicketType.Pending,
                            ));
                      },
                      child: Obx(
                        () => CustomCard(
                          borderColor: AppColor.closedCardColor,
                          cardName: 'Pending',
                          icon: Icons.pending,
                          cardContent:
                              '${dashboardController.ticketPendingCount} Tickets',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height / 40),
              const Divider(
                color: AppColor.partyprimaryColorDark,
                thickness: 3,
              ),
              SizedBox(height: Get.height / 40),
            ],
          ),
        ),
      ),
    );
  }
}
