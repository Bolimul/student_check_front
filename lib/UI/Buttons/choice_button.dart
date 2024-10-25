import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:student_check/UI/Providers/user_provider.dart';

class ChoiceButton extends StatelessWidget{
  const ChoiceButton({
    super.key,
    required this.title,
    required this.buttonText,
    required this.content,
    required this.approvalMessage,
    required this.disapprovalMessage,
    required this.function,
    required this.stList
  });
  final String title;
  final String buttonText;
  final String content;
  final String approvalMessage;
  final String disapprovalMessage;
  final FutureOr<bool> Function(String?) function;
  final String stList;

  @override
  Widget build(BuildContext context) {
    String messageText = "";
    return ElevatedButton.icon(
      onPressed: ()async{
        await showDialog(
          context: context, 
          builder: (context) {
            return StatefulBuilder(
              builder:(context, setState) {
                return AlertDialog.adaptive(
                  title: Text(title),
                  content: Text(content),
                  actions: [
                    ElevatedButton(
                      onPressed: ()async {
                        bool res = await function(stList);
                          
                          if(context.mounted){
                            setState(() {
                              res? messageText = approvalMessage : messageText = disapprovalMessage;
                              context.read<UserProvider>().setGroups();
                              context.read<UserProvider>().setNames();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(messageText)
                            ));
                            Navigator.pop(context);
                          }
                        },
                      child: const Text("כן")
                    ),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: const Text("יציאה")
                    )
                  ],
                );
              }
            );
          }
        );
      },   
      label: Text(buttonText, textAlign: TextAlign.center,),
    );
  }
}
