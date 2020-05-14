import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';

  Map<String, String> coinValues = {};
  bool isLoading = false;

  void getData() async {
    isLoading = true;

    try {
      var data = await CoinData().getData(selectedCurrency);

      isLoading = false;

      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Column getCryptoCoinCard() {
    var cryptoCards = cryptoList.map<CryptoCard>((crypto) {
      return CryptoCard(
        crypto: crypto,
        currency: selectedCurrency,
        rate: isLoading ? '?' : coinValues[crypto],
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  DropdownButton<String> androidDropdown() {
    var dropdownItems =
        currenciesList.map<DropdownMenuItem<String>>((String currency) {
      return DropdownMenuItem<String>(
        child: Text(currency),
        value: currency,
      );
    }).toList();

    return DropdownButton<String>(
        value: selectedCurrency,
        items: dropdownItems,
        onChanged: (value) {
          setState(() {
            selectedCurrency = value;
          });

          getData();
        });
  }

  CupertinoPicker iosPicker() {
    var itemsPicker = currenciesList.map<Text>((String currency) {
      return Text(
        currency,
        style: TextStyle(color: Colors.white),
      );
    }).toList();

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = currenciesList[selectedIndex];
        getData();
      },
      children: itemsPicker,
    );
  }

  getPicker() {
    if (Platform.isIOS) {
      return androidDropdown();
    } else if (Platform.isAndroid) {
      return androidDropdown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          getCryptoCoinCard(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  final String crypto, currency, rate;

  CryptoCard({this.crypto, this.currency, this.rate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto = $rate $currency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
