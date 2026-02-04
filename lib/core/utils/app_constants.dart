class AppConstants {
  static const String appName = 'News App';
  // API keys تُمرر عبر dart-define أثناء التشغيل/البناء
  static const String apiKey =
      String.fromEnvironment('NEWS_API_KEY', defaultValue: '');
  static const String gnewsApiKey =
      String.fromEnvironment('GNEWS_KEY', defaultValue: '');

  // NewsAPI baseUrl (newsapi.org) يُمرر عبر dart-define
  static const String baseUrl = String.fromEnvironment(
    'NEWS_API_BASE_URL',
    defaultValue: 'https://newsapi.org',
  );

  static const String topHeadlines = '/v2/top-headlines';
  static const String everything = '/v2/everything';
  static const String gnewsBaseUrl = 'https://gnews.io/api/v4';

  //Local Database
  static const String localDatabaseBoxName = 'news_app_box';
  static const String isDarkMode = 'isDarkMode';
  static const String language = 'language';
  static const String hasSeenOnboarding = 'hasSeenOnboarding';

  //Local Database by Shared Preferences
  static const String bookmarksKey = 'bookmarks';


  
}
