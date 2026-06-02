import 'package:flutter/material.dart';

import '../core/utils/snackbar_helper.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final email = TextEditingController();
  final password = TextEditingController();

  final auth = AuthService();

  bool isLoading = false;
  bool obscurePassword = true;
  bool agreePolicy = true;

  Future<void> register() async {
    setState(() => isLoading = true);

    String? token = await auth.signUp(email.text.trim(), password.text.trim());

    setState(() => isLoading = false);

    if (token != null) {
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      showError("Đăng ký thất bại");
    }
  }

  Future<void> loginGoogle() async {
    setState(() => isLoading = true);

    String? token = await auth.signInWithGoogle();

    setState(() => isLoading = false);

    if (token != null) {
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      showError("Google login failed");
    }
  }

  void showError(String msg) {
    showAppSnackBar(context, SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8F2),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 430),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.75),
                borderRadius: BorderRadius.circular(35),
                border: Border.all(color: Colors.white.withOpacity(.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: -10,
                    left: -10,
                    child: Icon(
                      Icons.shopping_cart,
                      size: 70,
                      color: Colors.blue.withOpacity(.15),
                    ),
                  ),

                  Positioned(
                    bottom: -15,
                    right: -5,
                    child: Icon(
                      Icons.shopping_bag,
                      size: 65,
                      color: Colors.orange.withOpacity(.12),
                    ),
                  ),

                  Column(
                    children: [
                      const SizedBox(height: 10),

                      // LOGO
                      Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.75),
                          borderRadius: BorderRadius.circular(42),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.08),
                              blurRadius: 35,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          "assets/logo/vexo_logo1.png",
                          width: 70,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 22),

                      const Text(
                        "Vexo",
                        style: TextStyle(
                          fontSize: 31,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1F2937),
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        "Tạo tài khoản mua sắm của bạn",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),

                      const SizedBox(height: 42),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Tạo tài khoản",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff1F2937),
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Đăng ký để bắt đầu mua sắm",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // EMAIL
                      _buildInput(
                        controller: email,
                        hint: "Email hoặc Số điện thoại",
                        icon: Icons.alternate_email,
                      ),

                      const SizedBox(height: 18),

                      // PASSWORD
                      _buildInput(
                        controller: password,
                        hint: "Mật khẩu",
                        icon: Icons.lock_outline,
                        obscure: obscurePassword,
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      Row(
                        children: [
                          Transform.scale(
                            scale: .9,
                            child: Checkbox(
                              value: agreePolicy,
                              activeColor: const Color(0xff137FEC),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              onChanged: (v) {
                                setState(() {
                                  agreePolicy = v ?? false;
                                });
                              },
                            ),
                          ),

                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                                children: [
                                  TextSpan(text: "Tôi đồng ý với "),
                                  TextSpan(
                                    text: "điều khoản",
                                    style: TextStyle(
                                      color: Color(0xff137FEC),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(text: " và "),
                                  TextSpan(
                                    text: "chính sách",
                                    style: TextStyle(
                                      color: Color(0xff137FEC),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // REGISTER BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: isLoading || !agreePolicy
                              ? null
                              : register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff137FEC),
                            elevation: 8,
                            shadowColor: const Color(
                              0xff137FEC,
                            ).withOpacity(.35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  "Tạo tài khoản",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey.shade300)),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              "HOẶC",
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),

                          Expanded(child: Divider(color: Colors.grey.shade300)),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // GOOGLE BUTTON
                      GestureDetector(
                        onTap: loginGoogle,
                        child: Container(
                          height: 58,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                'https://cdn-icons-png.flaticon.com/512/300/300221.png',
                                width: 24,
                                height: 24,
                              ),

                              const SizedBox(width: 14),

                              const Text(
                                "Đăng ký với Google",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff374151),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Đã có tài khoản? Đăng nhập",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff137FEC),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Container(
      height: 62,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const SizedBox(width: 18),

          Icon(icon, color: Colors.grey.shade400),

          const SizedBox(width: 12),

          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
              ),
            ),
          ),

          if (suffix != null) suffix,

          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
