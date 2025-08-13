//  make a enum for sort order of either ascending or descending.

enum SortOrder {
  ascending,
  descending
}

extension SortOrderExtension on SortOrder {
  String get displayName {
    switch (this) {
      case SortOrder.ascending:
        return 'Ascending';
      case SortOrder.descending:
        return 'Descending';
    }
  }
}