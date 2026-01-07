import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
import 'package:flutter/material.dart';

class PracticeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: ResponsiveText('Practice Tabs'),
          bottom: TabBar(
            tabs: [
              Tab(text: "Tab 1"),
              Tab(text: "Tab 2"),
              Tab(text: "Tab 3"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: ResponsiveText('Content for Tab 1')),
            Center(child: ResponsiveText('Content for Tab 2')),
            Center(child: ResponsiveText('Content for Tab 3')),
          ],
        ),
      ),
    );
  }
}
