import 'package:hostel_mgmt/core/enums/enum.dart';

class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  static const String initial = '/';
  static const String login = '/login';
  static const String studentHome = '/student/home';
  static const String wardenHome = '/warden/home';
  static const String seniorWardenHome = '/senior-warden/home';
  static const String parentHome = '/parent/home';
  static const String profile = '/profile';
  static const String history = '/student/history';
  static const String parentHistory = '/parent/history';
  static const String requestForm = '/student/create-request';
  static const String requestDetails = '/student/request/:id';
  static String requestDetailsPath(String id) => '/student/request/$id';

  // static const String productDetails = '/student/product-details/:id';
  // static String productDetailsPath(String id) => '/student/product-details/$id';

  static const Map<TimelineActor, List<String>> routeAllowence = {
    TimelineActor.student: [
      studentHome,
      profile,
      history,
      requestForm,
      login,
      requestDetails,
    ],
    TimelineActor.assistentWarden: [wardenHome, profile, login, requestDetails],
    TimelineActor.seniorWarden: [
      seniorWardenHome,
      profile,
      login,
      requestDetails,
    ],
    TimelineActor.parent: [parentHome, profile, login, requestDetails, parentHistory],
  };
}
