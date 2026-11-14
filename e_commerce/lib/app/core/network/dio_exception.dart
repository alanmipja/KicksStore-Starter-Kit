import 'package:dio/dio.dart';

class NetworkFailure implements Exception {
  final int code;
  final String message;

  const NetworkFailure({required this.code, required this.message});

  @override
  String toString() => message;
}

class ErrorHandler {
  static NetworkFailure handle(Object error) {
    if (error is DioException) {
      return _handleDioError(error);
    }

    return NetworkFailure(
      code: -8,
      message: 'Terjadi kesalahan sistem: $error',
    );
  }

  static NetworkFailure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(
          code: -1,
          message:
              'Waktu koneksi habis (Timeout). Periksa koneksi internet Anda.',
        );
      case DioExceptionType.transformTimeout:
        return const NetworkFailure(
          code: -8,
          message:
              'Respons server membutuhkan waktu terlalu lama untuk diproses.',
        );
      case DioExceptionType.cancel:
        return const NetworkFailure(
          code: -2,
          message: 'Permintaan data dibatalkan.',
        );
      case DioExceptionType.connectionError:
        return const NetworkFailure(
          code: -6,
          message:
              'Gagal terhubung ke server. Pastikan perangkat terhubung ke internet.',
        );
      case DioExceptionType.badResponse:
        return _handleBadResponse(error);
      case DioExceptionType.badCertificate:
        return const NetworkFailure(
          code: -7,
          message: 'Sertifikat keamanan server tidak dapat diverifikasi.',
        );
      case DioExceptionType.unknown:
        return NetworkFailure(
          code: -8,
          message:
              'Gangguan koneksi: ${error.message ?? 'Terjadi kesalahan tidak diketahui'}',
        );
    }
  }

  static NetworkFailure _handleBadResponse(DioException error) {
    final code = error.response?.statusCode ?? 500;
    final responseMessage = _extractErrorMessage(error.response?.data);

    return NetworkFailure(
      code: code,
      message: responseMessage ?? _getFallbackMessage(code),
    );
  }

  static String _getFallbackMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Permintaan data tidak valid (Bad Request).';
      case 401:
        return 'Sesi akses tidak sah atau token kadaluarsa (Unauthorized).';
      case 403:
        return 'Akses ke data ini dilarang (Forbidden).';
      case 404:
        return 'Data produk tidak ditemukan di server (404 Not Found).';
      case 422:
        return 'Data yang dikirimkan tidak sesuai format validasi.';
      default:
        return 'Terjadi kendala pada server internal ($statusCode).';
    }
  }

  static String? _extractErrorMessage(Object? data) {
    if (data is String && data.isNotEmpty) return data;
    if (data is Map) {
      final message = data['message']?.toString();
      if (message != null && message.isNotEmpty) return message;
    }
    return null;
  }
}
