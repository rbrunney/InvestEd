import 'dart:convert';

import 'package:invested/util/requests/basic_request.dart';

class Stock {

  // Basic Description
  late String ticker;
  late String companyName;
  String? description;

  // Financial Information
  late double currentPrice;
  late double open;
  late double high;
  late double low;
  double? dividend;
  late double previousClose;

  // Trade Information
  double? volume;
  double? marketCap;

  Stock({
    required this.ticker,
    this.companyName = '',
    this.description,
    this.currentPrice = 0,
    this.open = 0,
    this.high = 0,
    this.low = 100000,
    this.dividend,
    this.previousClose = 0,
    this.volume,
    this.marketCap
  });

  Future<void> getCurrentPrice() async {
    await BasicRequest.makeGetRequest("http://10.0.2.2:105/invested_stock/$ticker/price")
        .then((value) {
       var response = json.decode(value);
       currentPrice = response['results']['current_price'].toDouble();
    });
  }

  Future<void> getBasicInfo() async {
    await BasicRequest.makeGetRequest("http://10.0.2.2:105/invested_stock/$ticker/basic_info")
        .then((value) {
        var response = json.decode(value);

        companyName = response['results']['name'];
        description = response['results']['description'];
        open = response['results']['open'] + 0.0;
        high = response['results']['high'] + 0.0;
        low = response['results']['low'] + 0.0;
        volume = response['results']['volume'] + 0.0;
        marketCap = response['results']['market_cap'] + 0.0;
        dividend = response['results']['last_dividend'] + 0.0;
        previousClose = response['results']['previous_close'] + 0.0;
    });
  }

  Future<List<double>> getPricePoints(String period) async {
    List<double> pricePoints = [];
    await BasicRequest.makeGetRequest("http://10.0.2.2:105/invested_stock/$ticker/$period")
        .then((value) {
        var response = json.decode(value);

        for (var price in response['results']['period_info']) {
          try {
            pricePoints.add(price.toDouble());
          } catch(exception) {
            pricePoints.add(price + 0.0);
          }
        }
    });

    return pricePoints;
  }
}