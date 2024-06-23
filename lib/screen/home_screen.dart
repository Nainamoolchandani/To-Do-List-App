//
// import 'package:flutter/material.dart';
//
// class ToDoTask extends StatefulWidget {
//   const ToDoTask({super.key});
//
//   @override
//   State<ToDoTask> createState() => _ToDoTaskState();
// }
//
// class _ToDoTaskState extends State<ToDoTask> {
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.cyan,
//         title: const Text("TO DO List App"),
//         centerTitle: true,
//       ),
//       body:   Padding(
//         padding: const EdgeInsets.symmetric(horizontal:15,vertical: 15),
//         child: Column(
//           children: [
//             const TextField(
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(10))),
//                 icon: Icon(Icons.task),
//                 iconColor: Colors.cyan,
//                 hintText: "Write your Task",
//                 labelText: "Task"),),
//
//             const SizedBox(height: 10,),
//
//             const Text('TO DO LIST TASK', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ElevatedButton(onPressed: (){}, child: const Text("Update")),
//                 ElevatedButton(onPressed: (){}, child: const Text("Save")),
//             ],)
//           ],
//         ),
//       ),
//
//
//
//     );
//   }
// }
