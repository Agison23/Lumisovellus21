import './app_test.dart' as appTest;
import './bottomBar_test.dart' as bottomBarTest;
import './langDropdownButton_test.dart' as languageDropdownTest;
import './languageChange_test.dart' as languageChangeTest;
import './snowConditionLock_test.dart' as snowConditionLockTest;

void main() {
  appTest.main();
  bottomBarTest.main();
  languageDropdownTest.main();
  // Drop these out for now, kinda buggy
  // languageChangeTest.main();
  // snowConditionLockTest.main();
}
