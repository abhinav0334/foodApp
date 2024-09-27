// cart_bottom_sheet.dart

import 'package:demo_food/Utils/StringUtils.dart';
import 'package:demo_food/models/FoodsModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'FoodDetailBottomSheet.dart';

class CartBottomSheet {
  static Widget buildCartBottomSheet(BuildContext context, FoodItem food) {
    return Stack(
      children: [
        // Background
        Container(
          color: Colors.black.withOpacity(0.5),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.90,
          maxChildSize: 0.90,
          minChildSize: 0.90,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Address Information
                      SizedBox(height: 20),
                      Text(
                        "We will deliver in \n24 minutes to the address:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            "100a Ealing Rd",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 16),
                          ),
                          TextButton(
                            onPressed: () {
                              // Handle change address
                            },
                            child: Text(
                              "Change address",
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 28),
                      // Product Details
                      _buildProductDetails(food),
                      SizedBox(height: 16),
                      Divider(color: Colors.grey[200]),
                      SizedBox(height: 16),
                      // Cutlery Option
                      _buildCutleryOption(),
                      SizedBox(height: 16),
                      Divider(color: Colors.grey[200]),
                      SizedBox(height: 16),
                      // Delivery Information
                      _buildDeliveryInformation(),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        // Indicator
        Positioned(
          top: 72,
          left: MediaQuery.of(context).size.width / 2 - 20,
          child: Container(
            width: 40,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        // Pay Button at the bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildPaymentButton(context),
          ),
        ),
      ],
    );
  }

  static Widget _buildProductDetails(FoodItem food) {
    return BlocBuilder<QuantityBloc, QuantityState>(
      builder: (context, state) {
        return Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 12,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 36, // Bigger size
                backgroundImage: NetworkImage(
                  food.image, // Replace with your image link
                ),
                backgroundColor: Colors.grey[200],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(food.name,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            height: 1.2,
                          )),
                      Text(
                        "\$${food.price}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _buildCounterButton(Icons.remove, () {
                            context.read<QuantityBloc>().add(DecreaseQuantity());
                          }),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              "${state.quantity}", // Show updated quantity
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          _buildCounterButton(Icons.add, () {
                            context.read<QuantityBloc>().add(IncreaseQuantity());
                          }),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget _buildCutleryOption() {
    return BlocBuilder<QuantityBloc, QuantityState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(width: 20),
                Icon(Icons.restaurant),
                SizedBox(width: 52),
                Text(
                  "Cutlery",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Row(
              children: [
                _buildCounterButton(Icons.remove, () {
                  context.read<QuantityBloc>().add(DecreaseCutleryQuantity());
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    "${state.cutleryQuantity}", // Show updated cutlery quantity
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                _buildCounterButton(Icons.add, () {
                  context.read<QuantityBloc>().add(IncreaseCutleryQuantity());
                }),
              ],
            ),
          ],
        );
      },
    );
  }

  static Widget _buildDeliveryInformation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Delivery",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "Free delivery from \$30",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "\$0.00",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  static Widget _buildPaymentButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(StringUtils.paymentMethod,
            style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
                fontWeight: FontWeight.w400)),
        ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.apple, size: 12, color: Colors.black),
                SizedBox(width: 2), // Space between icon and text
                Text(StringUtils.pay,
                    style: TextStyle(color: Colors.black, fontSize: 13)),
              ],
            ),
          ),
          title: Text(StringUtils.applePay,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          trailing: Icon(Icons.arrow_forward_ios,
              size: 16, color: Colors.black),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 28),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(0.8),
              padding: EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              // Handle payment
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(StringUtils.pay,
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text("24 min",
                              style: TextStyle(color: Colors.white)),
                          SizedBox(width: 8),
                          Text("• \$47.00",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16)),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  static Widget _buildCounterButton(IconData icon, VoidCallback onPressed) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
      ),
    );
  }
}
