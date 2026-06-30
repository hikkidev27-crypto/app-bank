# App Bank - Control de Gastos Personales 🚀

Aplicación móvil desarrollada con **Flutter** y **Firebase** para la gestión inteligente de finanzas personales.

## 📋 Características actuales

### 1. Gestión Financiera Integral
- **Registro de Transacciones**: Formulario detallado para registrar ahorros, gastos e inversiones con categorías, selección de moneda (PEN/USD), fecha y descripción.
- **Sincronización en Tiempo Real**: Los saldos totales y el historial de actividad se actualizan instantáneamente gracias a Cloud Firestore.
- **Actividad Reciente**: Lista automatizada de los últimos movimientos realizados.

### 2. Análisis y Metas
- **Visualización de Datos**: Pantalla de estadísticas avanzada con:
  - Gráfico de barras para ahorros semanales.
  - Gráfico de líneas para el crecimiento del patrimonio.
  - Gráfico de donut para la distribución porcentual de gastos.
- **Filtros Temporales**: Análisis de finanzas por periodos: Diario, Semanal, Mensual y Anual.
- **Gestión de Metas**: Seguimiento visual del progreso de metas de ahorro (ej: Casa, Viaje) con barras de porcentaje.

### 3. Perfil y Soporte
- **Edición de Cuenta**: Posibilidad de actualizar nombre y teléfono directamente en la base de datos.
- **Asistente IA (Beta)**: Chatbot integrado para soporte técnico y consultas rápidas.
- **Preferencias**: Cambio de tema (Claro/Oscuro/Sistema), idioma y moneda.

### 4. Seguridad y Acceso
- **Onboarding Interactivo**: Introducción moderna de 5 ventanas.
- **Autenticación Multi-método**: 
  - Inicio de sesión con Email/Password.
  - Integración completa con **Google Sign-In** (Configurado con SHA-1).
  - Acceso anónimo opcional.

---

## 🛠️ Pasos para Iniciar el Proyecto

Sigue estos pasos para configurar y ejecutar la aplicación en tu entorno local.

### 1. Requisitos Previos
- Tener instalado [Flutter](https://docs.flutter.dev/get-started/install) (versión 3.27 o superior recomendada).
- Tener instalado [Android Studio](https://developer.android.com/studio) o VS Code con el plugin de Flutter.
- Un dispositivo físico (Android) o emulador configurado.

### 2. Clonar y Preparar
```bash
# Descargar dependencias
flutter pub get
```

### 3. Configuración de Firebase
El proyecto ya cuenta con un archivo `google-services.json` configurado. Si deseas usar tu propio proyecto:

1. Crea un proyecto en [Firebase Console](https://console.firebase.google.com/).
2. Registra la app con el paquete: `com.example.app_bank`.
3. Agrega tu propia huella digital **SHA-1** en la consola de Firebase.
4. Habilita **Authentication** (Email y Google).
5. Configura **Firestore Database** con las siguientes reglas sugeridas:
```javascript
match /users/{userId} {
  allow read, write: if request.auth != null && request.auth.uid == userId;
  match /transactions/{transactionId} {
    allow read, write: if request.auth != null && request.auth.uid == userId;
  }
}
```

### 4. Ejecución
Para asegurar la compatibilidad con las últimas versiones de Gradle y Kotlin incluidas en este proyecto:

```bash
# Limpiar caché previa
flutter clean

# Ejecutar en el dispositivo
flutter run
```

---

## 🎨 Paleta de Colores
- **Fondo**: `#0B0E11` (Negro profundo)
- **Superficie**: `#151921` (Gris azulado)
- **Principal**: `#007AFF` (Azul vibrante)
- **Acento**: `#2ECC71` (Verde esmeralda para ahorros)

---

## 🚀 Próximos Pasos
- [ ] Implementar notificaciones push para recordatorios de ahorro.
- [ ] Integración real con APIs bancarias para lectura de SMS.
- [ ] Exportación de reportes en PDF y Excel.
