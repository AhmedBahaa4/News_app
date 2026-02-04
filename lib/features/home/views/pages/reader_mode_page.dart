// ignore_for_file: unnecessary_brace_in_string_interps, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:news_app/core/models/news_api_response.dart';

class ReaderModePage extends StatefulWidget {
  final Article article;
  const ReaderModePage({super.key, required this.article});

  @override
  State<ReaderModePage> createState() => _ReaderModePageState();
}

class _ReaderModePageState extends State<ReaderModePage> {
  double fontSize = 16;
  double lineHeight = 1.5;
  bool dark = false;

  @override
  Widget build(BuildContext context) {
    final text = [
      widget.article.title,
      widget.article.description,
      widget.article.content
    ].where((e) => e != null && e.isNotEmpty).join('\n\n');

    final words = text.split(RegExp(r'\\s+')).length;
    final minutes = (words / 200).ceil().clamp(1, 60);

    final bg = dark ? Colors.black : Colors.grey[100]!;
    final fg = dark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: dark ? Colors.black : Colors.white,
        foregroundColor: fg,
        title: const Text('Reader Mode'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${minutes} min read',
                  style: TextStyle(color: fg.withOpacity(0.8)),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(dark ? Icons.light_mode : Icons.dark_mode),
                  color: fg,
                  onPressed: () => setState(() => dark = !dark),
                ),
              ],
            ),
            Row(
              children: [
                const Text('A'),
                Expanded(
                  child: Slider(
                    min: 14,
                    max: 24,
                    divisions: 10,
                    value: fontSize,
                    label: fontSize.toStringAsFixed(0),
                    onChanged: (v) => setState(() => fontSize = v),
                  ),
                ),
                const Text('A', style: TextStyle(fontSize: 20)),
              ],
            ),
            Row(
              children: [
                const Text('Line'),
                Expanded(
                  child: Slider(
                    min: 1.2,
                    max: 2.0,
                    divisions: 8,
                    value: lineHeight,
                    label: lineHeight.toStringAsFixed(1),
                    onChanged: (v) => setState(() => lineHeight = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  text.isEmpty ? 'No content available.' : text,
                  style: TextStyle(
                    color: fg,
                    fontSize: fontSize,
                    height: lineHeight,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
