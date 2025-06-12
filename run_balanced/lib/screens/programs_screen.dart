import 'package:flutter/material.dart';
import 'program_detail_screen.dart';
import 'package:run_balanced/models/program.dart';

class ProgramsScreen extends StatelessWidget {
  const ProgramsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Program> programs = [
      Program(
        title: "Strength Training",
        subtitle: "Full-body, 3 sessions/week",
        duration: "6 weeks",
        difficulty: "Intermediate",
        description:
            "Build muscle and strength with this progressive 3-day plan.",
        icon: Icons.fitness_center,
        schedule: {
          "Day 1 - Upper Body": [
            "Bench Press – 4x8",
            "Pull Ups – 3x10",
            "Shoulder Press – 3x12",
            "Bicep Curls – 3x15",
            "Tricep Dips – 3x15",
          ],
          "Day 2 - Lower Body": [
            "Squats – 4x10",
            "Lunges – 3x12 each leg",
            "Deadlifts – 4x6",
            "Calf Raises – 3x20",
          ],
          "Day 3 - Full Body": [
            "Clean & Press – 3x8",
            "Kettlebell Swings – 3x15",
            "Burpees – 3x12",
            "Mountain Climbers – 3x30 sec",
          ],
        },
      ),
      Program(
        title: "Yoga for Flexibility",
        subtitle: "Daily morning flow",
        duration: "4 weeks",
        difficulty: "Beginner",
        description:
            "Improve flexibility and reduce stress with a gentle daily yoga routine.",
        icon: Icons.self_improvement,
        schedule: {
          "Day 1": [
            "Sun Salutations – 3 rounds",
            "Forward Fold – 1 min",
            "Seated Twist – 1 min each side",
          ],
          "Day 2": [
            "Cat-Cow – 1 min",
            "Downward Dog – 1 min",
            "Child’s Pose – 2 min",
          ],
          "Day 3": [
            "Neck Rolls – 1 min",
            "Shoulder Stretch – 1 min",
            "Standing Forward Bend – 1 min",
          ],
        },
      ),
      Program(
        title: "HIIT Fat Burn",
        subtitle: "High-intensity workouts, 4x/week",
        duration: "3 weeks",
        difficulty: "Advanced",
        description:
            "Burn fat and boost metabolism with high-intensity interval training.",
        icon: Icons.flash_on,
        schedule: {
          "Day 1 - Lower Body Blast": [
            "Jump Squats – 3x15",
            "Mountain Climbers – 3x30 sec",
            "Wall Sit – 3x45 sec",
          ],
          "Day 2 - Core Crusher": [
            "Plank – 3x1 min",
            "Russian Twists – 3x20",
            "Leg Raises – 3x15",
          ],
          "Day 3 - Upper Body Burn": [
            "Push Ups – 3x15",
            "Burpees – 3x12",
            "Arm Circles – 2x30 sec",
          ],
          "Day 4 - Full Body Sweat": [
            "High Knees – 3x30 sec",
            "Jumping Lunges – 3x10",
            "Plank Jacks – 3x20",
          ],
        },
      ),
      Program(
        title: "Posture & Core Strength",
        subtitle: "Improve posture and stability",
        duration: "2 weeks",
        difficulty: "Intermediate",
        description:
            "Strengthen your core and correct posture with targeted bodyweight exercises.",
        icon: Icons.accessibility_new,
        schedule: {
          "Day 1": [
            "Plank – 3x45 sec",
            "Dead Bug – 3x12",
            "Bird Dog – 3x12 each side",
          ],
          "Day 2": [
            "Wall Angels – 3x15",
            "Glute Bridge – 3x20",
            "Superman Hold – 3x30 sec",
          ],
          "Day 3": [
            "Side Plank – 3x30 sec each side",
            "Reverse Crunches – 3x15",
            "Chin Tucks – 3x15",
          ],
        },
      ),
      Program(
        title: "Daily Step Boost",
        subtitle: "Increase daily activity",
        duration: "30 days",
        difficulty: "Beginner",
        description:
            "Get moving and build healthy habits with this daily walking challenge.",
        icon: Icons.directions_walk,
        schedule: {
          "Week 1": ["Goal: 5,000 steps/day"],
          "Week 2": ["Goal: 6,500 steps/day"],
          "Week 3": ["Goal: 8,000 steps/day"],
          "Week 4": ["Goal: 10,000 steps/day"],
        },
      ),
      // You can add other programs similarly
    ];

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: programs.length,
        itemBuilder: (context, index) {
          final program = programs[index];
          return _buildProgramCard(context, program, theme);
        },
      ),
    );
  }

  Widget _buildProgramCard(
    BuildContext context,
    Program program,
    ThemeData theme,
  ) {
    return Card(
      color: theme.cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(program.icon, color: theme.iconTheme.color, size: 32),
        title: Text(program.title, style: theme.textTheme.bodyLarge),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(program.subtitle, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(
              "Duration: ${program.duration}",
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              "Difficulty: ${program.difficulty}",
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: theme.iconTheme.color),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProgramDetailScreen(program: program),
            ),
          );
        },
      ),
    );
  }
}
