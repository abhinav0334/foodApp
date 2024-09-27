import 'package:demo_food/Utils/Colors.dart';
import 'package:flutter/material.dart';

Widget buildPageItem(String title, String description, double price,
    BuildContext context, String url) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 260,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorConstants.lightBlue, // Start color
                ColorConstants.lightPurple, // End color
              ],
              begin: Alignment.topLeft, // Start from top-left
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Container(width: 180,
                      child: Text(
                        description,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                        maxLines: 2, // Limit to 2 lines
                        overflow: TextOverflow.ellipsis, // Show ellipsis if overflow
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 16),
                    padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Text(
                      '\$$price',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          top: 16,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Shadow color
                  blurRadius: 20, // Blur radius
                  spreadRadius: 4, // Spread radius
                  offset: const Offset(0, 8), // Shadow offset
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                url,
              ),
              backgroundColor: Colors.grey[200],
              radius: 90, // Avatar radius
            ),
          ),
        )
      ],
    ),
  );
}

//Food item
Widget buildFoodItem(
    String name, String price, String kcal, String imageUrl) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Image with shadow
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 4), // Shadow position
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
            backgroundColor: Colors.grey[200],
            radius: 60,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center the text for name
            Container(
              width: 200, // Set a width to center the text properly
              alignment: Alignment.centerLeft,
              child: Text(
                name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center, // Center alignment
              ),
            ),
            const SizedBox(height: 8),

            // Container for price and kcal
            Row(
              children: [
                // Price Container
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Center(
                    child: Text(
                      price,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Kcal text
                Text(
                  kcal,
                  style: const TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String address;
  final String deliveryTime;
  final List<Widget>? actions;

  CustomAppBar({
    required this.address,
    required this.deliveryTime,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Icon(Icons.menu, color: Colors.black),
      centerTitle: true,
      title: Container(
        padding: EdgeInsets.symmetric(horizontal: 36, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              address,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 8),
            Text(
              '• $deliveryTime',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      actions: actions ??
          [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(Icons.search, color: Colors.black),
            ),
          ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}