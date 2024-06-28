import 'package:get/get.dart';

class PartyTicketController extends GetxController {
  var currentStep = 0.obs;

  void nextStep() {
    if (currentStep.value < 2) {
      currentStep.value += 1;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value -= 1;
    }
  }
}
