import 'dart:math';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  bool _notificationsEnabled = true;
  
  // Lista de mensajes motivacionales para notificaciones
  final List<String> _motivationalMessages = [
            '¡Es hora de usar FINANCE4U! 💰',
    'Tu futuro financiero te espera 🌟',
    '5 minutos de aprendizaje pueden cambiar tu vida 📚',
    '¡Construye tu libertad financiera hoy! 🏗️',
    'Un pequeño paso hacia tus metas financieras 👣',
    'El conocimiento financiero es poder 💪',
    '¡Tu yo del futuro te agradecerá! 🙏',
    'Invierte en tu educación financiera 📈',
    '¡Cada lección te acerca más a tus sueños! ✨',
    'La disciplina financiera empieza hoy 🎯',
  ];

  final List<String> _tipMessages = [
    'Tip: Ahorra al menos el 20% de tus ingresos',
    'Recuerda: Nunca gastes dinero que no tienes',
    'Consejo: Revisa tus gastos semanalmente',
    'Tip: Invierte en ti mismo primero',
    'Recuerda: Los pequeños ahorros se vuelven grandes',
    'Consejo: Automatiza tus ahorros',
    'Tip: Diversifica tus inversiones',
          'Recuerda: La paciencia es clave en FINANCE4U',
    'Consejo: Siempre ten un fondo de emergencia',
    'Tip: Edúcate antes de invertir',
  ];

  final List<String> _progressMessages = [
    '¡Ya completaste varias lecciones! 🎊',
    'Tu progreso es impresionante 📊',
    '¡Sigue así, vas por buen camino! 🛤️',
    'Cada día estás más cerca de tus metas 🎯',
    '¡Tu conocimiento financiero está creciendo! 🌱',
    'Excelente trabajo en tus estudios 👏',
    '¡Eres un estudiante ejemplar! 🌟',
    'Tu dedicación dará frutos 🍎',
    '¡Continúa con esta racha! 🔥',
    'Estás construyendo un futuro brillante ✨',
  ];

  // Configura las notificaciones
  void enableNotifications(bool enabled) {
    _notificationsEnabled = enabled;
  }

  bool get notificationsEnabled => _notificationsEnabled;

  // Obtiene un mensaje aleatorio según el tipo
  String _getRandomMessage(List<String> messages) {
    final random = Random();
    return messages[random.nextInt(messages.length)];
  }

  // Programa notificaciones diarias
  void scheduleDailyReminder() {
    if (!_notificationsEnabled) return;
    
    // Simula programar notificación diaria a las 7:00 PM
    print('📱 Notificación programada: ${_getRandomMessage(_motivationalMessages)}');
  }

  // Envía notificación de tip diario
  void sendDailyTip() {
    if (!_notificationsEnabled) return;
    
    print('💡 Tip del día: ${_getRandomMessage(_tipMessages)}');
  }

  // Envía notificación de progreso
  void sendProgressNotification() {
    if (!_notificationsEnabled) return;
    
    print('🎯 Progreso: ${_getRandomMessage(_progressMessages)}');
  }

  // Envía notificación de racha
  void sendStreakNotification(int streakDays) {
    if (!_notificationsEnabled) return;
    
    String message;
    if (streakDays == 1) {
      message = '¡Iniciaste tu racha de aprendizaje! 🔥';
    } else if (streakDays == 7) {
      message = '¡7 días seguidos! ¡Increíble dedicación! 🌟';
    } else if (streakDays == 30) {
      message = '¡30 días de constancia! ¡Eres imparable! 🚀';
    } else if (streakDays % 10 == 0) {
      message = '¡$streakDays días consecutivos! ¡Sigue así! 💪';
    } else {
      message = '¡$streakDays días seguidos aprendiendo! 🎊';
    }
    
    print('🔥 Racha: $message');
  }

  // Envía notificación de nuevo contenido
  void sendNewContentNotification(String contentTitle) {
    if (!_notificationsEnabled) return;
    
    print('🆕 Nuevo contenido disponible: $contentTitle');
  }

  // Envía notificación de objetivo alcanzado
  void sendGoalAchievedNotification(String goal) {
    if (!_notificationsEnabled) return;
    
    print('🎯 ¡Objetivo alcanzado! $goal');
  }

  // Envía recordatorio de juego pendiente
  void sendGameReminderNotification() {
    if (!_notificationsEnabled) return;
    
    final messages = [
      '¡Tienes juegos pendientes! 🎮',
      '¿Listo para un nuevo desafío? 🏆',
      '¡Pon a prueba tus conocimientos! 🧠',
      '¡Hora de jugar y aprender! 🎯',
    ];
    
    print('🎮 Juegos: ${_getRandomMessage(messages)}');
  }

  // Envía notificación de meta financiera
  void sendFinancialGoalReminder() {
    if (!_notificationsEnabled) return;
    
    final messages = [
      'Recuerda revisar tus metas financieras 📊',
      '¿Cómo van tus ahorros este mes? 💰',
      'Es hora de evaluar tu presupuesto 📋',
      'Revisa tu progreso hacia la libertad financiera 🗽',
    ];
    
    print('💼 Metas: ${_getRandomMessage(messages)}');
  }

  // Cancela todas las notificaciones
  void cancelAllNotifications() {
    print('🔕 Todas las notificaciones han sido canceladas');
  }

  // Método para testing - simula todas las notificaciones
  void testAllNotifications() {
    print('\n🧪 Testing todas las notificaciones...\n');
    
    scheduleDailyReminder();
    sendDailyTip();
    sendProgressNotification();
    sendStreakNotification(5);
    sendNewContentNotification('Nueva lección: Inversiones Avanzadas');
    sendGoalAchievedNotification('Completar módulo de Ahorros');
    sendGameReminderNotification();
    sendFinancialGoalReminder();
    
    print('\n✅ Test de notificaciones completado\n');
  }
} 