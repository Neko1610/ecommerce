import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/payment_method_model.dart';
import '../../providers/PaymentProvider.dart';
import '../widgets/payment/add_payment_button.dart';
import '../widgets/payment/payment_app_bar.dart';
import '../widgets/payment/payment_method_card.dart';
import '../widgets/payment/payment_note_box.dart';
import 'add_payment_method_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PaymentProvider>().loadMethods();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentProvider>();

    final methods = provider.paymentMethods;

    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      extendBody: true,

      body: SafeArea(
        bottom: false,

        child: Column(
          children: [
            const PaymentAppBar(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // SECURITY BOX
                    Container(
                      padding: const EdgeInsets.all(18),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),

                        color: const Color(0xffDBEAFE),
                      ),

                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,

                            decoration: BoxDecoration(
                              color: const Color(0xff137FEC),

                              borderRadius: BorderRadius.circular(18),
                            ),

                            child: const Icon(
                              Icons.verified_user_rounded,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  'Giao dịch an toàn 100%',

                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w800,

                                    fontSize: 15,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  'Thông tin thanh toán được mã hóa và bảo mật tuyệt đối.',

                                  style: GoogleFonts.inter(
                                    fontSize: 12,

                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Text(
                          'Phương thức thanh toán',

                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,

                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        if (methods.isNotEmpty)
                          Text(
                            'MẶC ĐỊNH',

                            style: GoogleFonts.inter(
                              color: const Color(0xff137FEC),

                              fontWeight: FontWeight.w700,

                              fontSize: 11,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // EMPTY STATE
                    if (methods.isEmpty)
                      Container(
                        width: double.infinity,

                        padding: const EdgeInsets.symmetric(
                          vertical: 40,
                          horizontal: 20,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(24),
                        ),

                        child: Column(
                          children: [
                            const Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 50,
                              color: Colors.grey,
                            ),

                            const SizedBox(height: 14),

                            Text(
                              'Chưa có phương thức thanh toán',

                              style: GoogleFonts.inter(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // PAYMENT METHODS
                    Column(
                      children: List.generate(methods.length, (index) {
                        final payment = methods[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 18),

                          child: Slidable(
                            key: ValueKey(payment.id),

                            endActionPane: ActionPane(
                              motion: const StretchMotion(),

                              children: [
                                SlidableAction(
                                  onPressed: (_) async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AddPaymentMethodScreen(
                                          method: payment,
                                        ),
                                      ),
                                    );
                                  },

                                  backgroundColor: Colors.blue,

                                  foregroundColor: Colors.white,

                                  icon: Icons.edit,

                                  label: 'Sửa',
                                ),

                                SlidableAction(
                                  onPressed: (_) async {
                                    await provider.unlinkMethod(payment.id);
                                  },

                                  backgroundColor: Colors.red,

                                  foregroundColor: Colors.white,

                                  icon: Icons.link_off,

                                  label: 'Hủy',
                                ),
                              ],
                            ),

                            child: Material(
                              color: Colors.transparent,

                              child: InkWell(
                                borderRadius: BorderRadius.circular(24),

                                onTap: () async {
                                  await provider.setDefaultMethod(payment.id);
                                },

                                child: AnimatedScale(
                                  scale: payment.isDefault ? 1 : 0.98,

                                  duration: const Duration(milliseconds: 250),

                                  child: _PaymentTile(
                                    key: ValueKey(
                                      '${payment.id}-${payment.isDefault}',
                                    ),

                                    payment: payment,

                                    isSelected: payment.isDefault,

                                    isDark:
                                        payment.type == PaymentType.creditCard,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 28),

                    const PaymentNoteBox(),

                    const SizedBox(height: 28),

                    // ADD BUTTON
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) => const AddPaymentMethodScreen(),
                          ),
                        );
                      },

                      child: const AddPaymentButton(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final PaymentMethodModel payment;
  final bool isSelected;
  final bool isDark;

  const _PaymentTile({
    super.key,
    required this.payment,
    required this.isSelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (payment.type == PaymentType.creditCard) {
      return PaymentMethodCard(
        isDark: isDark,
        number: payment.subtitle,
        expiry: payment.expiry ?? '',
      );
    }

    final color = switch (payment.type) {
      PaymentType.momo => const Color(0xffA50064),
      PaymentType.zaloPay => const Color(0xff0068FF),
      PaymentType.bank => const Color(0xff059669),
      PaymentType.creditCard => const Color(0xff2563EB),
    };

    final icon = switch (payment.type) {
      PaymentType.momo => Icons.account_balance_wallet_rounded,
      PaymentType.zaloPay => Icons.wallet_rounded,
      PaymentType.bank => Icons.account_balance_rounded,
      PaymentType.creditCard => Icons.credit_card_rounded,
    };

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? const Color(0xff137FEC) : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _maskedSubtitle(),
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
          if (isSelected)
            const Icon(Icons.check_circle_rounded, color: Color(0xff137FEC)),
          const SizedBox(width: 42),
        ],
      ),
    );
  }

  String _maskedSubtitle() {
    final value = payment.subtitle;

    if (payment.type == PaymentType.creditCard) {
      return value;
    }

    if (payment.type == PaymentType.momo ||
        payment.type == PaymentType.zaloPay) {
      if (value.length < 5) return value;

      return '${value.substring(0, 3)}*****${value.substring(value.length - 2)}';
    }

    if (payment.type == PaymentType.bank) {
      if (value.length < 4) return value;

      return '****${value.substring(value.length - 4)}';
    }

    return value;
  }
}
