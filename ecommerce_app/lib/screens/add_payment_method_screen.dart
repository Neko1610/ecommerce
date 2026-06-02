import 'dart:math'; // Thêm thư viện này để dùng hàm max
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/payment_method_model.dart';
import '../../providers/PaymentProvider.dart';

import '../widgets/addpaymentmethod/payment_tabs.dart';
import '../widgets/addpaymentmethod/payment_card_preview.dart';
import '../widgets/addpaymentmethod/card_form_widget.dart';
import '../widgets/addpaymentmethod/wallet_section_widget.dart';
import '../widgets/addpaymentmethod/bank_section_widget.dart';

enum PaymentTab { card, wallet, bank }

class AddPaymentMethodScreen extends StatefulWidget {
  final PaymentMethodModel? method;

  const AddPaymentMethodScreen({super.key, this.method});

  @override
  State<AddPaymentMethodScreen> createState() => _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {
  static const primaryColor = Color(0xff137fec);
  static const bgColor = Color(0xfff6f7f8);

  final formKey = GlobalKey<FormState>();
  bool isSaving = false;
  final cardNumberController = TextEditingController();
  final holderController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();

  final walletPhoneController = TextEditingController();

  final bankNameController = TextEditingController();
  final bankAccountController = TextEditingController();
  final bankHolderController = TextEditingController();

  PaymentTab selectedTab = PaymentTab.card;
  PaymentType selectedWallet = PaymentType.momo;
  bool get isEditing => widget.method != null;

  @override
  void initState() {
    super.initState();
    final method = widget.method;

    if (method == null) return;

    switch (method.type) {
      case PaymentType.creditCard:
        selectedTab = PaymentTab.card;
        cardNumberController.text = method.subtitle.replaceAll('*', '').trim();
        holderController.text = method.title;
        expiryController.text = method.expiry ?? '';
        break;

      case PaymentType.momo:
      case PaymentType.zaloPay:
        selectedTab = PaymentTab.wallet;
        selectedWallet = method.type;
        walletPhoneController.text = method.subtitle;
        break;

      case PaymentType.bank:
        selectedTab = PaymentTab.bank;
        bankNameController.text = method.title;
        bankAccountController.text = method.subtitle;
        break;
    }
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    holderController.dispose();
    expiryController.dispose();
    cvvController.dispose();

    walletPhoneController.dispose();

    bankNameController.dispose();
    bankAccountController.dispose();
    bankHolderController.dispose();

    super.dispose();
  }

  Future<void> save() async {
    if (isSaving) return;

    if (formKey.currentState?.validate() == false) return;

    setState(() {
      isSaving = true;
    });

    try {
      final provider = context.read<PaymentProvider>();

      PaymentMethodModel method;

      switch (selectedTab) {
        case PaymentTab.card:
          final rawCardNum = cardNumberController.text.trim();

          final lastFourDigits = rawCardNum.length >= 4
              ? rawCardNum.substring(rawCardNum.length - 4)
              : rawCardNum;

          method = PaymentMethodModel(
            id: '',
            type: PaymentType.creditCard,
            title: 'Visa Card',
            subtitle: '**** $lastFourDigits',
          );

          break;

        case PaymentTab.wallet:
          method = PaymentMethodModel(
            id: '',
            type: selectedWallet,
            title: selectedWallet.displayTitle,
            subtitle: walletPhoneController.text.trim(),
          );

          break;

        case PaymentTab.bank:
          method = PaymentMethodModel(
            id: '',
            type: PaymentType.bank,
            title: bankNameController.text.trim(),
            subtitle: bankAccountController.text.trim(),
          );

          break;
      }

      await provider.addMethod(method);

      if (!mounted) return;

      Navigator.pop(context);
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // FIX TRIỆT ĐỂ: Nếu hệ thống trả về 0, ép buộc lấy tối thiểu 40px để né hoàn toàn nốt ruồi camera
    final double statusBarHeight = max(
      MediaQuery.of(context).padding.top,
      40.0,
    );

    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
            top: 8,
          ),
          child: SizedBox(
            height: 54,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: save,
              child: Text(
                isEditing ? 'Cập nhật phương thức' : 'Xác nhận liên kết',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            // Đẩy giao diện xuống một khoảng an toàn cố định bằng SizedBox
            SizedBox(height: statusBarHeight),

            // Thanh Custom AppBar
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isEditing ? "Edit Payment Method" : "Add Payment Method",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Phần nội dung cuộn bên dưới
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 8),
                  PaymentTabs(
                    selectedTab: selectedTab,
                    onChanged: (tab) {
                      setState(() {
                        selectedTab = tab;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: switch (selectedTab) {
                      PaymentTab.card => Column(
                        key: const ValueKey('CardTab'),
                        children: [
                          PaymentCardPreview(
                            cardNumber: cardNumberController.text,
                            holderName: holderController.text,
                            expiry: expiryController.text,
                          ),
                          const SizedBox(height: 24),
                          CardFormWidget(
                            cardNumberController: cardNumberController,
                            holderController: holderController,
                            expiryController: expiryController,
                            cvvController: cvvController,
                            onChanged: () {
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      PaymentTab.wallet => WalletSectionWidget(
                        key: const ValueKey('WalletTab'),
                        selectedWallet: selectedWallet,
                        phoneController: walletPhoneController,
                        onChanged: (wallet) {
                          setState(() {
                            selectedWallet = wallet;
                          });
                        },
                      ),
                      PaymentTab.bank => BankSectionWidget(
                        key: const ValueKey('BankTab'),
                        bankNameController: bankNameController,
                        bankAccountController: bankAccountController,
                        bankHolderController: bankHolderController,
                      ),
                    },
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.verified_user, color: Colors.green, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Thông tin của bạn được bảo mật tuyệt đối',
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
