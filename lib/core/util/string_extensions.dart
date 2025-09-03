extension StringCasingExtension on String {
  String get capitalizeFirst {
    if (isEmpty) return this;
    this.split(" ".)
    return this[0].toUpperCase() + substring(1);
  }

  String get initials {
    if (trim().isEmpty) return "";

    // Split by space, filter out empty parts
    final parts = trim()
        .split(RegExp(r"\s+"))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return "";
    String first = parts[0][0];
    String second = parts.length > 1 ? parts.last[0] : "";

    return (first + second).toUpperCase();
  }
}
