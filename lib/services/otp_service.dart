import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class OtpService {
  static const String otpApiBaseUrl = 'https://2factor.in/API/V1';

  static const String otpApiKey = '';
  static const String otpSecretKey = '';

  static const String statusFieldName = 'Status';
  static const String detailsFieldName = 'Details';
  static const String statusSuccessValue = 'Success';
  static const String statusFailureValue = 'Error';

  static Future<Either<String, String>> generateParentOtp({
    required String phoneNo,
    required String enrollmentNo,
  }) async {
    try {
      if (enrollmentNo.trim().isEmpty) {
        return left('Enrollment number is required.');
      }
      if (phoneNo.trim().length < 10) {
        return left('Enter a valid phone number.');
      }

      final uri = Uri.parse(
        '$otpApiBaseUrl/$otpApiKey/SMS/$phoneNo/AUTOGEN/$otpSecretKey',
      );
      final headers = {
        'Accept': 'application/json',
        'X-OTP-API-KEY': otpApiKey,
        'X-OTP-SECRET-KEY': otpSecretKey,
      };

      print('[OtpService] REQUEST generateParentOtp');
      print('[OtpService] METHOD: GET');
      print('[OtpService] URL: $uri');
      print('[OtpService] HEADERS: $headers');

      final response = await http.get(uri, headers: headers);

      print('[OtpService] RESPONSE generateParentOtp');
      print('[OtpService] STATUS_CODE: ${response.statusCode}');
      print('[OtpService] BODY: ${response.body}');

      return _parseGenerateResponse(response, fallbackRequestId: phoneNo);
    } on SocketException {
      return left('No internet connection. Please check your network.');
    } catch (_) {
      return left('Failed to send OTP. Please try again.');
    }
  }

  static Future<Either<String, bool>> verifyParentOtp({
    required String phoneNo,
    required String otp,
  }) async {
    try {
      if (phoneNo.trim().isEmpty) {
        return left('Phone number is required for OTP verification.');
      }
      if (otp.trim().isEmpty) {
        return left('Please enter OTP.');
      }

      final uri = Uri.parse(
        '$otpApiBaseUrl/$otpApiKey/SMS/VERIFY3/$phoneNo/$otp',
      );
      final headers = {
        'Accept': 'application/json',
        'X-OTP-API-KEY': otpApiKey,
        'X-OTP-SECRET-KEY': otpSecretKey,
      };

      print('[OtpService] REQUEST verifyParentOtp');
      print('[OtpService] METHOD: GET');
      print('[OtpService] URL: $uri');
      print('[OtpService] HEADERS: $headers');

      final response = await http.get(uri, headers: headers);

      print('[OtpService] RESPONSE verifyParentOtp');
      print('[OtpService] STATUS_CODE: ${response.statusCode}');
      print('[OtpService] BODY: ${response.body}');

      return _parseVerifyResponse(response);
    } on SocketException {
      return left('No internet connection. Please check your network.');
    } catch (_) {
      return left('Failed to verify OTP. Please try again.');
    }
  }

  static Either<String, String> _parseGenerateResponse(
    http.Response response, {
    required String fallbackRequestId,
  }) {
    final bodyMap = _decodeBody(response.body);
    final status = (bodyMap[statusFieldName] ?? '').toString();
    final details = (bodyMap[detailsFieldName] ?? '').toString();

    if (status == statusSuccessValue) {
      return right(details.isNotEmpty ? details : fallbackRequestId);
    }

    if (status == statusFailureValue) {
      return left(details.isNotEmpty ? details : 'OTP generation failed.');
    }

    return left(
      details.isNotEmpty ? details : 'Failed to send OTP. Please try again.',
    );
  }

  static Either<String, bool> _parseVerifyResponse(http.Response response) {
    final bodyMap = _decodeBody(response.body);
    final status = (bodyMap[statusFieldName] ?? '').toString();
    final details = (bodyMap[detailsFieldName] ?? '').toString();

    if (status == statusSuccessValue) {
      return right(true);
    }

    if (status == statusFailureValue) {
      return left(details.isNotEmpty ? details : 'OTP verification failed.');
    }

    return left(
      details.isNotEmpty ? details : 'Failed to verify OTP. Please try again.',
    );
  }

  static Map<String, dynamic> _decodeBody(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{};
    }
  }
}
