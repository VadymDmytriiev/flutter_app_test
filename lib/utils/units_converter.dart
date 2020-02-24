class UnitsContverter {
  static double convertKelvinToCelsius(double temperature) {
    if (temperature != null)
      return temperature - 273.15;
    else
      return null;
  }
}