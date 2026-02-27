import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/padee_controller.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final PadeeController controller = Get.find<PadeeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F9), // Light grayish background matching V2 design
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'settings_title'.tr,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('general_section'.tr),
              _buildCardContainer(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('language_label'.tr, style: const TextStyle(fontSize: 16)),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Obx(() {
                          final isEnglish = controller.currentLanguage.value == 'en';
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildSegmentButton(
                                text: 'lang_english'.tr,
                                isSelected: isEnglish,
                                onTap: () => controller.changeLanguage('en', 'US'),
                              ),
                              _buildSegmentButton(
                                text: 'lang_myanmar'.tr,
                                isSelected: !isEnglish,
                                onTap: () => controller.changeLanguage('my', 'MM'),
                              ),
                            ],
                          );
                        }),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              _buildSectionTitle('counter_settings_section'.tr),
              _buildCardContainer(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('bead_target_label'.tr, style: const TextStyle(fontSize: 16)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2C9FA), // Light purple from design
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Obx(() => DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: controller.selectedBeadType.value,
                                items: controller.beadOptions.map((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(value.toString()),
                                  );
                                }).toList(),
                                onChanged: (int? newValue) {
                                  if (newValue != null) {
                                    controller.setBeadType(newValue);
                                  }
                                },
                                icon: const Icon(Icons.keyboard_arrow_down),
                              ),
                            )),
                          )
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('round_target_label'.tr, style: const TextStyle(fontSize: 16)),
                          Container(
                            width: 100,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2C9FA),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextFormField(
                              initialValue: controller.targetRounds.value.toString(),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onChanged: (value) {
                                int? target = int.tryParse(value);
                                if (target != null) {
                                  controller.setTargetRounds(target);
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              _buildSectionTitle('feedback_section'.tr),
              _buildCardContainer(
                child: Column(
                  children: [
                    _buildSwitchRow(
                      label: 'vibration_label'.tr,
                      value: controller.isVibrationEnabled,
                    ),
                    const Divider(height: 1),
                    _buildSwitchRow(
                      label: 'sound_effect_label'.tr,
                      value: controller.isSoundEnabled,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCardContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _buildSegmentButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black12, blurRadius: 2, spreadRadius: 1)]
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.black : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchRow({required String label, required RxBool value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Obx(() => Switch(
            value: value.value,
            onChanged: (bool newValue) => value.value = newValue,
            activeColor: const Color(0xFFC498EE), // Match the purple active tint
            activeTrackColor: const Color(0xFFE2C9FA),
          )),
        ],
      ),
    );
  }
}
