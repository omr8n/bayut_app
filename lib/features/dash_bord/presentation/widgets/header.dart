import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.title,
    required this.onPressed,
    this.showTexField = true,
    this.controller,
    this.onChanged,
    this.onSubmitted,
  });
  final String? title;
  final void Function()? onPressed;
  final bool showTexField;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  @override
  Widget build(BuildContext context) {
    // final theme = Utils(context).getTheme;
    // final color = Utils(context).color;
    return Row(
      children: [
        if (showTexField)
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title ?? ''), // بدون !
            ),
          ),
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
              hintText: "Search",
              fillColor: Theme.of(context).cardColor,
              filled: true,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              suffixIcon: InkWell(
                onTap: onPressed,
                child: Container(
                  padding: const EdgeInsets.all(7.5),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Icon(Icons.search, size: 25),
                ),
              ),
            ),
          ),
        ),
      ],
    );

    // return Row(
    //   children: [
    //     // if (!Responsive.isDesktop(context))
    //     // IconButton(icon: const Icon(Icons.menu), onPressed: onPressed),
    //     // if (Responsive.isDesktop(context))
    //     Visibility(
    //       visible: showTexField,
    //       child: Expanded(
    //         flex: 2,
    //         child: Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Text(title!),
    //         ),
    //       ),
    //     ),
    //     // if (Responsive.isDesktop(context))
    //     //   Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
    //     // !showTexField
    //     //     ? Container()
    //     //     :
    //     Expanded(
    //       child: TextField(
    //         decoration: InputDecoration(
    //           hintText: "Search",
    //           fillColor: Theme.of(context).cardColor,
    //           filled: true,
    //           border: const OutlineInputBorder(
    //             borderSide: BorderSide.none,
    //             borderRadius: BorderRadius.all(Radius.circular(10)),
    //           ),
    //           suffixIcon: InkWell(
    //             onTap: () {},
    //             child: Container(
    //               padding: const EdgeInsets.all(10 * 0.75),
    //               margin: const EdgeInsets.symmetric(horizontal: 10 / 2),
    //               decoration: const BoxDecoration(
    //                 color: Colors.blue,
    //                 borderRadius: BorderRadius.all(Radius.circular(10)),
    //               ),
    //               child: const Icon(Icons.search, size: 25),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}
