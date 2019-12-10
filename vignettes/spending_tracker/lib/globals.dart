double lerp(double x, double y, double s) {
  return x * (1 - s) + y * s;
}

String numberToPriceString(num value) {
  return value.toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
}
