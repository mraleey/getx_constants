import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/constants/fonts.dart';
import 'package:getx_constants/controller/admin/ticket/client_info_controller.dart';
import 'package:getx_constants/controller/admin/ticket/ticket_home_controller.dart';
import 'package:getx_constants/constants/button.dart';
import 'package:getx_constants/constants/textfield.dart';
import 'package:getx_constants/controller/admin/ticket/ticket_info_controller.dart';

class ClientInfoView extends StatelessWidget {
  final TicketInfoController ticketInfoController = Get.find();
  final ClientInfoController clientInfoController =
      Get.put(ClientInfoController(ticketRepo: Get.find()));
  final TicketController ticketController = Get.put(TicketController());
  ClientInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Client Info',
            style: TextStyle(
                color: AppColor.primaryThemeLight,
                fontSize: CustomFontSize.large(context) * 1.5,
                fontWeight: FontWeight.bold),
          ),
          Container(
            width: Get.width * 0.9,
            decoration: BoxDecoration(
                border:
                    Border.all(color: AppColor.primaryThemeLight, width: 3.0),
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  FutureBuilder(
                    future: clientInfoController.getClientInfo(),
                    builder: (context, snapshot) {
                      return Obx(
                        () {
                          if (clientInfoController.partyNames.isEmpty) {
                            return const Text('Party Name Not Found');
                          } else {
                            return DropdownSearch<String>(
                              items: clientInfoController.partyNames.toList(),
                              selectedItem: "Select Party Name",
                              onChanged: (value) {
                                clientInfoController.partyName.value = value!;
                                final selectedParty =
                                    clientInfoController.partyCodes.firstWhere(
                                  (party) => party['VNAME'] == value,
                                  orElse: () => {},
                                );
                                if (selectedParty.isNotEmpty) {
                                  clientInfoController.partyCode.value =
                                      selectedParty['VCODE']!;
                                  final selectedOwner = clientInfoController
                                      .ownerNames
                                      .firstWhere(
                                    (owner) =>
                                        owner['VCODE'] ==
                                        selectedParty['VCODE'],
                                    orElse: () => {},
                                  );
                                  if (selectedOwner.isNotEmpty) {
                                    clientInfoController.ownerController.text =
                                        selectedOwner['OWNERNAME']!;
                                    clientInfoController.softwareLinkController
                                        .text = selectedOwner['SOFTWARELINK']!;
                                    clientInfoController
                                            .contactPerson1Controller.text =
                                        selectedOwner['CONTACTPERSON1']!;
                                    clientInfoController
                                            .contactPerson2Controller.text =
                                        selectedOwner['CONTACTPERSON2']!;
                                    clientInfoController
                                            .contactPerson3Controller.text =
                                        selectedOwner['CONTACTPERSON3']!;
                                    clientInfoController
                                            .contactPerson4Controller.text =
                                        selectedOwner['CONTACTPERSON4']!;
                                    clientInfoController.mobile1Controller
                                        .text = selectedOwner['MOBILE1']!;
                                    clientInfoController.mobile2Controller
                                        .text = selectedOwner['MOBILE2']!;
                                  }
                                }
                              },
                              dropdownDecoratorProps: const DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColor.white,
                                  labelText: 'Select Party',
                                  hintText: 'Search for a party',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              popupProps: const PopupProps.menu(
                                showSearchBox: true,
                                searchFieldProps: TextFieldProps(
                                  decoration: InputDecoration(
                                    hintText: 'Search for a party',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              dropdownBuilder: (context, item) => Container(
                                padding: const EdgeInsets.all(10),
                                child: Text(item ?? ""),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: Get.height / 40,
                  ),
                  CustomTextField(
                    controller: clientInfoController.ownerController,
                    labelText: 'Owner Name',
                    borderColor: AppColor.primaryThemeLight,
                    readOnly: true,
                    prefixIcon: Icons.person,
                  ),
                  SizedBox(
                    height: Get.height / 40,
                  ),
                  CustomTextField(
                    controller: clientInfoController.softwareLinkController,
                    labelText: 'Software Link',
                    borderColor: AppColor.primaryThemeLight,
                    readOnly: true,
                    prefixIcon: Icons.link,
                  ),
                  SizedBox(
                    height: Get.height / 40,
                  ),
                  CustomTextField(
                    controller: clientInfoController.contactPerson1Controller,
                    labelText: 'Contact Person 1 ',
                    borderColor: AppColor.primaryThemeLight,
                    readOnly: true,
                    prefixIcon: Icons.person,
                  ),
                  SizedBox(
                    height: Get.height / 40,
                  ),
                  CustomTextField(
                    controller: clientInfoController.contactPerson2Controller,
                    labelText: 'Contact Person 2 ',
                    borderColor: AppColor.primaryThemeLight,
                    readOnly: true,
                    prefixIcon: Icons.person,
                  ),
                  SizedBox(
                    height: Get.height / 40,
                  ),
                  CustomTextField(
                    controller: clientInfoController.contactPerson3Controller,
                    labelText: 'Contact Person 3',
                    borderColor: AppColor.primaryThemeLight,
                    readOnly: true,
                    prefixIcon: Icons.person,
                  ),
                  SizedBox(
                    height: Get.height / 40,
                  ),
                  CustomTextField(
                    controller: clientInfoController.contactPerson4Controller,
                    labelText: 'Contact Person 4 ',
                    borderColor: AppColor.primaryThemeLight,
                    readOnly: true,
                    prefixIcon: Icons.person,
                  ),
                  SizedBox(
                    height: Get.height / 40,
                  ),
                  CustomTextField(
                    controller: clientInfoController.mobile1Controller,
                    labelText: 'Mobile# 1: ',
                    borderColor: AppColor.primaryThemeLight,
                    readOnly: true,
                    prefixIcon: Icons.phone,
                  ),
                  SizedBox(
                    height: Get.height / 40,
                  ),
                  CustomTextField(
                    controller: clientInfoController.mobile2Controller,
                    labelText: 'Mobile# 2: ',
                    borderColor: AppColor.primaryThemeLight,
                    readOnly: true,
                    prefixIcon: Icons.phone,
                  ),
                  SizedBox(
                    height: Get.height / 40,
                  ),
                  Text(
                    'Below Fields are Required *',
                    style: TextStyle(
                        color: AppColor.red,
                        fontSize: CustomFontSize.medium(context)),
                  ),
                  SizedBox(
                    height: Get.height / 40,
                  ),
                  CustomTextField(
                    controller: clientInfoController.tContactController,
                    labelText: 'Contact Person',
                    borderColor: AppColor.primaryThemeLight,
                    prefixIcon: Icons.person,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(
                    height: Get.height / 40,
                  ),
                  CustomTextField(
                    controller: clientInfoController.tMobileController,
                    labelText: 'Mobile#',
                    borderColor: AppColor.primaryThemeLight,
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: Get.height / 40,
                  ),
                  CustomTextField(
                    controller: clientInfoController.tEmailController,
                    labelText: 'Email',
                    borderColor: AppColor.primaryThemeLight,
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: Get.height / 40,
                  ),
                  CustomTextField(
                    controller: clientInfoController.tSoftwareLinkController,
                    labelText: 'Software Link',
                    borderColor: AppColor.primaryThemeLight,
                    prefixIcon: Icons.link,
                    keyboardType: TextInputType.url,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: Get.height / 30),
          Obx(
            () => CustomButton(
              width: Get.width * 0.6,
              height: Get.height * 0.08,
              color: AppColor.buttonColor,
              title: 'Generate Ticket',
              isLoading: clientInfoController.isLoading.value,
              onPressed: () async{
                clientInfoController.generateTicket();
              },              
            ),
          ),
          SizedBox(height: Get.height / 30),
        ],
      ),
    );
  }
}
