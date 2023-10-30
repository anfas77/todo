// import 'package:flutter/material.dart';
// import 'package:todo/todoitem.dart';
// import '';

// class Home extends StatelessWidget {
//   const Home({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 203, 221, 236),
//       appBar: buildAppbar(),
//       body: Container(
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//         child: Column(
//           children: [
//             searchBox(),
//             Expanded(
//               child: ListView(
//                 children: [
//                   Container(
//                     margin: EdgeInsets.only(top: 50, bottom: 20),
//                     child: Text(
//                       'All ToDos',
//                       style:
//                           TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                   ToDoItem()
//                 ],
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 15),
//               decoration: BoxDecoration(
//                   color: Colors.white, borderRadius: BorderRadius.circular(20)),
//               child: TextField(
//                 decoration: InputDecoration(
//                     contentPadding: EdgeInsets.all(0),
//                     prefixIcon: Icon(
//                       Icons.search,
//                       color: Colors.black26,
//                       size: 20,
//                     ),
//                     prefixIconConstraints: BoxConstraints(
//                       maxHeight: 20,
//                       minWidth: 25,
//                     ),
//                     border: InputBorder.none,
//                     hintText: 'search',
//                     hintStyle: TextStyle(color: Colors.black45)),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget searchBox() {
//     return Container();
//   }

//   AppBar buildAppbar() {
//     return AppBar(
//       backgroundColor: Color.fromARGB(255, 210, 231, 248),
//       elevation: 0,
//       title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//         Icon(
//           Icons.menu,
//           color: Color.fromARGB(204, 43, 39, 39),
//           size: 30,
//         ),
//         Container(
//           height: 40,
//           width: 40,
//           child: ClipRRect(
//               borderRadius: BorderRadius.circular(20),
//               child: Image.asset('image/ab.jpeg')),
//         )
//       ]),
//     );
//   }
// }
