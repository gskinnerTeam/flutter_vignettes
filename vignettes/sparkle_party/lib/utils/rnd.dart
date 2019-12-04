import 'dart:math';

class Rnd {
  static int _seed = DateTime.now().millisecondsSinceEpoch;

  static Random random = Random(_seed);

  static set seed(int val) => random = Random(_seed = val);
  static int get seed => _seed;

  static get ratio => random.nextDouble();

  static int getInt(int min, int max) {
    return min + random.nextInt(max-min);
  }

  static double getDouble(double min, double max) {
    return min + random.nextDouble() * (max - min);
  }

  static bool getBool([double chance=0.5]) {
    return random.nextDouble() < chance;
  }

  static int getBit([double chance=0.5]) {
    return random.nextDouble() < chance ? 1 : 0;
  }

  static int getSign([double chance=0.5]) {
    return random.nextDouble() < chance ? 1 : -1;
  }

  static double getDeg() {
    return getDouble(0, 360);
  }

  static double getRad() {
    return getDouble(0, pi * 2);
  }

  static List shuffle(List list) {
		for (int i=0, l = list.length; i<l; i++) {
			int j = random.nextInt(l);
			if (j==i) { continue; }
			dynamic item = list[j];
			list[j] = list[i];
			list[i] = item;
		}
		return list;
	}

  static dynamic getItem(List list) {
    return list[(list.length * random.nextDouble()).floor()];
  }
}