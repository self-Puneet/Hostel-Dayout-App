import 'package:get_it/get_it.dart';
import 'package:hostel_dayout_app/core/network_info.dart';
import 'package:hostel_dayout_app/core/network_info_impl.dart';
import 'package:hostel_dayout_app/features/auth/data/data_source/auth_local_data_source.dart';
import 'package:hostel_dayout_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:hostel_dayout_app/features/auth/data/repository/auth_repo_impl.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Requests
import 'package:hostel_dayout_app/features/requests/data/datasource/request_remote_datasource.dart';
import 'package:hostel_dayout_app/features/requests/data/models/request_model.dart';
import 'package:hostel_dayout_app/features/requests/data/repository/request_repository_impl.dart';
import 'package:hostel_dayout_app/features/requests/domain/repository/request_repository.dart';
import 'package:hostel_dayout_app/features/requests/domain/usecase/get_priority_request.dart';
import 'package:hostel_dayout_app/features/requests/domain/usecase/get_requests.dart';
import 'package:hostel_dayout_app/features/requests/domain/usecase/get_request_detail.dart';
import 'package:hostel_dayout_app/features/requests/domain/usecase/get_status_filter.dart';
import 'package:hostel_dayout_app/features/requests/domain/usecase/update_request_detail.dart';
import 'package:hostel_dayout_app/features/requests/domain/usecase/update_requests.dart';
import 'package:hostel_dayout_app/features/requests/presentation/bloc/request_bloc.dart';
import 'package:hostel_dayout_app/features/requests/presentation/bloc/request_detail_bloc.dart';
import 'package:hostel_dayout_app/features/requests/presentation/bloc/runtime_storage.dart';

// Auth
// ...existing code...
import 'package:hostel_dayout_app/features/auth/domain/repository/auth_repository.dart';
import 'package:hostel_dayout_app/features/auth/domain/usecase/login_usecase.dart';
import 'package:hostel_dayout_app/features/auth/domain/usecase/get_saved_session_usecase.dart';
import 'package:hostel_dayout_app/features/auth/domain/usecase/clear_session_usecase.dart';
import 'package:hostel_dayout_app/features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Register SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  // Runtime Storage
  sl.registerLazySingleton<RequestStorage>(() => RequestStorage());

  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  sl.registerLazySingleton<Box<RequestModel>>(
    () => Hive.box<RequestModel>('requests'),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // ---------------- Requests ----------------
  // Data sources
  sl.registerLazySingleton<RequestRemoteDataSource>(
    () => RequestRemoteDataSourceImpl(client: sl()),
  );

  // Repository
  sl.registerLazySingleton<RequestRepository>(
    () => RequestRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetRequests(sl()));
  sl.registerLazySingleton(() => GetRequestDetail(sl()));
  sl.registerLazySingleton(() => GetPriorityRequests(sl()));
  sl.registerLazySingleton(() => GetFilterRequest(sl()));
  sl.registerLazySingleton(() => UpdateRequest(sl()));
  sl.registerLazySingleton(() => UpdateRequestDetail(sl()));

  // Bloc
  sl.registerFactory(
    () => RequestListBloc(
      getAllRequests: sl(),
      getRequestDetail: sl(),
      getPriorityRequests: sl(),
      getFilterRequest: sl(),
      updateRequests: sl(),
    ),
  );

  sl.registerFactory<RequestDetailBloc>(
    () => RequestDetailBloc(getRequestDetail: sl(), updateRequestDetail: sl()),
  );

  // ---------------- Auth ----------------
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remote: sl(), local: sl(), networkInfo: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => GetSavedSessionUseCase(sl()));
  sl.registerLazySingleton(() => ClearSessionUseCase(sl()));

  // Bloc
  sl.registerFactory(
    () => LoginBloc(
      loginUseCase: sl(),
      getSavedSessionUseCase: sl(),
      clearSessionUseCase: sl(),
    ),
  );
}
