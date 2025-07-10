/// Calculates Joint Load Index (JLI).
///
/// [force] Applied force.
/// [angle] Joint angle.
/// [repetitions] Number of repetitions.
/// [alpha], [beta], [gamma] are weighting coefficients.
/// Returns a value between 0 and 100.

double calculateJLI({
  required double force,
  required double angle,
  required int repetitions,
  double alpha = 0.3,
  double beta = 0.5,
  double gamma = 0.2,
  double maxTheta = 45.0,
  double maxForce = 3.0,
  double maxReps = 300.0,

}) {
  if (force < 0 || angle < 0 || repetitions < 0) {
    throw ArgumentError('I parametri non possono essere negativi.');
  }
  final rawScore = (alpha * force / maxForce + beta * angle / maxTheta + gamma * repetitions / maxReps) * 100;
  return rawScore.clamp(0.0, 100.0);
}
