enum Flavor {
  dev,
  prod,
}

class Flavors {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Shopping dev';
      case Flavor.prod:
        return 'Shopping prod';
      default:
        return 'title';
    }
  }

}
