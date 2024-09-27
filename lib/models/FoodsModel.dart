import 'dart:convert';
import 'dart:convert';

class FoodData {
  final Location location;
  final List<Slider> sliders;
  final List<HitOfTheWeek> hitsOfTheWeek;
  final List<String> categories;
  final List<FoodItem> foodItems;

  FoodData({
    required this.location,
    required this.sliders,
    required this.hitsOfTheWeek,
    required this.categories,
    required this.foodItems,
  });

  factory FoodData.fromJson(Map<String, dynamic> json) {
    return FoodData(
      location: Location.fromJson(json['location']),
      sliders: List<Slider>.from(json['sliders'].map((x) => Slider.fromJson(x))),
      hitsOfTheWeek: List<HitOfTheWeek>.from(json['hits_of_the_week'].map((x) => HitOfTheWeek.fromJson(x))),
      categories: List<String>.from(json['categories']),
      foodItems: List<FoodItem>.from(json['food_items'].map((x) => FoodItem.fromJson(x))),
    );
  }
}

class Location {
  final String address;
  final String time;

  Location({required this.address, required this.time});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      address: json['address'],
      time: json['time'],
    );
  }
}

class Slider {
  final String image;
  final String title;
  final String description;

  Slider({required this.image, required this.title, required this.description});

  factory Slider.fromJson(Map<String, dynamic> json) {
    return Slider(
      image: json['image'],
      title: json['title'],
      description: json['description'],
    );
  }
}

class HitOfTheWeek {
  final String name;
  final String description;
  final double price;
  final String image;

  HitOfTheWeek({required this.name, required this.description, required this.price, required this.image});

  factory HitOfTheWeek.fromJson(Map<String, dynamic> json) {
    return HitOfTheWeek(
      name: json['name'],
      description: json['description'],
      price: json['price'],
      image: json['image'],
    );
  }
}

class FoodItem {
  final String name;
  final double price;
  final String calories;
  final String description;
  final String image;

  FoodItem({required this.name, required this.price, required this.calories, required this.image,required this.description});

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'],
      price: json['price'],
      calories: json['calories'],
      image: json['image'],
      description:json['description']
    );
  }
}
