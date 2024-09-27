import 'package:demo_food/FoodDetailBottomSheet.dart';
import 'package:demo_food/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'data/Events.dart';
import 'data/FoodBloc.dart';
import 'filterChip.dart';
import 'widgets.dart';

class FoodAppDesign extends StatelessWidget {
  final PageController _controller = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FoodAppDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FoodBloc()..add(LoadFoodEvent())),
        // Trigger data load
        BlocProvider(create: (context) => QuantityBloc()),
        // Provide QuantityBloc
      ], // Trigger data load
      child: MaterialApp(theme: ThemeData(primaryColor: ColorConstants.lightPurple),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            address: '100a Ealing Rd',
            deliveryTime: '24 mins',
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(Icons.search, color: Colors.black),
              ),
              // Add more actions if needed
            ],
          ),
          body: BlocBuilder<FoodBloc, FoodState>(builder: (context, state) {
            if (state is FoodLoadingState) {
              return  Center(
              child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(ColorConstants.black),
            ),);
            } else if (state is FoodLoadedState) {
              // Use the data from the JSON here
              final foodItems = state.data.foodItems;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hits of the Week
                  const SizedBox(height: 28),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Hits of the week',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                  const SizedBox(height: 8),

                  // PageView for Hits of the Week with Smooth Indicator
                  SizedBox(
                    height: 312,
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: state.data.sliders.length,
                      // Get the number of sliders
                      itemBuilder: (context, index) {
                        // Use the slider data to build each page item
                        final slider = state.data.sliders[index];
                        return buildPageItem(
                          slider.title,
                          slider.description,
                          45.00,
                          // You might want to change this to a dynamic price or any other field
                          context,
                          slider.image,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: SmoothPageIndicator(
                      controller: _controller,
                      count: 4,
                      effect: ScrollingDotsEffect(
                        // Use ScrollingDotsEffect for a look similar to the image
                        dotHeight: 2,
                        // Smaller dot height
                        dotWidth: 64,
                        // Longer dot width for a scrolling effect
                        activeDotColor: Colors.black,
                        dotColor: Colors.grey.shade300,
                        spacing: 24, // Adjust spacing between dots
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Filter Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.filter_list, color: Colors.black),
                        ),
                        const SizedBox(width: 10),
                        ...state.data.categories.map((category) {
                          // Example: Track selected state for each category
                          return Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            // Space between chips
                            child: FilterChips(
                              category,
                            ),
                          );
                        }),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: foodItems.length,
                      itemBuilder: (context, index) {
                        var food = foodItems[index];
                        return GestureDetector(
                          onTap: () {
                            // Reset quantity when the item is tapped
                            context.read<QuantityBloc>().add(ResetQuantity());
                            // Show the modal bottom sheet
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(28.0)),
                              ),
                              builder: (BuildContext context) {
                                return FoodDetailBottomSheet
                                    .buildFoodDetailBottomSheet(
                                        _scaffoldKey.currentContext!, food);
                              },
                            );
                          },
                          child: buildFoodItem(food.name, "\$${food.price}",
                              food.calories, food.image),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (state is FoodErrorState) {
              return Center(child: Text(state.error));
            }
            return Container();
          }),
        ),
      ),
    );
  }
}

void main() => runApp(FoodAppDesign());
