import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/controller/admin/Invoice/navigation_controller/invoice_nav_controller.dart';
import 'package:getx_constants/view/admin/invoices/home/create_invoice.dart';
import 'package:getx_constants/view/admin/invoices/home/invoice_dashboard.dart';
import 'package:getx_constants/view/admin/invoices/navigations/invoices_nav.dart';
import 'package:getx_constants/view/admin/invoices/home/pending/pending_invoices.dart';

class InvoiceBottomNavigationBar extends StatelessWidget {
  final InvoiceBottomNavigationBarController controller =
      Get.put(InvoiceBottomNavigationBarController());

  InvoiceBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: controller.currentIndex.value,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColor.white,
          title: TabBar(
            tabs: _tabBarItems(),
            indicatorColor: AppColor.primaryTheme,
            labelColor: AppColor.primaryTheme,
            unselectedLabelColor: Colors.grey,
            onTap: (index) => controller.changeTab(index),
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: _buildScreens(),
        ),
      ),
    );
  }

  List<Tab> _tabBarItems() {
    return [
      const Tab(text: 'Dashboard', icon: Icon(Icons.dashboard)),
      const Tab(text: 'New', icon: Icon(Icons.create)),
      const Tab(text: 'Pending', icon: Icon(Icons.pending)),
      const Tab(text: 'Invoices', icon: Icon(Icons.account_balance_wallet)),
    ];
  }

  List<Widget> _buildScreens() {
    return [
      InvoiceDashboardView(),
      CreateInvoiceView(),
      PendingInvoicesView(),
      InvoicesBottomNav(),
    ];
  }
}
