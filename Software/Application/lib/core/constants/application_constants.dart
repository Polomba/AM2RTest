class ApplicationRequestPaths {
  static const _dbUrl = "https://api.am2r-s2w.ss-centi.com";
  static const _nominatimApiUrl = 'https://nominatim.openstreetmap.org';

  static const usersPath = '$_dbUrl/users';

  static const routesPath = '$_dbUrl/route';
  static const routesSortByDistance = '$routesPath/sortByDistance';
  static const routesSortByOccurrences = '$routesPath/sortByOccurrences';
  static const routesSortByIQAr = '$routesPath/sortByIQAr';
  static const getFavoriteRoutes = '$routesPath/favoriteRoutes';

  static const modulesPath = '$_dbUrl/module';
  static const modulesByRouteId = '$modulesPath/route';
  static const modulesBetweenBounds = '$modulesPath/modulesFromArea';

  static const fileSystemDownloadFile = '$routesPath/fs/download';
  static const fileSystemUploadFile = '$routesPath/fs/upload';

  static const reverseGeocodeSearch = '$_nominatimApiUrl/reverse';
}

class ApplicationConstants {
  static const favoriteRoutesKey = 'favoriteRoutes';
}
