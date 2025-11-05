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
  static const String parentRequestDetails = '/parent/request/:id';
  static const String wardenRequestDetails = '/warden/request/:id';
  static String requestDetailsPath(String id) => '/student/request/$id';
  static String parentLayoutPath(String id) => '/parent/request/$id';
  static String wardenRequestDetailsPath(String id) => '/warden/request/$id';
  static const String parentProfile = '/parent/profile';

  static const String wardenProfile = '/warden/profile';
  static const String wardenHistory = '/warden/history';
  static const String wardenActionPage = '/warden/action-page';

  // static const String productDetails = '/student/product-details/:id';
  // static String productDetailsPath(String id) => '/student/product-details/$id';

  static const Map<TimelineActor, List<String>> routeAllowence = {
    TimelineActor.student: [
      studentHome,
      profile,
      history,
      requestForm,
      login,
      '/student/request',
    ],
    TimelineActor.assistentWarden: [
      wardenHome,
      wardenProfile,
      login,
      requestDetails,
      '/warden/request',
      '/warden/request/:id',
      wardenActionPage,
      wardenHistory,
      seniorWardenHome,
    ],
    TimelineActor.seniorWarden: [
      seniorWardenHome,
      wardenProfile,
      login,
      requestDetails,
      '/warden/request',
      '/warden/request/:id',
      wardenActionPage,
      wardenHistory,
    ],
    TimelineActor.parent: [
      parentHome,
      parentProfile,
      login,
      parentHistory,
      '/parent/request',
      '/parent/request/:id',
    ],
  };
}
