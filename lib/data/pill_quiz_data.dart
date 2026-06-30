/// Datos de preguntas extra para completar 10 por píldora.
class PillQuizData {
  final String question;
  final List<String> options;
  final int correctIndex;

  const PillQuizData({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

const int kQuestionsPerPill = 10;
