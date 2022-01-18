import 'package:bitcoin_ticker_flutter/coin_data.dart';
import 'package:bitcoin_ticker_flutter/services/networking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

const apiKey = '15EDB441-CCDF-4299-877C-16934761543E';
const coinURL = 'https://rest.coinapi.io/v1/exchangerate/';


class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String selectedCurrency = 'USD';
  int rateBTC = 0;
  int rateETH = 0;
  int rateLTC = 0;
  bool isWaiting = false;

  @override
  void initState() {
    super.initState();
    getInitialValue();
  }

  void getInitialValue () async{
    isWaiting = true;
    var currencyData1 = await getExchangeRate('BTC',selectedCurrency);
    var currencyData2 = await getExchangeRate('ETH',selectedCurrency);
    var currencyData3 = await getExchangeRate('LTC',selectedCurrency);
    isWaiting = false;
    updateUI(currencyData1,currencyData2,currencyData3);
  }

  Future<dynamic> getExchangeRate(String coin, String currency) async{
    var url = '$coinURL$coin/$currency?apikey=$apiKey';
    NetworkHelper network = new NetworkHelper(url);
    var currencyData = await network.getData();

    return currencyData;
  }

  void updateUI(dynamic currencyData,dynamic currencyData2,dynamic currencyData3){
    setState(() {
      if(currencyData == null || currencyData == null || currencyData == null){
        return;
      }
      double temp = currencyData['rate'];
      rateBTC = temp.toInt();
      double temp2 = currencyData2['rate'];
      rateETH = temp2.toInt();
      double temp3 = currencyData3['rate'];
      rateLTC = temp3.toInt();

    });
  }

  DropdownButton androidDropdown(){
    List<DropdownMenuItem<String>> currencies = [];
    for(int i = 0; i < currenciesList.length;i++){
      String cur = currenciesList[i];
      currencies.add(DropdownMenuItem(
        child:Text(cur),
        value: cur,
      ),);
    }
    return DropdownButton(
      value: selectedCurrency,
      items: currencies,
      onChanged: (value) async{
        setState((){
          selectedCurrency = value.toString();
        });
        isWaiting = true;
        var currencyData1 = await getExchangeRate('BTC',selectedCurrency);
        var currencyData2 = await getExchangeRate('ETH',selectedCurrency);
        var currencyData3 = await getExchangeRate('LTC',selectedCurrency);
        isWaiting = false;
        updateUI(currencyData1,currencyData2,currencyData3);

      },);
  }

  CupertinoPicker iOSpicker(){

    List<Widget> currencies = [];
    for(int i = 0; i < currenciesList.length;i++){
      String cur = currenciesList[i];
      currencies.add(Text(cur));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex){
        setState(() {

        });
      },
      children: currencies,
    );
  }

  Widget getPicker(){
    if(Platform.isIOS){
      return iOSpicker();
    }else{
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
          Padding(
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
                  '1 BTC = ${isWaiting ? '?' : '$rateBTC'} $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
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
                  '1 ETH = ${isWaiting ? '?' : '$rateETH'} $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
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
                  '1 LTC = ${isWaiting ? '?' : '$rateLTC'} $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker()
          ),
        ],
      ),
    );
  }
}

