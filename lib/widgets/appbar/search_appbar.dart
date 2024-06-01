import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SearchScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  TextEditingController controller = TextEditingController();
  Function(String newInput)? onchanged;

  SearchScreenAppBar(
      {required this.controller, required this.onchanged, super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 20),
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        child: AppBar(
          centerTitle: true,
          title: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(211, 211, 211, 211),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              border: Border.all(color: Colors.black),
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),
                const Icon(Icons.search),
                const SizedBox(width: 10),
                Flexible(
                  child: TextField(
                    controller: controller,
                    onChanged: (text) => onchanged!(text),
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);
}
