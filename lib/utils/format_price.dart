String formatPrice(double price) {
  final rounded = price.round();
  final text = rounded.toString();
  final buffer = StringBuffer();

  for (int i = 0; i < text.length; i++) {
    buffer.write(text[i]);
    final remaining = text.length - i - 1;
    if (remaining > 0 && remaining % 3 == 0) {
      buffer.write('.');
    }
  }

  return '${buffer.toString()}d';
}
