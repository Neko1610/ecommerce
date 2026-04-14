import 'package:flutter/material.dart';
import '../widgets/shipping/address_list.dart';
import '../widgets/shipping/add_address_button.dart';


class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() =>
      _ShippingAddressScreenState();
}

class _ShippingAddressScreenState
    extends State<ShippingAddressScreen> {
  final GlobalKey<AddressListState> listKey = GlobalKey();

  void reload() {
    listKey.currentState?.loadAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shipping Address")),

      body: AddressList(key: listKey),

      floatingActionButton: AddAddressButton(
        onAdded: reload,
      ),
    );
  }
}