import 'package:investor_soop/model/chart_data.dart';

class Collateral {
  late final String address;
  late final int priority;
  late final String state;

  Collateral(this.address, this.priority, this.state);
}

class ProceedProperty {
  late final String companyName;
  late final List<Collateral> collateral;

  late final DateTime executeDate;
  late final DateTime expireDate;
  late final double interestRate;
  late final int amount;
  late final int balance;
  late final String currency;
  late final int? amountByCurrency;
  late final String title;
  late final int regularInterest;
  late final double tax;
  late final String interestPaymentType;
  late final List<Map<String, dynamic>> files;

  ProceedProperty(
      {required this.companyName,
      collateral,
      required this.executeDate,
      required this.expireDate,
      required this.interestRate,
      required this.amount,
      required this.currency,
      required this.balance,
      required this.interestPaymentType,
      this.amountByCurrency,
      required this.title,
      required this.regularInterest,
      required this.files,
      required this.tax});

  ProceedProperty.fromJson(Map<String, dynamic> json) {
    try {
      print(json);
      companyName = json['companyName'];
      collateral = (json['collateral'] ?? []).map<Collateral>((d) {
        return Collateral(d['address'], d['priority'], d['state']);
      }).toList();
      executeDate = DateTime.parse(json['executeDate']).toLocal();
      expireDate = DateTime.parse(json['expireDate']).toLocal();
      interestRate = double.parse(json['interestRate'].toString());
      amount = json['amount'];
      currency = json['currency'];
      amountByCurrency = json['amountByCurrency'];
      regularInterest = json['regularInterest'];
      title = json['title'];
      tax = double.parse(json['tax'].toString());
      balance = json['balance'];
      interestPaymentType = json['interestPaymentType'];
      files = List.from(json['files']);
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyName'] = companyName;
    data['collateral'] = collateral;
    data['executeDate'] = executeDate;
    data['expireDate'] = expireDate;
    data['interestRate'] = interestRate;
    data['amount'] = amount;
    data['currency'] = currency;
    data['amountByCurrency'] = amountByCurrency;
    data['regularInterest'] = regularInterest;
    data['title'] = title;
    data['tax'] = tax;
    data['balance'] = balance;
    data['interestPaymentType'] = interestPaymentType;
    data['files'] = files;
    return data;
  }
}
