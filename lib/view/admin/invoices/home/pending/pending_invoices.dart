import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/button.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/constants/fonts.dart';
import 'package:getx_constants/controller/admin/Invoice/invoice_controller.dart';
import 'package:getx_constants/view/admin/invoices/home/pending/data_collection.dart';
import 'package:getx_constants/view/commen/animation.dart';

class PendingInvoicesView extends StatelessWidget {
  final InvoiceController invoiceController =
      Get.put(InvoiceController(invoiceRepo: Get.find()));

  PendingInvoicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await invoiceController.postbillingtickets("Yes");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 13.0, vertical: 7.0),
            child: Text(
              'Pending Invoices',
              style: TextStyle(
                fontSize: CustomFontSize.extraExtraLarge(context) * 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (invoiceController.billingTicketsInvoices.isEmpty) {
                return const Center(child: AnimatedBar());
              }
              return ListView.builder(
                itemCount: invoiceController.billingTicketsInvoices.length,
                itemBuilder: (context, index) {
                  var invoices =
                      invoiceController.billingTicketsInvoices[index];
                  return buildTicketItem(context, invoices);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildTicketItem(BuildContext context, Map<String, dynamic> invoice) {
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
              buildTextHeader(invoice['VNAME'].toString()),
              SizedBox(height: Get.height / 30),
              buildTextField("Ticket No", invoice['TICKETNO'].toString()),
              buildTextField(
                  "Contact Person", invoice['CONTACTPERSON1'].toString()),
              buildTextField("Mobile", invoice['MOBILE1'].toString()),
              buildTextField("Assigned To", invoice['FULLNAME'].toString()),
              Container(
                color: getStatusColor(invoice['STATUS'].toString()),
                child: buildTextField("Status", invoice['STATUS'].toString(),
                    textColor: Colors.white),
              ),
              Container(
                color: getPriorityColor(invoice['PRIORITY'].toString()),
                child: buildTextField(
                    "Priority", invoice['PRIORITY'].toString(),
                    textColor: Colors.white),
              ),
              buildTextField("Subject", invoice['SUBJECT'].toString()),
              buildTextField("Due Date", invoice['DUEDATE'].toString()),
              buildTextField("Enter By", invoice['ENTERBY'].toString()),
              Center(
                child: CustomButton(
                  title: "Generate Invoice",
                  onPressed: () {
                    collectedDataForInvoice(context, invoice);
                  },
                  isLoading: false,
                  color: AppColor.red,
                  width: Get.width / 2.5,
                  height: Get.height / 20,
                ),
              ),
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
