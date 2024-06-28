import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/constants/fonts.dart';
import 'package:getx_constants/constants/button.dart';
import 'package:getx_constants/constants/textfield.dart';
import 'package:getx_constants/view_models/login_controller.dart';
import 'package:getx_constants/controller/party/ticket/party_submit_ticket_controller.dart';
import 'package:getx_constants/controller/party/ticket/party_ticket_home_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PartyClientInfoView extends StatelessWidget {
  final PartyGenerateTicketController clientInfoController =
      PartyGenerateTicketController(ticketRepo: Get.find());
  final PartyTicketController ticketController =
      Get.put(PartyTicketController());
  final LoginController loginController =
      Get.put(LoginController(loginRepository: Get.find()));
  final SharedPreferences sharedPreferences = Get.find<SharedPreferences>();

  PartyClientInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String>? partyData = sharedPreferences.getStringList("VNAME");
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Client Info',
            style: TextStyle(
                color: AppColor.partyprimaryColor,
                fontSize: CustomFontSize.large(context) * 1.5,
                fontWeight: FontWeight.bold),
          ),
          Container(
            width: Get.width * 0.9,
            decoration: BoxDecoration(
                border:
                    Border.all(color: AppColor.partyprimaryColor, width: 3.0),
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
                              items: partyData!,
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
                  SizedBox(height: Get.height / 40),
                  CustomTextField(
                    controller: clientInfoController.ownerController,
                    labelText: 'Owner Name',
                    prefixIconColor: AppColor.partyprimaryColorDark,
                    labelColor: AppColor.partyprimaryColorDark,
                    borderColor: AppColor.partyprimaryColorDark,
                    readOnly: true,
                    prefixIcon: Icons.person,
                  ),
                  SizedBox(height: Get.height / 40),
                  CustomTextField(
                    controller: clientInfoController.softwareLinkController,
                    labelText: 'Software Link',
                    prefixIconColor: AppColor.partyprimaryColorDark,
                    labelColor: AppColor.partyprimaryColorDark,
                    borderColor: AppColor.partyprimaryColorDark,
                    readOnly: true,
                    prefixIcon: Icons.link,
                  ),
                  SizedBox(height: Get.height / 40),
                  CustomTextField(
                    controller: clientInfoController.contactPerson1Controller,
                    labelText: 'Contact Person 1 ',
                    prefixIconColor: AppColor.partyprimaryColorDark,
                    labelColor: AppColor.partyprimaryColorDark,
                    borderColor: AppColor.partyprimaryColorDark,
                    readOnly: true,
                    prefixIcon: Icons.person,
                  ),
                  SizedBox(height: Get.height / 40),
                  CustomTextField(
                    controller: clientInfoController.contactPerson2Controller,
                    labelText: 'Contact Person 2 ',
                    prefixIconColor: AppColor.partyprimaryColorDark,
                    labelColor: AppColor.partyprimaryColorDark,
                    borderColor: AppColor.partyprimaryColorDark,
                    readOnly: true,
                    prefixIcon: Icons.person,
                  ),
                  SizedBox(height: Get.height / 40),
                  CustomTextField(
                    controller: clientInfoController.contactPerson3Controller,
                    labelText: 'Contact Person 3',
                    prefixIconColor: AppColor.partyprimaryColorDark,
                    labelColor: AppColor.partyprimaryColorDark,
                    borderColor: AppColor.partyprimaryColorDark,
                    readOnly: true,
                    prefixIcon: Icons.person,
                  ),
                  SizedBox(height: Get.height / 40),
                  CustomTextField(
                    controller: clientInfoController.contactPerson4Controller,
                    labelText: 'Contact Person 4 ',
                    prefixIconColor: AppColor.partyprimaryColorDark,
                    labelColor: AppColor.partyprimaryColorDark,
                    borderColor: AppColor.partyprimaryColorDark,
                    readOnly: true,
                    prefixIcon: Icons.person,
                  ),
                  SizedBox(height: Get.height / 40),
                  CustomTextField(
                    controller: clientInfoController.mobile1Controller,
                    labelText: 'Mobile# 1: ',
                    prefixIconColor: AppColor.partyprimaryColorDark,
                    labelColor: AppColor.partyprimaryColorDark,
                    borderColor: AppColor.partyprimaryColorDark,
                    readOnly: true,
                    prefixIcon: Icons.phone,
                  ),
                  SizedBox(height: Get.height / 40),
                  CustomTextField(
                    controller: clientInfoController.mobile2Controller,
                    labelText: 'Mobile# 2: ',
                    prefixIconColor: AppColor.partyprimaryColorDark,
                    labelColor: AppColor.partyprimaryColorDark,
                    borderColor: AppColor.partyprimaryColorDark,
                    readOnly: true,
                    prefixIcon: Icons.phone,
                  ),
                  SizedBox(height: Get.height / 40),
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
                    prefixIconColor: AppColor.partyprimaryColorDark,
                    labelColor: AppColor.partyprimaryColorDark,
                    borderColor: AppColor.partyprimaryColorDark,
                    prefixIcon: Icons.person,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(
                    height: Get.height / 40,
                  ),
                  CustomTextField(
                    controller: clientInfoController.tMobileController,
                    labelText: 'Mobile#',
                    prefixIconColor: AppColor.partyprimaryColorDark,
                    labelColor: AppColor.partyprimaryColorDark,
                    borderColor: AppColor.partyprimaryColorDark,
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: Get.height / 40,
                  ),
                  CustomTextField(
                    controller: clientInfoController.tEmailController,
                    labelText: 'Email',
                    prefixIconColor: AppColor.partyprimaryColorDark,
                    labelColor: AppColor.partyprimaryColorDark,
                    borderColor: AppColor.partyprimaryColorDark,
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: Get.height / 40,
                  ),
                  CustomTextField(
                    controller: clientInfoController.tSoftwareLinkController,
                    labelText: 'Software Link',
                    prefixIconColor: AppColor.partyprimaryColorDark,
                    labelColor: AppColor.partyprimaryColorDark,
                    borderColor: AppColor.partyprimaryColorDark,
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
              color: AppColor.partyprimaryColorDark,
              width: Get.width * 0.5,
              onPressed: () {
                clientInfoController.generateTicket();
              },
              title: 'Generate Ticket',
              isLoading: clientInfoController.isLoading.value,
            ),
          ),
          SizedBox(height: Get.height / 30),
        ],
      ),
    );
  }
}
