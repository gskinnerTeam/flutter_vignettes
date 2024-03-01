import 'package:flutter/material.dart';

class City {
  final String name;
  final String title;
  final String description;
  final Color color;
  final List<Hotel> hotels;

  City({required this.title, required this.name, required this.description, required this.color, required this.hotels});
}

class Hotel {
  final String name;
  final double rating;
  final int reviews;
  final int price;

  Hotel(this.name, {required this.reviews, required this.price, required this.rating});
}

class DemoData {
  List<City> _cities = [
    City(
        name: 'Pisa',
        title: 'Pisa, Italy',
        description: 'Discover a beautiful city where ancient and modern meet',
        color: Color(0xffdee5cf),
        hotels: [
          Hotel('Hotel Bologna', reviews: 201, price: 120, rating: 4),
          Hotel('Tree House', reviews: 85, price: 98, rating: 5),
          Hotel('Allegroitalia Pisa Tower Plaza', reviews: 128, price: 119, rating: 4),
        ]),
    City(
        name: 'Budapest',
        title: 'Budapest, Hungary',
        description: 'Meet the city with rich history and indescribable culture',
        color: Color(0xffdaf3f7),
        hotels: [
          Hotel('Hotel Estilo Budapest', reviews: 762, price: 87, rating: 5),
          Hotel('Danubius Hotel', reviews: 3122, price: 196, rating: 3),
          Hotel('Golden Budapest Condominium', reviews: 213, price: 217, rating: 5),
        ]),
    City(
        name: 'London',
        title: 'London, England',
        description: 'A diverse and exciting city with the world’s best sights and attractions!',
        color: Color(0xfff9d9e2),
        hotels: [
          Hotel('InterContinental London Hotel', reviews: 1624, price: 418, rating: 3),
          Hotel('Brick Lane Hotel', reviews: 101, price: 101, rating: 4),
          Hotel('Park Villa Boutique House', reviews: 161, price: 128, rating: 5),
        ]),
  ];

  List<City> getCities() => _cities;
  List<Hotel> getHotels(City city) => city.hotels;
}
