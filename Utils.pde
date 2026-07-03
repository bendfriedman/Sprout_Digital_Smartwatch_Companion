// boolean hitRect(int px, int py, float x, float y, float w, float h) {
//   return px >= x && px <= x + w && py >= y && py <= y + h;
// }

boolean hitRect(int px, int py, Rect r) {
  return px >= r.x && px <= r.x + r.w && py >= r.y && py <= r.y + r.h;
}

// void drawFitted(PImage img, float bx, float by, float bw, float bh) {
//   float scale = min(bw / img.width, bh / img.height);  // kleinerer faktor -> passt rein
//   float w = img.width * scale;
//   float h = img.height * scale;
//   image(img, bx + (bw - w)/2, by + (bh - h)/2, w, h);  // in box zentriert
// }

void drawFitted(PImage img, Rect r) {
  float scale = min(r.w / img.width, r.h / img.height);
  float w = img.width * scale;
  float h = img.height * scale;
  image(img, r.x + (r.w - w)/2, r.y + (r.h - h)/2, w, h);
}
