import 'package:flutter/material.dart';
import 'package:student_check/UI/Forms/legend_form.dart';

class ShowLegendButton extends StatelessWidget{
  const ShowLegendButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purple),
        color: const Color.fromARGB(255, 226, 143, 240),
        borderRadius: BorderRadius.circular(10)
      ),
      width: 40,
      height: 40,
      child: IconButton(
        onPressed: ()async{
          await showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog.adaptive(
                title: Center(child: Text('מקרא'),),
                content: LegendForm(),
              );
            },
          );
        },
        icon: const Icon(Icons.map_outlined, color: Colors.white,),
        tooltip: 'להציג את המקרא',
      ),
    );
  }
  
}