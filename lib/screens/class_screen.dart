import 'package:flutter/material.dart';

class ClassScreen extends StatelessWidget {
  const ClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> ranking = [
      {'name': 'Tú', 'points': 120, 'isUser': true},
      {'name': 'María', 'points': 110},
      {'name': 'Juan', 'points': 100},
      {'name': 'Lucía', 'points': 90},
      {'name': 'Pedro', 'points': 80},
      {'name': 'Ana', 'points': 70},
    ];
    
    final List<String> temario = [
      'Ahorro y presupuesto',
      'Inversiones básicas',
      'Regla 50/30/20',
      'Errores comunes en finanzas personales',
    ];
    
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset('assets/logo.png', height: 40),
                  const SizedBox(width: 12),
                  const Text(
                    'Clase',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B6B4B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Ranking semanal', 
                         style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, 
                                        color: Color(0xFF1B6B4B))),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ranking.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final user = ranking[i];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: user['isUser'] == true 
                            ? const Color(0xFF7ED957) 
                            : Colors.grey[300],
                        child: user['isUser'] == true 
                            ? const Icon(Icons.person, color: Colors.white) 
                            : Text(user['name'][0]),
                      ),
                      title: Text(user['name'] + (user['isUser'] == true ? ' (Tú)' : '')),
                      trailing: Text('${user['points']} pts', 
                                   style: const TextStyle(fontWeight: FontWeight.bold)),
                      tileColor: user['isUser'] == true ? const Color(0xFFE8FCE3) : null,
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              const Text('Actividad especial de la semana', 
                         style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, 
                                        color: Color(0xFF1B6B4B))),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.star, color: Color(0xFF7ED957), size: 32),
                  title: const Text('Desafío Financiero', 
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('¡Completa los juegos y suma puntos extra esta semana!'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Navegar a la pantalla de juegos
                      Navigator.of(context).pushNamed('/main');
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7ED957), 
                        foregroundColor: Colors.white),
                    child: const Text('Jugar'),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text('Temario de la semana', 
                         style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, 
                                        color: Color(0xFF1B6B4B))),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: temario.map((t) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline, color: Color(0xFF7ED957)),
                          const SizedBox(width: 8),
                          Text(t, style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    )).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text('¡Sigue aprendiendo y compitiendo con tu clase!', 
                         style: TextStyle(fontSize: 18, color: Color(0xFF1B6B4B))),
            ],
          ),
        ),
      ),
    );
  }
} 