import 'package:dio/dio.dart';
import 'dart:developer' as developer;

class BitacoraInterceptor extends Interceptor {
  BitacoraInterceptor({void Function(String linea)? escribir})
    : _escribir = escribir ?? _alLog;

  final void Function(String linea) _escribir;

  static const _llaveCronometro = 'bitacora.cronometro';

  static void _alLog(String linea) => developer.log(linea, name: 'http');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_llaveCronometro] = Stopwatch()..start();
    _escribir('→ ${options.method} ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final o = response.requestOptions;
    _escribir('← ${response.statusCode} ${o.method} ${o.path} (${_ms(o)} ms)');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final o = err.requestOptions;
    final codigo = err.response?.statusCode;
    _escribir(
      '✗ ${err.type.name}${codigo == null ? '' : ' $codigo'} '
      '${o.method} ${o.path} (${_ms(o)} ms)',
    );
    handler.next(err);
  }

  int _ms(RequestOptions o) =>
      (o.extra[_llaveCronometro] as Stopwatch?)?.elapsedMilliseconds ?? 0;
}
