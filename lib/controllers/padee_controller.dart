import 'package:get/get.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/material.dart';

class PadeeController extends GetxController {
  // Reactive Variables
  var selectedBeadType = 9.obs;
  var currentBeadCount = 0.obs;
  var currentRoundCount = 0.obs;
  var targetRounds = 10.obs;
  
  // Options for Bead Strings
  final List<int> beadOptions = [9, 27, 108];

  void setBeadType(int type) {
    selectedBeadType.value = type;
    resetCounts(); // Optional: reset counts when bead type changes to avoid inconsistency
  }

  void setTargetRounds(int target) {
    if (target > 0) {
      targetRounds.value = target;
    }
  }

  void incrementBead() async {
    currentBeadCount.value++;
    
    // Check if we hit the bead type limit (1 round)
    if (currentBeadCount.value >= selectedBeadType.value) {
      currentBeadCount.value = 0;
      currentRoundCount.value++;
      
      // Haptic feedback for completing a round
      bool? hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate(duration: 100);
      }
      
      // Check if goal reached
      if (currentRoundCount.value == targetRounds.value) {
        _triggerGoalCompletionAlert();
      }
    } else {
      // Light haptic feedback for each bead tap
      bool? hasVibrator = await Vibration.hasCustomVibrationsSupport();
      if (hasVibrator == true) {
        Vibration.vibrate(duration: 30, amplitude: 50);
      }
    }
  }

  void resetCounts() {
    currentBeadCount.value = 0;
    currentRoundCount.value = 0;
  }

  void _triggerGoalCompletionAlert() async {
    // 1. Vibrate
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(pattern: [500, 1000, 500, 1000]);
    }

    // 2. Play Sound (Could use audioplayers here, omitting sound file for now to keep it simple without assets)
    // AudioPlayer().play(AssetSource('sound.mp3'));

    // 3. Show Popup
    Get.defaultDialog(
      title: 'goal_achieved_title'.tr,
      middleText: 'goal_achieved_desc'.trParams({'rounds': targetRounds.value.toString()}),
      confirm: ElevatedButton(
        onPressed: () {
          Get.back(); // close dialog
          resetCounts(); // Optional: auto reset or let user manually reset
        },
        child: Text('sadhu_btn'.tr),
      ),
      barrierDismissible: false,
    );
  }
}
