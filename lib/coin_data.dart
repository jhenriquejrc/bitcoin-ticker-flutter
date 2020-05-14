import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = 'B1488146-7672-4E79-B1A3-6190C8700B66';
const apiURL = 'https://rest.coinapi.io/v1/';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future<Map<String, String>> getData(String selectedCurrency) async {
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      http.Response response = await http.get(
          '${apiURL}exchangerate/$crypto/$selectedCurrency?apikey=$apiKey');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        double price = (data['rate']);
        cryptoPrices[crypto] = price.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }
}
