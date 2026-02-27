import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/padee_controller.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final PadeeController controller = Get.put(PadeeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F9), // Light background matching design
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'app_title'.tr,
          style: const TextStyle(
            color: Color(0xFFC498EE), // Light purple title text
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt, color: Colors.black, size: 28),
            onPressed: () {
              Get.defaultDialog(
                title: 'reset_title'.tr,
                middleText: 'reset_desc'.tr,
                textConfirm: 'yes'.tr,
                textCancel: 'no'.tr,
                confirmTextColor: Colors.white,
                buttonColor: const Color(0xFFC498EE),
                onConfirm: () {
                  controller.resetCounts();
                  Get.back(); // Close the dialog
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black, size: 28),
            onPressed: () {
              Get.to(() => SettingsScreen());
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Section (Counter Display)
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Circular Bead Counter
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFC498EE).withOpacity(0.5),
                        width: 8,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'bead_count'.tr,
                            style: const TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          Obx(() => Text(
                            '${controller.currentBeadCount.value} / ${controller.selectedBeadType.value}',
                            style: const TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Rounds Completed Label
                  Text(
                    'rounds_completed'.tr,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 12),

                  // Fancy Dotted Progress Row
                  Obx(() {
                    int rounds = controller.currentRoundCount.value;
                    int target = controller.targetRounds.value;
                    // Constrain dots to 10 for display purposes so it doesn't overflow, 
                    // or dynamically generate based on target (up to a limit).
                    int maxDots = target > 10 ? 10 : target; 
                    
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(maxDots, (index) {
                        // Logic to light up dots. If target is >10, we just show a representative ratio.
                        bool isCompleted = index < (rounds / target * maxDots).floor();
                        
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isCompleted ? 16 : 12,
                          height: isCompleted ? 16 : 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted 
                              ? const Color(0xFFC498EE)
                              : const Color(0xFFE2C9FA).withOpacity(0.5),
                            border: isCompleted 
                              ? Border.all(color: const Color(0xFFE2C9FA), width: 4)
                              : null,
                          ),
                        );
                      }),
                    );
                  }),

                  const SizedBox(height: 12),
                  // Text representation of rounds
                  Obx(() => Text(
                    '${controller.currentRoundCount.value} / ${controller.targetRounds.value}',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  )),
                ],
              ),
            ),

            // Bottom Section (Tap Area)
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFEAD2FF), // Soft upper purple
                      Color(0xFFDEC3FA), // Soft mid purple
                      Color(0xFFD6B2FA), // Slightly darker bottom purple
                    ],
                  ),
                ),
                child: Center(
                  child: AnimatedTapButton(
                    onTap: controller.incrementBead,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedTapButton extends StatefulWidget {
  final VoidCallback onTap;
  const AnimatedTapButton({super.key, required this.onTap});

  @override
  State<AnimatedTapButton> createState() => _AnimatedTapButtonState();
}

class _AnimatedTapButtonState extends State<AnimatedTapButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowBlurAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150), // Snappy duration
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _shadowBlurAnimation = Tween<double>(begin: 16.0, end: 4.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent, // Inherits gradient behind it,
                boxShadow: [
                  // Outer shell highlight
                  BoxShadow(
                    color: Colors.white.withOpacity(0.4),
                    offset: Offset(-(_shadowBlurAnimation.value / 2), -(_shadowBlurAnimation.value / 2)),
                    blurRadius: _shadowBlurAnimation.value,
                  ),
                  // Outer shell shadow
                  BoxShadow(
                    color: const Color(0xFFB580E2).withOpacity(0.5),
                    offset: Offset(_shadowBlurAnimation.value / 2, _shadowBlurAnimation.value / 2),
                    blurRadius: _shadowBlurAnimation.value,
                  ),
                ],
              ),
              // Inner soft circle
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFDCC1FD),
                  boxShadow: [
                    // Inner pushed highlight
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      offset: Offset(-(_shadowBlurAnimation.value / 4), -(_shadowBlurAnimation.value / 4)),
                      blurRadius: _shadowBlurAnimation.value / 2,
                    ),
                    // Inner pushed shadow
                    BoxShadow(
                      color: const Color(0xFFB580E2).withOpacity(0.3),
                      offset: Offset(_shadowBlurAnimation.value / 4, _shadowBlurAnimation.value / 4),
                      blurRadius: _shadowBlurAnimation.value / 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'tap_button'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
