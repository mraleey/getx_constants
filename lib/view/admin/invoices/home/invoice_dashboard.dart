import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/card.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/constants/fonts.dart';
import 'package:getx_constants/controller/admin/Invoice/invoice_data_controller.dart';

class InvoiceDashboardView extends StatelessWidget {
  final InvoiceDataController invoiceDataController =
      Get.find<InvoiceDataController>();
  InvoiceDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invoices Dashboard',
              style: TextStyle(
                fontSize: CustomFontSize.extraExtraLarge(context) * 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: Get.height / 30),
            Obx(
              () => CustomCard(
                borderColor: AppColor.pendingCardColor,
                cardName: 'All Invoices',
                icon: Icons.money_off,
                cardContent:
                    '${invoiceDataController.allInvoices.length} Invoices',
              ),
            ),
            SizedBox(height: Get.height / 30),
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => CustomCard(
                      borderColor: AppColor.closedCardColor,
                      cardName: "Paid Invoices",
                      icon: Icons.paid,
                      cardContent: invoiceDataController.paidInvoices.length
                          .toString(),
                    ),
                  ),
                ),
                SizedBox(width: Get.width / 30),
                Expanded(
                  child: Obx(
                    () => CustomCard(
                      borderColor: AppColor.newCardColor,
                      cardName: "Unpaid Invoices",
                      icon: Icons.undo,
                      cardContent: invoiceDataController.unpaidInvoices.length
                          .toString(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Get.height / 30),
            const Divider(
              color: AppColor.appBarColor,
              thickness: 2,
            ),
            SizedBox(height: Get.height / 30),
           ],
        ),
      ),
    );
  }
}
