class EnvironmentConfig {
  String? apiBaseUrl;
  final String env;

  EnvironmentConfig({
    this.apiBaseUrl,
    required this.env,
  });

  static const String envDev = 'dev';
  static const String envProd = 'prod';

  static late EnvironmentConfig _config;
  static final EnvironmentConfig _dev = EnvironmentConfig(
    apiBaseUrl: 'https://fakestoreapi.com/',
    env: envDev,
  );

  static final EnvironmentConfig _prod = EnvironmentConfig(
    apiBaseUrl: 'https://fakestoreapi.com/',
    env: envProd,
  );

  static EnvironmentConfig get config {
    return _config;
  }

  static void initConfig(String env, {String? baseUrl = ""}) {
    switch (env) {
      case envDev:
        _dev.apiBaseUrl = baseUrl!.isEmpty ? _dev.apiBaseUrl : baseUrl;
        _config = _dev;
        break;
      case envProd:
        _prod.apiBaseUrl = baseUrl!.isEmpty ? _prod.apiBaseUrl : baseUrl;
        _config = _prod;
        break;
      default:
    }
  }
}
