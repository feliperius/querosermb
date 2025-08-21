class ApiUrls {

  static const String apiKey = "c53f2326-6bd1-4e24-9624-1d829beee731";
  static const String apiKeyTest = "b54bcf4d-1bca-4e8e-9a24-22ff2c3d462c";
  static const String baseUrl = 'https://pro-api.coinmarketcap.com/v1';
  
  // Exchange endpoints
  static const String exchangeInfo = '$baseUrl/exchange/info';
  static const String exchangeMap = '$baseUrl/exchange/map';
  static String getExchangeInfoById(int id) => '$exchangeInfo?id=$id';

}
