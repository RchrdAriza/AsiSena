class ApiConstants {
  ApiConstants._();

  // En Android, localhost apunta al dispositivo, no a tu PC
  // Usa tu IP local (10.9.223.74) para conectar desde Android
  static const String ollamaBaseUrl = 'http://10.9.223.74:11434';
  static const String ollamaChatEndpoint = '/api/chat';
  static const String ollamaModel = 'gemma3:4b';

  // Placeholder para futuro backend
  static const String apiBaseUrl = 'http://10.9.223.74:8080/api';
}
