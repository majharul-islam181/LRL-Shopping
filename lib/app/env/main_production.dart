import '../flavors.dart';

import '../../main.dart' as runner;

Future<void> main() async {
  Flavors.appFlavor = FlavorType.prod;
  await runner.main();
}
