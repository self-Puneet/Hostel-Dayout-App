import 'package:get_it/get_it.dart';
import 'package:hostel_dayout_app/core/network_info.dart';
import 'package:hostel_dayout_app/requests/domain/usecase/get_priority_request.dart';
import 'package:http/http.dart' as http;
import 'package:hostel_dayout_app/core/network_info_impl.dart';
import 'package:hostel_dayout_app/requests/data/datasource/request_local_datasource.dart';
import 'package:hostel_dayout_app/requests/data/datasource/request_remote_datasource.dart';
import 'package:hostel_dayout_app/requests/data/repository/request_repository_impl.dart';
import 'package:hostel_dayout_app/requests/domain/repository/request_repository.dart';
import 'package:hostel_dayout_app/requests/domain/usecase/get_requests.dart';
import 'package:hostel_dayout_app/requests/domain/usecase/get_request_detail.dart';
import 'package:hostel_dayout_app/requests/presentation/bloc/request_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:hive/hive.dart';
import 'package:hostel_dayout_app/requests/data/models/request_model.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  sl.registerLazySingleton<Box<RequestModel>>(
    () => Hive.box<RequestModel>('requests'),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Data sources
  sl.registerLazySingleton<RequestRemoteDataSource>(
    () => RequestRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<RequestLocalDataSource>(
    () => RequestLocalDataSourceImpl(requestBox: sl()),
  );

  // Repository
  sl.registerLazySingleton<RequestRepository>(
    () => RequestRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetRequests(sl()));
  sl.registerLazySingleton(() => GetRequestDetail(sl()));
  sl.registerLazySingleton(() => GetPriorityRequests(sl()));

  // Bloc
  sl.registerFactory(
    () => RequestListBloc(
      getAllRequests: sl(),
      getRequestDetail: sl(),
      getPriorityRequests: sl(),
    ),
  );
}
