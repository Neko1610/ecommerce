import 'package:flutter/material.dart';

class AddressSection extends StatelessWidget {
  const AddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.location_on, color: Color(0xff137fec)),
            SizedBox(width: 6),
            Text(
              "Shipping Address",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Text(
              "Add New",
              style: TextStyle(
                color: Color(0xff137fec),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xff137fec), width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Chip(
                          label: Text("HOME"),
                          backgroundColor: Color(0xffe8f1ff),
                        ),
                        SizedBox(width: 6),
                        Text(
                          "Nguyễn Văn A",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      "123 Nguyễn Văn Cừ, Q5, TP.HCM",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://maps.gstatic.com/tactile/basepage/pegman_sherlock.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
