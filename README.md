# AsiSENA - Gestor Educativo

Sistema de gestión educativa para el SENA con 3 roles (Administrativo, Instructor, Aprendiz).

## Características

- ✅ **Autenticación** con 3 roles diferenciados
- ✅ **Dashboards personalizados** por rol
- ✅ **Salud Estudiantil** con gráficas de asistencia (fl_chart)
- ✅ **Chatbot IA** integrado con Ollama (gemma3:4b)
- ✅ **Noticias** institucionales
- ✅ **Perfil** editable
- ✅ **Diseño responsive** (Web + Mobile)

## Ejecutar en Web

```bash
# 1. Inicia Ollama
ollama serve

# 2. Asegúrate de tener el modelo
ollama pull gemma3:4b

# 3. Ejecuta la app
flutter run -d chrome
```

**Usuarios de prueba:**
- `admin@sena.edu.co` (cualquier contraseña)
- `instructor@sena.edu.co` (cualquier contraseña)
- `aprendiz@sena.edu.co` (cualquier contraseña)

## Ejecutar en Android

Ver instrucciones detalladas en: **[ANDROID_SETUP.md](ANDROID_SETUP.md)**

**Resumen rápido:**

1. **Detén Ollama** si está corriendo:
   ```bash
   pgrep -f ollama  # encuentra el PID
   kill <PID>
   ```

2. **Inicia Ollama accesible desde la red**:
   ```bash
   ./start_ollama_for_android.sh
   # O manualmente:
   OLLAMA_HOST=0.0.0.0:11434 ollama serve
   ```

3. **Ejecuta en Android**:
   ```bash
   flutter run
   # Selecciona tu dispositivo Android
   ```

## Configuración Ollama

Archivo: `lib/core/constants/api_constants.dart`

```dart
static const String ollamaBaseUrl = 'http://10.9.223.74:11434'; // Tu IP local
static const String ollamaModel = 'gemma3:4b';
```

**⚠️ Importante**: Si tu IP cambia, actualiza `ollamaBaseUrl`.

## Estructura del Proyecto

```
lib/
├── core/
│   ├── constants/      # API URLs, strings UI
│   ├── router/         # GoRouter + guards
│   ├── services/       # DioClient, LocalStorage
│   └── theme/          # Tema material
├── features/
│   ├── auth/           # Login
│   ├── chatbot/        # Chat con Ollama
│   ├── dashboard/      # 3 dashboards por rol
│   ├── news/           # Noticias
│   ├── profile/        # Perfil
│   └── student_health/ # Salud estudiantil
└── shared/
    ├── models/         # UserModel, Role
    ├── providers/      # Providers globales
    └── widgets/        # Widgets reutilizables
```

## Stack Tecnológico

- **Flutter** 3.10+
- **Riverpod** - Estado
- **GoRouter** - Navegación
- **Dio** - HTTP
- **fl_chart** - Gráficas
- **Google Fonts** - Tipografía
- **Ollama** - IA local

