import 'package:demo_food/models/FoodsModel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

import 'Events.dart';




class FoodBloc extends Bloc<FoodEvent, FoodState> {
  FoodBloc() : super(FoodLoadingState()) {
    on<LoadFoodEvent>(_onLoadFood);
  }

  Future<void> _onLoadFood(LoadFoodEvent event, Emitter<FoodState> emit) async {
    emit(FoodLoadingState());
    // Introduce a delay of 2 seconds
    await Future.delayed(Duration(seconds: 1));
    try {
      // Load the JSON data from assets
      final jsonData = await rootBundle.loadString('assets/food_data.json');
      final data = FoodData.fromJson(json.decode(jsonData));
      emit(FoodLoadedState(data));
    } catch (e) {
      emit(FoodErrorState(e.toString()));
    }
  }
}
abstract class FoodState extends Equatable {
  const FoodState();

  @override
  List<Object> get props => [];
}

class FoodLoadingState extends FoodState {}

class FoodLoadedState extends FoodState {
  final FoodData data;

  const FoodLoadedState(this.data);

  @override
  List<Object> get props => [data];
}

class FoodErrorState extends FoodState {
  final String error;

  const FoodErrorState(this.error);

  @override
  List<Object> get props => [error];
}