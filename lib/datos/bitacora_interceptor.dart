import 'package:dio/dio.dart';

class BitacoraInterceptor extends Interceptor {
  BitacoraInterceptor({void Function(String linea)? escribir});
}
