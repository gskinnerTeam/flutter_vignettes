import 'package:flutter/material.dart';

class CityData {
  final String name;
  final String title;
  final String description;
  final String information;
  final Color color;
  final List<HotelData> hotels;

  CityData({
    required this.title,
    required this.name,
    required this.description,
    required this.information,
    required this.color,
    required this.hotels,
  });
}

class HotelData {
  final String name;
  final double rating;
  final int reviews;
  final double price;

  HotelData(this.name, {required this.reviews, required this.price, required this.rating});
}

class DemoData {
  CityData _city = CityData(
      name: 'Paris',
      title: 'Paris, France',
      description: 'Get ready to explore the city of love filled with romantic scenery and experiences.',
      information:
          'Paris, located along the Seine River, in the north-central part of France. For centuries, Paris has been one of the world’s most important and attractive cities.',
      color: Color(0xfffdeed5),
      hotels: [
        HotelData('Shangri-La Hotel Paris', reviews: 201, price: 593.0, rating: 5),
        HotelData('Hôtel Trinité Haussmann', reviews: 133, price: 391, rating: 3),
        HotelData('Maison Breguet', reviews: 128, price: 399, rating: 4),
      ]);

  CityData getCity() => _city;
}
