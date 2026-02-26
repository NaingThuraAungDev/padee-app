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
        title: const Text('Padee Counter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Counts',
            onPressed: () {
              // Ask for confirmation before resolving
              Get.defaultDialog(
                title: 'Reset Counters?',
                middleText: 'Are you sure you want to reset your bead and round counts?',
                textConfirm: 'Yes',
                textCancel: 'No',
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
                            Text('Bead Type:', style: Theme.of(context).textTheme.titleMedium),
                            Obx(() => DropdownButton<int>(
                              value: controller.selectedBeadType.value,
                              items: controller.beadOptions.map((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text('${value} Beads'),
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
                            Text('Target Rounds:', style: Theme.of(context).textTheme.titleMedium),
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
                      'Bead Count',
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
                      'Rounds Completed',
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
                    child: const Center(
                      child: Text(
                        'TAP',
                        style: TextStyle(
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
