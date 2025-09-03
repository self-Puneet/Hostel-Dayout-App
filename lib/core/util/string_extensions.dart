extension StringCasingExtension on String {
  String get capitalizeFirst {
    if (trim().isEmpty) return this;

    return split(" ")
        .map(
          (word) =>
              word.isEmpty ? "" : word[0].toUpperCase() + word.substring(1),
        )
        .join(" ");
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
