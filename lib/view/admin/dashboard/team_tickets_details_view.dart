import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/constants/fonts.dart';
import 'package:getx_constants/controller/admin/dashboard/dashboard_controller.dart';
import 'package:getx_constants/controller/admin/dashboard/tickets_enum.dart';
import 'package:getx_constants/controller/admin/dashboard/update_ticket_status.dart';
import 'package:getx_constants/constants/button.dart';
import 'package:getx_constants/constants/textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeamTicketDetailsView extends StatelessWidget {
  final TicketType ticketType;

  TeamTicketDetailsView({super.key, required this.ticketType});

  final DashboardController dashboardController =
      Get.find<DashboardController>();

  final UpdateTicketStatusController updateTicketStatusController =
      Get.put<UpdateTicketStatusController>(
    UpdateTicketStatusController(statusRepo: Get.find()),
  );

  final SharedPreferences sharedPreferences = Get.find<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryTheme,
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
      body: Obx(() {
        List<Map<String, dynamic>> tickets;
        switch (ticketType) {
          case TicketType.Previous:
            tickets = dashboardController.ticketPrevious;
            break;
          case TicketType.New:
            tickets = dashboardController.ticketNew;
            break;
          case TicketType.Closed:
            tickets = dashboardController.ticketClosed;
            break;
          case TicketType.Pending:
            tickets = dashboardController.ticketPending;
            break;
        }

        tickets.removeWhere((ticket) =>
            ticket['ID'] == null ||
            tickets.where((t) => t['ID'] == ticket['ID']).length > 1);

        if (tickets.isEmpty) {
          return Center(
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
          );
        } else {
          return ListView.builder(
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return buildTicketItem(context,
                  ticket); // Pass context and ticket to buildTicketItem
            },
          );
        }
      }),
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
            color: AppColor.primaryTheme,
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
                color: AppColor.primaryTheme,
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
                  CustomButton(
                    width: Get.width / 3,
                    height: Get.height / 20,
                    color: getStatusColor(ticket['STATUS']),
                    title: "Update",
                    onPressed: () {
                      Get.defaultDialog(
                        titlePadding: const EdgeInsets.only(
                          top: 50.0,
                          left: 10.0,
                          right: 10.0,
                        ),
                        radius: 10.0,
                        contentPadding: const EdgeInsets.only(
                          top: 20.0,
                          left: 20.0,
                          right: 20.0,
                          bottom: 30,
                        ),
                        title:
                            "Change Status for Ticket ${ticket['ID']}", // Display ticket number in the title
                        content: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 8,
                          ),
                          child: Column(
                            children: [
                              SingleChildScrollView(
                                child: CustomTextField(
                                  prefixIcon: Icons.description,
                                  controller: updateTicketStatusController
                                      .descriptionController,
                                  labelText: "Developer Comments",
                                ),
                              ),
                              SizedBox(height: Get.height * 0.02),
                              Obx(
                                () {
                                  if (updateTicketStatusController
                                      .statusList.isEmpty) {
                                    return const Text('Status List is Empty');
                                  } else {
                                    return DropdownSearch<String>(
                                      items: updateTicketStatusController
                                          .statusList
                                          .toList(),
                                      selectedItem: "Select New Status",
                                      onChanged: (value) {
                                        updateTicketStatusController
                                            .selectedStatus.value = value ?? '';
                                      },
                                      popupProps: const PopupProps.menu(
                                        showSearchBox: true,
                                        searchFieldProps: TextFieldProps(
                                          decoration: InputDecoration(
                                            hintText: 'Search for Status',
                                          ),
                                        ),
                                      ),
                                      dropdownBuilder: (context, item) =>
                                          Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(item ?? ""),
                                      ),
                                      dropdownDecoratorProps:
                                          const DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                          filled: true,
                                          fillColor: AppColor.white,
                                          labelText: 'Select New Status',
                                          hintText: 'Search for Status',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                              SizedBox(height: Get.height * 0.02),
                            ],
                          ),
                        ),
                        actions: [
                          CustomButton(
                            width: Get.width * 0.2,
                            height: Get.height * 0.06,
                            color: AppColor.red,
                            title: "No",
                            onPressed: () {
                              Get.back();
                            },
                            isLoading: false,
                          ),
                          Obx(
                            () => CustomButton(
                              width: Get.width * 0.2,
                              height: Get.height * 0.06,
                              color: AppColor.green,
                              title: "Yes",
                              onPressed: () {
                                updateTicketStatusController.postUpdateStatus(
                                  ticket['ID'].toString(),
                                );

                                Get.back();
                                dashboardController.fetchAllTicketsData('ALL');
                              },
                              isLoading:
                                  updateTicketStatusController.isLoading.value,
                            ),
                          ),
                        ],
                      );
                    },
                    isLoading: false,
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
        color: color ?? AppColor.primaryTheme,
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
