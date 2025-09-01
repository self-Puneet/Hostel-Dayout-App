// make a state in which iserrored, errorMessage, isloading and related methods and get things should be there + there shou be another thing i.e. a list of strings which would be shown as option in segmented control and the selected filter among those option and related filters too.

import 'package:flutter/material.dart';

class HistoryState extends ChangeNotifier {
  bool isLoading = false;
  bool isErrored = false;
  String errorMessage = '';
  List<String> filterOptions = const [
    "All",
    "Cancelled",
    "Accepted",
    "Rejected",
  ];
  String selectedFilter = 'All';

  // update states
  void updateLoadingState(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  void updateErrorState(bool isErrored, String errorMessage) {
    this.isErrored = isErrored;
    this.errorMessage = errorMessage;
    notifyListeners();
  }

  void updateFilterOptions(List<String> options) {
    filterOptions = options;
    // Reset selected filter if it's not in the new options
    if (!options.contains(selectedFilter)) {
      selectedFilter = options.isNotEmpty ? options[0] : '';
    }
    notifyListeners();
  }

  void updateSelectedFilter(String filter) {
    selectedFilter = filter;
    notifyListeners();
  }
}
