import 'package:flutter/material.dart';

class LegendForm extends StatelessWidget {
  const LegendForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Container(
                  decoration: const ShapeDecoration(shape: CircleBorder(), color: Colors.red),
                  width: 20,
                  height: 20,
                ),
                const Text("Param 1 - "),
                const Text("תלמיד מרכיב את הסכום המבוקש עם שטרות ומתבעות")
              ],
            ),
            const SizedBox(width: 10, height: 5),
            Row(
              children: [
                Container(
                  decoration: const ShapeDecoration(shape: CircleBorder(), color: Colors.blue),
                  width: 20,
                  height: 20,
                ),
                const Text("Param 2 - "),
                const Text("תלמיד מרכיב את הסכום המבוקש עם מטבעות")
              ],
            ),
            const SizedBox(width: 10, height: 5),
            Row(
              children: [
                Container(
                  decoration: const ShapeDecoration(shape: CircleBorder(), color: Colors.green),
                  width: 20,
                  height: 20,
                ),
                const Text("Param 3 - "),
                const Text("תלמיד מזהה מספרים בתחום")
              ],
            ),
            const SizedBox(width: 10, height: 5),
            Row(
              children: [
                Container(
                  decoration: const ShapeDecoration(shape: CircleBorder(), color: Colors.black),
                  width: 20,
                  height: 20,
                ),
                const Text("Param 4 - "),
                const Text("תלמיד מחשב את הסכום שמגיע לו בתחום")
              ],
            ),
            const SizedBox(width: 10, height: 5),
            const Row(
              children: [
                Text("Param 5 - "),
                Text("תלמיד בוחר את המוצר לפי סכום הכסף שיש ברשותו")
              ],
            ),
            const SizedBox(width: 10, height: 5),
            const Row(
              children: [
                Text("Param 6 - "),
                Text("תלמיד מזהה/מיישם את המספר הגדול/הקטן")
              ],
            ),
            const SizedBox(width: 10, height: 5),
            const Row(
              children: [
                Text("Param 7 - "),
                Text("תלמיד מזהה/מתאר האם סכום הכסף שבידו גדול, קטן או שווה למחיר המוצר")
              ],
            ),
            const SizedBox(width: 10, height: 5),
            const Row(
              children: [
                Text("Param 8 - "),
                Text("תלמיד מזהה/מתאר מצבים בהם מקבלים עודף")
              ],
            ),
            const SizedBox(width: 10, height: 5),
            const Row(
              children: [
                Text("Param 9 - "),
                Text("תלמיד מזהה/מתאר מצבים בהם לא מקבלים עודף")
              ],
            ),
            const SizedBox(width: 10, height: 5),
            const Row(
              children: [
                Text("Param 10 - "),
                Text("תלמיד מבחין בין זול ויקר")
              ],
            ),
            const SizedBox(width: 10, height: 5),
            const Row(
              children: [
                Text("Param 11 - "),
                Text("תלמיד מתאים בין מטבע למספר המייצג את ערכו המספרי(1)")
              ],
            ),
            const SizedBox(width: 10, height: 5),
            const Row(
              children: [
                Text("Param 12 - "),
                Text("תלמיד מתאים בין המטבע למספר המייצג את ערכו המספרי(2)")
              ],
            ),
            const SizedBox(width: 10, height: 5),
            const Row(
              children: [
                Text("Param 13 - "),
                Text("תלמיד מתאים בין המטבע למספר המייצג את ערכו המספרי(5)")
              ],
            ),
            const SizedBox(width: 10, height: 5),
            const Row(
              children: [
                Text("Param 14 - "),
                Text("תלמיד מתאים בין המטבע למספר המייצג את ערכו המספרי(10)")
              ],
            ),
            const SizedBox(width: 10, height: 5),
            const Row(
              children: [
                Text("Param 15 - "),
                Text("תלמיד מתאים בין השטר למספר המייצג את ערכו המספרי(20)")
              ],
            ),
            const SizedBox(width: 10, height: 5),
            const Row(
              children: [
                Text("Param 16 - "),
                Text("תלמיד מתאים בין השטר למספר המייצג את ערכו המספרי(50)")
              ],
            ),
            const SizedBox(width: 10, height: 5),
            const Row(
              children: [
                Text("Param 17 - "),
                Text("תלמיד מתאים בין השטר למספר המייצג את ערכו המספרי(100)")
              ],
            ),
            const SizedBox(width: 10, height: 5),
            const Row(
              children: [
                Text("Param 18 - "),
                Text("תלמיד מתאים בין השטר למספר המייצג את ערכו המספרי(200)")
              ],
            ),
            const SizedBox(width: 10, height: 5),
            const Row(
              children: [
                Text("Param 19 - "),
                Text("תלמיד מזהה/מיישם את מטבע ה-1")
              ],
            ),
            const SizedBox(width: 10, height: 5),
            const Row(
              children: [
                Text("Param 20 - "),
                Text("תלמיד מזהה/מיישם את מטבע ה-2")
              ],
            ),
            const SizedBox(width: 10, height: 5),
            const Row(
              children: [
                Text("Param 21 - "),
                Text("תלמיד מזהה/מיישם את מטבע ה-5")
              ],
            ),
            const SizedBox(width: 10, height: 5),
            const Row(
              children: [
                Text("Param 22 - "),
                Text("תלמיד מזהה/מיישם את מטבע ה-10")
              ],
            ),
            const SizedBox(width: 10, height: 5),
            const Row(
              children: [
                Text("Param 23 - "),
                Text("תלמיד מזהה/מיישם את שטר ה-20")
              ],
            ),
            const SizedBox(width: 10, height: 5),
            const Row(
              children: [
                Text("Param 24 - "),
                Text("תלמיד מזהה/מיישם את שטר ה-50")
              ],
            ),
            const SizedBox(width: 10, height: 5),
            const Row(
              children: [
                Text("Param 25 - "),
                Text("תלמיד מזהה/מיישם את שטר ה-100")
              ],
            ),
            const SizedBox(width: 10, height: 5),
            const Row(
              children: [
                Text("Param 26 - "),
                Text("תלמיד מזהה/מיישם את שטר ה-200")
              ],
            ),
          ],
        ),
      ),
    );
  }
  
}