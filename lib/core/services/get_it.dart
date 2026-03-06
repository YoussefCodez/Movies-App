import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'get_it.config.dart';

// getIt هو الكائن المسؤول عن إدارة وحفظ النسخ (Dependencies) في المشروع
final GetIt getIt = GetIt.instance;

// @InjectableInit بتخلي الـ Injectable Generator يعمل ملف الـ config اللي فيه تسجيل كل الـ dependencies
@InjectableInit(
  initializerName: 'init', // اسم الدالة اللي هتعمل initialize
  preferRelativeImports:
      true, // بيفضل استخدام الـ relative imports في الملف اللي هيتولد
  asExtension: true, // بيخلي الدالة تكون extension على GetIt
)
void configureDependencies() => getIt.init();
