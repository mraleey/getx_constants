import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/constants/fonts.dart';
import 'package:getx_constants/controller/admin/ticket/ticket_home_controller.dart';
import 'package:getx_constants/view/admin/tickets/client_info.dart';
import 'package:getx_constants/view/admin/tickets/ticket_info.dart';

class TicketHomeView extends StatelessWidget {
  final TicketController ticketController = Get.put(TicketController());

  final List<Widget> easyStepList = [
    TicketInfoView(),
    ClientInfoView(),
  ];

   TicketHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TicketController>(
      builder: (controller) {
        return Column(
          children: [
            Obx(
              () => controller.currentStep.value == 0
                  ? const SizedBox.shrink()
                  : GestureDetector(
                      onTap: () {
                        controller.previousStep();
                      },
                      child: Container(
                        width: Get.width * 0.4,
                        height: Get.height * 0.06,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor.red,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.back,
                              color: AppColor.white,
                              size: CustomFontSize.extraExtraLarge(context),
                            ),
                            Text(
                              'Previous',
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize:
                                    CustomFontSize.extraExtraLarge(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            SizedBox(height: Get.height * 0.02),
            Obx(
              () => Expanded(
                child: easyStepList[controller.currentStep.value],
              ),
            ),
            SizedBox(height: Get.height * 0.02),
          ],
        );
      },
    );
  }
}
