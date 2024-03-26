import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Key? scaffoldKey;
  final EdgeInsets? padding;
  final String? title;
  final bool? centerTitle;
  final Widget body;
  final Drawer? drawer;
  final Widget? showLeading;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const CustomScaffold({
    super.key,
    this.scaffoldKey,
    this.padding,
    this.title,
    this.centerTitle,
    required this.body,
    this.drawer,
    this.showLeading,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawerScrimColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      appBar: (showLeading != null ||
              title != null ||
              actions != null ||
              drawer != null)
          ? AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: showLeading,
              automaticallyImplyLeading: false,
              title: title != null
                  ? Text(
                      title!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : null,
              centerTitle: centerTitle,
              actions: actions,
            )
          : null,
      body: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
        child: body,
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
