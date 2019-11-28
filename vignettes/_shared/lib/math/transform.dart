
/// Linearly maps values in the range (0, pIn) to (0, pOut) and values in the range (pIn, 1) to (pOut, 1)
double piecewiseSinglePointLinearTransform(double pIn, double pOut, double x) {
  final lowerScale = pOut / pIn;
  final upperScale = (1.0 - pOut) / (1.0 - pIn);
  final upperOffset = 1.0 - upperScale;
  return x < pIn ? x * lowerScale : x * upperScale + upperOffset;
}

