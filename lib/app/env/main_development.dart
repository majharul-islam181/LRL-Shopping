import '../flavors.dart';

import '../../main.dart' as runner;

Future<void> main() async {
  Flavors.appFlavor = Flavor.dev;
  await runner.main();
}
