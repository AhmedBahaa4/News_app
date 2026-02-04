// ignore_for_file: unused_import

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/features/onboarding/pages/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app/core/models/bookmark_article.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/core/network/api_client.dart';
import 'package:news_app/core/network/news_api_client.dart';
import 'package:news_app/core/offline_mode/cubit/offline_cubit.dart';
import 'package:news_app/core/services/bookmark_api_service.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'package:news_app/core/utils/route/app_router.dart';
import 'package:news_app/core/utils/theme/app_theme.dart';
import 'package:news_app/core/utils/theme/cubit/them_cubit.dart';
import 'package:news_app/features/auth/cubit/auth_cubit.dart';
import 'package:news_app/features/auth/cubit/password_cubit.dart';
import 'package:news_app/features/home/cubit/bookmark/bookmark_cubit.dart';
import 'package:news_app/features/world/domain/usecases/get_world_news.dart';
import 'package:news_app/features/world/presentation/cubit/world_cubit.dart';
import 'package:news_app/features/world/presentation/cubit/world_cubit.dart'
    as cubit;
import 'core/services/user_service.dart';
import 'features/auth/views/page/login_page.dart';
import 'features/main_navigation/presentation/pages/main_navigation_page.dart';
import 'firebase_options.dart';


import 'package:news_app/features/world/data/datasources/world_remote_datasource.dart'
    as datasource;
// import 'package:news_app/features/world/data/repositories/world_repository.dart'
//     as repo;
import 'package:news_app/features/world/data/repositories/world_repository_impl.dart'
    as repo;


// import 'package:provider/provider.dart';

import 'core/services/theme_preferences.dart';

final themePreferences = ThemePreferences();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // اختر الـ baseUrl حسب المنصة (المحاكي أندرويد vs الويب)
  const definedBackendUrl =
      String.fromEnvironment('BACKEND_BASE_URL', defaultValue: '');
  final baseUrl = definedBackendUrl.isNotEmpty
      ? definedBackendUrl
      : (kIsWeb ? 'http://localhost:5000/api' : 'http://10.0.2.2:5000/api');
  final dio = Dio(BaseOptions(baseUrl: baseUrl));

  await Hive.initFlutter();
  Hive.registerAdapter(ArticleAdapter());
  Hive.registerAdapter(SourceAdapter());
  Hive.registerAdapter(NewsApiResponseAdapter());
  Hive.registerAdapter(BookmarkArticleAdapter());
  await Hive.openBox<BookmarkArticle>('bookmarksBox');

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => BookmarkApiService(dio)),
        RepositoryProvider(create: (_) => UserService(dio)),
      ],
      child: const MyApp(),
    ),
  );
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   final dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:5000/api'));

//   await Hive.initFlutter();
//   Hive.registerAdapter(ArticleAdapter());
//   Hive.registerAdapter(SourceAdapter());
//   Hive.registerAdapter(NewsApiResponseAdapter());
//   Hive.registerAdapter(BookmarkArticleAdapter());
//   await Hive.openBox<BookmarkArticle>('bookmarksBox');

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<AuthCubit>(create: (_) => AuthCubit()..checkAuth()),
//         BlocProvider<PasswordCubit>(create: (_) => PasswordCubit()),
//         BlocProvider<BookmarkCubit>(
//           create: (context) => BookmarkCubit(
//             Provider.of<BookmarkApiService>(context, listen: false),
//           ),
//         ),
//         BlocProvider(
//           create: (context) => WorldCubit(
//             GetWorldNews(
//               WorldRepositoryImpl(WorldRemoteDataSourceImpl(ApiClient())),
//             ),
//           )..fetchWorldNews(),
//         ),
//         BlocProvider(create: (_) => NetworkCubit()),
//         BlocProvider(create: (_) => ThemeCubit(themePreferences)),
//       ],

//       // ✅ LISTENER هنا
//       child: BlocListener<AuthCubit, AuthState>(
//         listener: (context, state) {
//           final bookmarkCubit = context.read<BookmarkCubit>();

//           if (state is AuthDone) {
//             bookmarkCubit.fetchBookmarks(); // مرة واحدة فقط
//           }

//           if (state is AuthLoggedOut) {
//             bookmarkCubit.reset();
//           }
//         },

//         // 👇 UI زي ما هو
//         child: BlocBuilder<AuthCubit, AuthState>(
//           builder: (context, state) {
//             if (state is AuthInitial || state is AuthLoading) {
//               return const MaterialApp(
//                 home: Scaffold(
//                   body: Center(child: CircularProgressIndicator()),
//                 ),
//               );
//             }

//             return BlocBuilder<ThemeCubit, bool>(
//               builder: (context, isDark) {
//                 return MaterialApp(
//                   title: AppConstants.appName,
//                   debugShowCheckedModeBanner: false,
//                   theme: isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
//                   home: state is AuthDone
//                       ? const MainNavigationPage()
//                       : const LoginPage(),
//                   // home: const MainNavigationPage(),
//                   onGenerateRoute: AppRouter.onGenerateRoute,
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
class MyApp extends StatelessWidget {
 

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final  NewsApiClient api;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(
            context.read<UserService>()
        )..checkAuth()),
        BlocProvider(create: (_) => PasswordCubit()),
        BlocProvider(
          create: (_) => BookmarkCubit(context.read<BookmarkApiService>()),
        ),
    BlocProvider(
  create: (_) => cubit.WorldCubit(
    GetWorldNews(
      repo.WorldRepositoryImpl(
        datasource.WorldRemoteDataSourceImpl(),
      ),
    ),
  )..fetchWorldNews(),
),



        BlocProvider(create: (_) => NetworkCubit()),
        BlocProvider(create: (_) => ThemeCubit(ThemePreferences())),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          final bookmarkCubit = context.read<BookmarkCubit>();

          if (state is AuthDone) {
            bookmarkCubit.fetchBookmarks(); // مرة واحدة فقط
          }

          if (state is AuthLoggedOut) {
            bookmarkCubit.reset();
          }
        },
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late Future<bool> _seenFuture;

  @override
  void initState() {
    super.initState();
    _seenFuture = _seenOnboarding();
  }

  Future<bool> _seenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_seen_v2') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ThemeCubit, bool, ThemeMode>(
      selector: (isDark) => isDark ? ThemeMode.dark : ThemeMode.light,
      builder: (context, themeMode) {
        return FutureBuilder<bool>(
          future: _seenFuture,
          builder: (context, snapshot) {
            final seen = snapshot.data ?? false;
            if (!snapshot.hasData) {
              return MaterialApp(
                title: AppConstants.appName,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                home: const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
              );
            }

            return MaterialApp(
              title: AppConstants.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              home: seen ? const AuthGate() : const OnboardingPage(),
              routes: {
                AppRoutes.login: (_) => const LoginPage(),
                AppRoutes.onboarding: (_) => const OnboardingPage(),
              },
              onGenerateRoute: AppRouter.onGenerateRoute,
            );
          },
        );
      },
    );
  }
}

//
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final cachedUser = FirebaseAuth.instance.currentUser;
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial || state is AuthLoading) {
          if (cachedUser != null) {
            return const MainNavigationPage();
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return state is AuthDone
            ? const MainNavigationPage()
            : const LoginPage();
      },
    );
  }
}


