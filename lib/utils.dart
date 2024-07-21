// ignore: non_constant_identifier_names
// ignore_for_file: unused_element
// ignore: non_constant_identifier_names
import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';

String BASE_IP = "http://10.0.2.2";
String BASE_PORT = ":5000";
String BASE_URL = "$BASE_IP$BASE_PORT";
String WHATSAPP_URL = "https://wa.me/51999999999";

String getFormatMoneyString(double num) {
  String numero = num.toString();
  List<String> partes = numero.split('.');

  String parteEntera = partes[0];
  String parteDecimal = partes[1];

  String parteEnteraFormateada = '';
  int contador = 0;

  bool esNegativo = parteEntera.startsWith('-');
  if (esNegativo) {
    parteEntera = parteEntera.substring(1);
  }

  for (int i = parteEntera.length - 1; i >= 0; i--) {
    parteEnteraFormateada = parteEntera[i] + parteEnteraFormateada;
    contador++;
    if (contador == 3 && i != 0) {
      parteEnteraFormateada = ',' + parteEnteraFormateada;
      contador = 0;
    }
  }

  if (esNegativo) {
    parteEnteraFormateada = '-' + parteEnteraFormateada;
  }

  String numeroFormateado = '\$$parteEnteraFormateada.$parteDecimal';
  return numeroFormateado;
}

String formatDate(String dateStr) {
  final DateFormat inputFormat = DateFormat('EEE, dd MMM yyyy HH:mm:ss z');

  final DateTime dateTime = inputFormat.parse(dateStr);

  final DateFormat outputFormat = DateFormat('dd MMM yyyy ');

  return outputFormat.format(dateTime);
}
