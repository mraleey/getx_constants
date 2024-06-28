import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/constants/fonts.dart';
import 'package:getx_constants/controller/admin/dashboard/update_ticket_status.dart';
import 'package:getx_constants/controller/party/dashboard/party_dashboard_controller.dart';
import 'package:getx_constants/controller/party/dashboard/party_ticket_enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PartyTicketDetailsView extends StatelessWidget {
  final PartyTicketType ticketType;

  PartyTicketDetailsView({Key? key, required this.ticketType})
      : super(key: key);

  final PartyDashboardController dashboardController =
      Get.find<PartyDashboardController>();

  final UpdateTicketStatusController updateTicketStatusController =
      Get.put<UpdateTicketStatusController>(
    UpdateTicketStatusController(statusRepo: Get.find()),
  );

  final SharedPreferences sharedPreferences = Get.find<SharedPreferences>();

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
              ticketType.toString().split('.').last,
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
      body: Obx(
        () {
          List<Map<String, dynamic>> tickets = [];
          switch (ticketType) {
            case PartyTicketType.Closed:
              tickets = dashboardController.ticketClosed;
              break;
            case PartyTicketType.Pending:
              tickets = dashboardController.ticketPending;
              break;
          }

          tickets.removeWhere((ticket) =>
              ticket['ID'] == null ||
              tickets.where((t) => t['ID'] == ticket['ID']).length > 1);

          return tickets.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/empty.png',
                        height: Get.height / 3,
                        width: Get.width / 2,
                      ),
                      Text(
                        'No Tickets Today',
                        style: TextStyle(
                          fontSize: CustomFontSize.medium(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    return buildTicketItem(context, tickets[index]);
                  },
                );
        },
      ),
    );
  }

  Widget buildTicketItem(BuildContext context, Map<String, dynamic> ticket) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: AppColor.partyprimaryColor,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextHeader("${ticket['ID']}"),
              SizedBox(height: Get.height / 30),
              buildTextField("Ticket No", ticket['TICKETNO']),
              buildTextField("Client", ticket['VNAME']),
              buildTextField("Owner Name", ticket['OWNERNAME']),
              buildTextField("Mobile", ticket['MOBILE1']),
              buildTextField("Assigned To", ticket['FULLNAME']),
              Container(
                  color: getStatusColor(ticket["STATUS"]),
                  child: buildTextField("Status", ticket['STATUS'],
                      textColor: Colors.white)),
              Container(
                  color: getPriorityColor(ticket["PRIORITY"]),
                  child: buildTextField("Priority", ticket['PRIORITY'],
                      textColor: Colors.white)),
              buildTextField("Subject", ticket['SUBJECT']),
              buildTextField("Link", ticket['TSOFTWARELINK']),
              buildTextField("Category", ticket['TNAME']),
              buildTextField("Due Date", ticket['DUEDATE']),
              buildTextField("Enter By", ticket['ENTERBY']),
              Column(
                children: [
                  Center(
                    child: Text(
                      "Developer Comments",
                      style: TextStyle(
                        fontSize: CustomFontSize.medium(Get.context!),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    ticket['DEVELOPER_COMMENT'] ?? '',
                    style: TextStyle(
                      fontSize: CustomFontSize.medium(Get.context!),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(
                color: AppColor.partyprimaryColor,
                thickness: 1,
              ),
              Column(
                children: [
                  Center(
                    child: Text(
                      "Query",
                      style: TextStyle(
                        fontSize: CustomFontSize.medium(Get.context!),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    ticket['QUERYDETAIL'],
                    style: TextStyle(
                      fontSize: CustomFontSize.medium(Get.context!),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Get.height / 30),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return AppColor.pendingCardColor;
      case 'Closed':
        return AppColor.closedCardColor;
      case 'Progress':
        return AppColor.newCardColor;
      case 'Previous':
        return AppColor.previousCardColor;
      default:
        return Colors.black;
    }
  }

  Color getPriorityColor(String status) {
    switch (status) {
      case 'High':
        return AppColor.highPriorityColor;
      case 'Medium':
        return AppColor.mediumPriorityColor;
      case 'Low':
        return AppColor.lowPriorityColor;
      case 'Critical':
        return AppColor.criticalPriorityColor;
      default:
        return Colors.black;
    }
  }

  Widget buildTextHeader(String text, {Color? color, Color? textColor}) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? AppColor.partyprimaryColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: AppColor.white,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      width: Get.width,
      height: Get.height / 20,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor ?? AppColor.white,
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String text, String value, {Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: CustomFontSize.medium(Get.context!),
                  fontWeight: FontWeight.bold,
                  color: textColor ?? AppColor.black,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: CustomFontSize.medium(Get.context!),
                  fontWeight: FontWeight.bold,
                  color: textColor ?? AppColor.black,
                ),
              ),
            ],
          ),
          const Divider(
            color: AppColor.primaryTheme,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
