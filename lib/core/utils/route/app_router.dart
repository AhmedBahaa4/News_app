import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/features/auth/views/page/login_page.dart';
import 'package:news_app/features/auth/views/page/register_page.dart';
import 'package:news_app/features/bookmarks/pages/bookmark_page.dart';
import 'package:news_app/features/home/views/pages/articles_details_page.dart';
import 'package:news_app/features/main_navigation/presentation/pages/main_navigation_page.dart';
import 'package:news_app/features/onboarding/pages/onboarding_page.dart';
import 'package:news_app/features/profile/page/profile_page.dart';
import 'package:news_app/features/search/cubit/search_cubit.dart';
import 'package:news_app/features/search/views/pages/search_page.dart';
import 'package:news_app/features/world/presentation/pages/world_page.dart';
import 'package:news_app/features/daily_brief/pages/daily_brief_page.dart';
import 'package:news_app/features/settings/pages/settings_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const MainNavigationPage (),
          settings: settings,
        );
            case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) => const RegisterPage(),
          settings: settings,
        );
               case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );

        case AppRoutes.articleDetails:
        final article = settings.arguments as Article?;
        if (article == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(
                child: Text('Article data not found'),
              ),
            ),
            settings: settings,
          );
        }

        return MaterialPageRoute(
          builder: (_) => ArticlesDetailsPage(articles: article),
          settings: settings,
        );

      // صفحة البحث
      case AppRoutes.search:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => SearchCubit(),
            child: const SearchPage(),
          ),
        );
      case AppRoutes.dailyBrief:
        return MaterialPageRoute(
          builder: (_) => const DailyBriefPage(),
          settings: settings,
        );
      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsPage(),
          settings: settings,
        );
        // إضافة حالات توجيه أخرى هنا حسب الحاجة
     case AppRoutes.bookmarks:
        return MaterialPageRoute(
          builder: (_) => const BookmarksPage (),
          settings: settings,
        );
      case AppRoutes.onboarding:
  return MaterialPageRoute(builder: (_) => const OnboardingPage());

//        case AppRoutes.mainNavigation:
   case AppRoutes.worldNews:
        return MaterialPageRoute(
          builder: (_) => const WorldPage (),
          settings: settings,
        );
         case AppRoutes.profile:
           return MaterialPageRoute(
          builder: (_) => const ProfilePage (),
          settings: settings,
        );
        

        // إضافة حالات توجيه أخرى هنا حسب الحاجة
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for this path ${settings.name}'),
            ),
          ),
          settings: settings,
        );
    }
  }
}
