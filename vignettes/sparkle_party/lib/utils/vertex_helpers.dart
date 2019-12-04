import 'dart:typed_data';

void injectVertex(int i, Float32List list, double l, double t, double r, double b) {
    i *= 12;
    // Injects position values for the 6 corners (two triangles) of a sprite.
    // right triangle:
    list[i + 0] = l; // x1 - tl
    list[i + 1] = t; // y1
    list[i + 2] = r; // x2 - tr
    list[i + 3] = t; // y2
    list[i + 4] = l; // x3 - bl
    list[i + 5] = b; // y3

    // right triangle:
    list[i + 6] = r; // x1 - tr
    list[i + 7] = t; // y1
    list[i + 8] = r; // x2 - br
    list[i + 9] = b; // y2
    list[i + 10] = l; // x3 - bl
    list[i + 11] = b; // y3
}

void injectColor(int i, Int32List list, int color) {
  i *= 6;
  // Injects color values for the 6 corners (two triangles) of a sprite.
  list[i + 0] = list[i + 1] = list[i + 2] = list[i + 3] = list[i + 4] = list[i + 5] = color;
}