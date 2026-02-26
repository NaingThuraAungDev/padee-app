import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/padee_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final PadeeController controller = Get.put(PadeeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app_title'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: 'Change Language',
            onPressed: () {
              // Toggle between English and Myanmar
              if (Get.locale?.languageCode == 'my') {
                Get.updateLocale(const Locale('en', 'US'));
              } else {
                Get.updateLocale(const Locale('my', 'MM'));
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Counts',
            onPressed: () {
              // Ask for confirmation before resolving
              Get.defaultDialog(
                title: 'reset_title'.tr,
                middleText: 'reset_desc'.tr,
                textConfirm: 'yes'.tr,
                textCancel: 'no'.tr,
                confirmTextColor: Colors.white,
                onConfirm: () {
                  controller.resetCounts();
                  Get.back();
                },
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Settings Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text('bead_type'.tr, style: Theme.of(context).textTheme.titleMedium),
                            ),
                            Obx(() => DropdownButton<int>(
                              value: controller.selectedBeadType.value,
                              items: controller.beadOptions.map((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text('${value} ${'beads_suffix'.tr}'),
                                );
                              }).toList(),
                              onChanged: (int? newValue) {
                                if (newValue != null) {
                                  controller.setBeadType(newValue);
                                }
                              },
                            )),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text('target_rounds'.tr, style: Theme.of(context).textTheme.titleMedium),
                            ),
                            SizedBox(
                              width: 100,
                              child: TextFormField(
                                initialValue: controller.targetRounds.value.toString(),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                                onChanged: (value) {
                                  int? target = int.tryParse(value);
                                  if (target != null) {
                                    controller.setTargetRounds(target);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 48),

                // Progress Display
                Obx(() => Column(
                  children: [
                    Text(
                      'bead_count'.tr,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      '${controller.currentBeadCount.value} / ${controller.selectedBeadType.value}',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'rounds_completed'.tr,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '${controller.currentRoundCount.value} / ${controller.targetRounds.value}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )),

                const SizedBox(height: 48),

                // Main Tap Area
                GestureDetector(
                  onTap: controller.incrementBead,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        )
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'tap_button'.tr,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
