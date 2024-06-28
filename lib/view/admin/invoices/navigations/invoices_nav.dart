import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/controller/admin/Invoice/navigation_controller/details_nav.dart';
import 'package:getx_constants/view/admin/invoices/invoices/all_invoice_data.dart';
import 'package:getx_constants/view/admin/invoices/invoices/paid_invoices_data.dart';
import 'package:getx_constants/view/admin/invoices/invoices/unpaid_invoices_data.dart';

class InvoicesBottomNav extends StatelessWidget {
  final DetailsInvoicesController controller =
      Get.put(DetailsInvoicesController());

  InvoicesBottomNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: _buildScreens()[controller.currentIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: (index) => controller.changeTab(index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'All',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.payment),
              label: 'Paid',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.money_off),
              label: 'Unpaid',
            ),
          ],
          selectedItemColor: AppColor.primaryTheme, // Adjust colors as needed
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      AllInvoicesView(),
      PaidInvoicesView(),
      UnpaidInvoicesView(),
    ];
  }
}
