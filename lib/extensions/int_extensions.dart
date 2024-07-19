extension IntExtension on int {
  int setBit(int pos, bool value) => value ? this | (1 << pos) : this & ((1 << pos) ^ -1);

  bool getBit(int pos) => (this & (1 << pos)) != 0;
}
