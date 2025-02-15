// for this project we are using just two environment
// normally there would be one more environment for staging
enum FlavorType {
  dev,
  prod,
}

class Flavors {
  static FlavorType? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case FlavorType.dev:
        return 'Shopping dev';
      case FlavorType.prod:
        return 'Shopping prod';
      default:
        return 'title';
    }
  }

}
