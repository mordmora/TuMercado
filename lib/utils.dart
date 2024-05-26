String getFormatMoneyString(double num) {
  // Convertir el número a una cadena con dos decimales
  String numero = num.toString();
  List<String> partes = numero.split('.');

  String parteEntera = partes[0];
  String parteDecimal = partes[1];

  // Formatear la parte entera con comas como separadores de miles
  String parteEnteraFormateada = '';
  int contador = 0;

  // Determinar si el número es negativo
  bool esNegativo = parteEntera.startsWith('-');
  if (esNegativo) {
    parteEntera =
        parteEntera.substring(1); // Remover el signo negativo para formatear
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
    parteEnteraFormateada =
        '-' + parteEnteraFormateada; // Agregar el signo negativo de vuelta
  }

  // Construir la cadena final con el símbolo de dólar
  String numeroFormateado = '\$$parteEnteraFormateada.$parteDecimal';
  return numeroFormateado;
}
