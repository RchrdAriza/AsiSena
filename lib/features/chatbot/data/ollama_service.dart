import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/dio_client.dart';

class OllamaService {
  final DioClient _dioClient;

  OllamaService(this._dioClient);

  Future<String> sendMessage(String message, List<Map<String, String>> history) async {
    try {
      final messages = [
        {
          'role': 'system',
          'content': 'Eres un asistente educativo del SENA (Servicio Nacional de Aprendizaje) en Colombia. '
              'Ayudas a aprendices, instructores y administrativos con consultas sobre formación, '
              'trámites, bienestar y procesos académicos. Responde en español de forma clara y amable.',
        },
        ...history,
        {'role': 'user', 'content': message},
      ];

      final response = await _dioClient.ollama.post(
        ApiConstants.ollamaChatEndpoint,
        data: {
          'model': ApiConstants.ollamaModel,
          'messages': messages,
          'stream': false,
        },
      );

      if (response.statusCode == 200) {
        return response.data['message']['content'] as String;
      }
      return 'Error: No se pudo obtener respuesta del asistente.';
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout) {
        return 'No se pudo conectar con el asistente IA. Verifica que Ollama esté ejecutándose en ${ApiConstants.ollamaBaseUrl}';
      }
      if (e.response?.statusCode == 404) {
        return 'Modelo "${ApiConstants.ollamaModel}" no encontrado. Ejecuta: ollama pull ${ApiConstants.ollamaModel}';
      }
      return 'Error de conexión: ${e.message}';
    } catch (e) {
      return 'Error inesperado: $e';
    }
  }

  /// Validates if an image is a legitimate medical document using vision capabilities.
  /// Returns a [MedicalImageValidation] with the result.
  Future<MedicalImageValidation> validateMedicalImage(Uint8List imageBytes) async {
    try {
      final base64Image = base64Encode(imageBytes);

      final messages = [
        {
          'role': 'system',
          'content': 'Eres un sistema de verificación documental del SENA. '
              'Tu única tarea es determinar si una imagen corresponde a un documento médico válido '
              '(certificado médico, incapacidad, orden médica, fórmula médica, resultado de examen, '
              'excusa médica, constancia de cita médica, etc.). '
              'Responde ÚNICAMENTE en el siguiente formato:\n'
              'VALIDO: [true o false]\n'
              'TIPO: [tipo de documento detectado]\n'
              'RAZON: [explicación breve]\n\n'
              'Si la imagen NO es un documento médico (selfies, memes, fotos personales, '
              'capturas de pantalla no médicas, documentos no relacionados con salud, etc.), '
              'marca VALIDO como false.',
        },
        {
          'role': 'user',
          'content': 'Analiza esta imagen y determina si es un documento médico válido como soporte de excusa.',
          'images': [base64Image],
        },
      ];

      final response = await _dioClient.ollama.post(
        ApiConstants.ollamaChatEndpoint,
        data: {
          'model': ApiConstants.ollamaModel,
          'messages': messages,
          'stream': false,
        },
      );

      if (response.statusCode == 200) {
        final content = response.data['message']['content'] as String;
        return MedicalImageValidation.parse(content);
      }
      return MedicalImageValidation(
        isValid: false,
        documentType: 'Desconocido',
        reason: 'No se pudo analizar la imagen.',
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout) {
        return MedicalImageValidation(
          isValid: false,
          documentType: 'Error',
          reason: 'No se pudo conectar con el asistente IA para validar la imagen.',
          isError: true,
        );
      }
      return MedicalImageValidation(
        isValid: false,
        documentType: 'Error',
        reason: 'Error al validar: ${e.message}',
        isError: true,
      );
    } catch (e) {
      return MedicalImageValidation(
        isValid: false,
        documentType: 'Error',
        reason: 'Error inesperado: $e',
        isError: true,
      );
    }
  }
}

class MedicalImageValidation {
  final bool isValid;
  final String documentType;
  final String reason;
  final bool isError;

  const MedicalImageValidation({
    required this.isValid,
    required this.documentType,
    required this.reason,
    this.isError = false,
  });

  factory MedicalImageValidation.parse(String response) {
    final lower = response.toLowerCase();
    final isValid = lower.contains('valido: true') || lower.contains('válido: true');

    String documentType = 'No identificado';
    final tipoMatch = RegExp(r'tipo:\s*(.+)', caseSensitive: false).firstMatch(response);
    if (tipoMatch != null) {
      documentType = tipoMatch.group(1)!.trim();
    }

    String reason = response;
    final razonMatch = RegExp(r'razon:\s*(.+)', caseSensitive: false).firstMatch(response);
    final razonMatch2 = RegExp(r'razón:\s*(.+)', caseSensitive: false).firstMatch(response);
    if (razonMatch != null) {
      reason = razonMatch.group(1)!.trim();
    } else if (razonMatch2 != null) {
      reason = razonMatch2.group(1)!.trim();
    }

    return MedicalImageValidation(
      isValid: isValid,
      documentType: documentType,
      reason: reason,
    );
  }
}
