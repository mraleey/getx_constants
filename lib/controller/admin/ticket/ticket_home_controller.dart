import 'package:get/get.dart';

class TicketController extends GetxController {
  var currentStep = 0.obs;

  void nextStep() {
    if (currentStep.value < 2) {
      // Change 1 to 2 to allow stepping to the last step
      currentStep.value += 1;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value -= 1;
    }
  }
}
