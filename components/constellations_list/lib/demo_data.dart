import 'package:flutter/material.dart';

class ConstellationData {
  final String title;
  final String subTitle;
  final String image;

  final UniqueKey key = UniqueKey();

  ConstellationData(this.title, this.subTitle, this.image);
}

class DemoData {
  static final List<ConstellationData> _constellations = [
    ConstellationData("Aries", "The Ram", "Aries"),
    ConstellationData("Cassiopeia", "The Queen", "Cassiopeia"),
    ConstellationData("Camelopardalis", "The Giraffe", "Camelopardalis"),
    ConstellationData("Cetus", "The Whale", "Cetus"),
    ConstellationData("Pisces", "The Fishes", "Pisces"),

    ConstellationData("Aries", "The Ram", "Aries"),
    ConstellationData("Cassiopeia", "The Queen", "Cassiopeia"),
    ConstellationData("Camelopardalis", "The Giraffe", "Camelopardalis"),
    ConstellationData("Cetus", "The Whale", "Cetus"),
    ConstellationData("Pisces", "The Fishes", "Pisces"),

    ConstellationData("Aries", "The Ram", "Aries"),
    ConstellationData("Cassiopeia", "The Queen", "Cassiopeia"),
    ConstellationData("Camelopardalis", "The Giraffe", "Camelopardalis"),
    ConstellationData("Cetus", "The Whale", "Cetus"),
    ConstellationData("Pisces", "The Fishes", "Pisces"),
  ];

  List<ConstellationData> getConstellations() => _constellations;
}
