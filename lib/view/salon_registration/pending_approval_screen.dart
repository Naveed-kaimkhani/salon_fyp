import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_salon/constants/app_colors.dart';
class PendingApprovalScreen extends StatefulWidget {
  const PendingApprovalScreen({Key? key}) : super(key: key);

  @override
  State<PendingApprovalScreen> createState() => _PendingApprovalScreenState();
}

class _PendingApprovalScreenState extends State<PendingApprovalScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _refreshStatus() async {
    setState(() => _isRefreshing = true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF5F5F5)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Icon
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: size.width * 0.4,
                    height: size.width * 0.4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.purple.withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.hourglass_bottom,
                      size: size.width * 0.2,
                      color: AppColors.purple,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.04),

                // Status Title
                Text(
                  'Account Approval Pending',
                  style: TextStyle(
                    fontSize: size.width * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: size.height * 0.02),

                // Status Message
                Text(
                  'Your account is currently under review.\nWe\'ll notify you once it\'s approved.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.width * 0.04,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: size.height * 0.03),

                // Estimated Time
                Container(
                  padding: EdgeInsets.all(size.width * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time, color: AppColors.purple),
                      SizedBox(width: size.width * 0.02),
                      Text(
                        'Estimated time: 24-48 hours',
                        style: TextStyle(
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.04),

                // Refresh Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isRefreshing ? null : _refreshStatus,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.purple,
                      padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: _isRefreshing
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.refresh, color: Colors.white),
                    label: Text(
                      _isRefreshing ? 'Checking Status...' : 'Check Status',
                      style: TextStyle(
                        fontSize: size.width * 0.04,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),

                // Contact Support Button
                TextButton.icon(
                  onPressed: () {
                    // Add contact support functionality
                    Get.snackbar(
                      'Contact Support',
                      'Our support team will assist you shortly',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  icon: const Icon(Icons.headset_mic_outlined),
                  label: const Text('Contact Support'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
