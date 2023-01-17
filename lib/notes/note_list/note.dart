import 'package:flutter/material.dart';

class Note extends StatelessWidget {
  const Note(
      {super.key, this.title, required this.content, this.tags = const []});
  final String? title;
  final String content;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              Text(
                title!,
                style: theme.textTheme.headlineSmall,
              ),
            const SizedBox(height: 8, width: double.infinity),
            Text(content),
            TextButton(onPressed: () {}, child: const Text("More")),
            Wrap(
              spacing: 8,
              children: tags.map((tag) => Chip(label: Text("#$tag"))).toList(),
            )
          ],
        ),
      ),
    );
  }
}
