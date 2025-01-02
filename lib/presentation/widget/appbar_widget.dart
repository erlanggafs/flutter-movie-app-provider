// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final Function onDrawerPressed;
//   final Function onSearchPressed;
//   final Function onNotificationPressed;
//
//   const CustomAppBar({
//     required this.title,
//     required this.onDrawerPressed,
//     required this.onSearchPressed,
//     required this.onNotificationPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.black,
//       foregroundColor: Colors.white,
//       leading: IconButton(
//         onPressed: () => onDrawerPressed(),
//         icon: const Icon(Icons.menu),
//       ),
//       title: Text(
//         title,
//         style: GoogleFonts.pacifico(
//           fontSize: 24,
//           color: Colors.blue, // Anda bisa mengganti warna sesuai kebutuhan
//         ),
//       ),
//       centerTitle: true,
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.search_rounded),
//           onPressed: () => onSearchPressed(context),
//         ),
//         IconButton(
//           onPressed: () => onNotificationPressed(),
//           icon: const Icon(Icons.notifications),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
