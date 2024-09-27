import 'package:demo_food/models/FoodsModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'CartBottomSheet.dart';

class FoodDetailBottomSheet {
  static Widget buildFoodDetailBottomSheet(BuildContext context, FoodItem food) {
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      _buildCircularImage(food.image),
                      SizedBox(height: 28),
                      _buildTitle(food.name),
                      SizedBox(height: 10),
                      _buildDescription(food.description),
                      SizedBox(height: 20),
                      _buildNutritionalInfo(food.calories),
                      SizedBox(height: 20),
                      _buildAddInPokeSection(context),
                      SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        _buildIndicator(context),
        _buildBottomButton(context, food),
      ],
    );
  }

  static Widget _buildCircularImage(String image) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 6,
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 100,
          backgroundImage: NetworkImage(image),
          backgroundColor: Colors.grey[200],
        ),
      ),
    );
  }

  static Widget _buildTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  static Widget _buildDescription(String description) {
    return Text(
      description,
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey[600],
      ),
    );
  }

  static Widget _buildNutritionalInfo(String calories) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NutritionalItem(value: calories.substring(0, 4), label: 'kcal'),
          NutritionalItem(value: '420', label: 'grams'),
          NutritionalItem(value: '21', label: 'proteins'),
          NutritionalItem(value: '19', label: 'fats'),
          NutritionalItem(value: '65', label: 'carbs'),
        ],
      ),
    );
  }

  static Widget _buildAddInPokeSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Add in poke',
          style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16),
        ),
      ],
    );
  }

  static Widget _buildIndicator(BuildContext context) {
    return Positioned(
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
    );
  }

  static Widget _buildBottomButton(BuildContext context, FoodItem food) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildQuantitySelector(context),
            _buildAddToCartButton(context, food),
          ],
        ),
      ),
    );
  }

  static Widget _buildQuantitySelector(BuildContext context) {
    return BlocBuilder<QuantityBloc, QuantityState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[300],
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  context.read<QuantityBloc>().add(DecreaseQuantity());
                },
                icon: Icon(Icons.remove),
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text('${state.quantity}', style: TextStyle(fontSize: 18)),
              ),
              IconButton(
                onPressed: () {
                  context.read<QuantityBloc>().add(IncreaseQuantity());
                },
                icon: Icon(Icons.add),
                color: Colors.black,
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildAddToCartButton(BuildContext context, FoodItem food) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        _showCustomSnackbar(context, food);
        // Add to cart logic
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.black.withOpacity(0.8),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      child: Row(
        children: [
          Text('Add to cart', style: TextStyle(color: Colors.white)),
          SizedBox(width: 10),
          Text('\$${(food.price * context.read<QuantityBloc>().state.quantity).toStringAsFixed(2)}', style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }

  static void _showCustomSnackbar(BuildContext context, FoodItem food) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: Duration(seconds: 4),
      content: GestureDetector(
        onTap: () {
          Future.delayed(Duration(milliseconds: 100), () {
            if (ScaffoldMessenger.of(context).mounted) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return CartBottomSheet.buildCartBottomSheet(context, food);
                },
              );
            }
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 6),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text("Cart", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text("24 min", style: TextStyle(color: Colors.white)),
                        SizedBox(width: 8),
                        Text("• \$${food.price}", style: TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class NutritionalItem extends StatelessWidget {
  final String value;
  final String label;

  const NutritionalItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
// quantity_event.dart
abstract class QuantityEvent {}

class IncreaseQuantity extends QuantityEvent {}

class DecreaseQuantity extends QuantityEvent {}

class ResetQuantity extends QuantityEvent {}

// New events for cutlery
class IncreaseCutleryQuantity extends QuantityEvent {}
class DecreaseCutleryQuantity extends QuantityEvent {}


// quantity_state.dart
abstract class QuantityState {
  final int quantity;        // For food items
  final int cutleryQuantity; // For cutlery
  QuantityState(this.quantity, this.cutleryQuantity);
}

class QuantityInitial extends QuantityState {
  QuantityInitial() : super(1, 1); // Default quantities
}

class QuantityUpdated extends QuantityState {
  QuantityUpdated(int quantity, int cutlery) : super(quantity, cutlery);
}

class QuantityBloc extends Bloc<QuantityEvent, QuantityState> {
  QuantityBloc() : super(QuantityInitial()) {
    on<IncreaseQuantity>((event, emit) {
      final newQuantity = state.quantity + 1;
      emit(QuantityUpdated(newQuantity, state.cutleryQuantity));
    });

    on<DecreaseQuantity>((event, emit) {
      if (state.quantity > 1) {
        final newQuantity = state.quantity - 1;
        emit(QuantityUpdated(newQuantity, state.cutleryQuantity));
      }
    });

    on<IncreaseCutleryQuantity>((event, emit) {
      final newCutleryQuantity = state.cutleryQuantity + 1;
      emit(QuantityUpdated(state.quantity, newCutleryQuantity));
    });

    on<DecreaseCutleryQuantity>((event, emit) {
      if (state.cutleryQuantity > 1) {
        final newCutleryQuantity = state.cutleryQuantity - 1;
        emit(QuantityUpdated(state.quantity, newCutleryQuantity));
      }
    });

    on<ResetQuantity>((event, emit) {
      emit(QuantityUpdated(1, 1));
    });
  }
}

