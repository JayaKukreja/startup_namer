import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final wordPair = WordPair.random(); // Add this line.
    return MaterialApp(
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white, foregroundColor: Colors.black)),
        title: 'Startup Name Generator',
        home: const RandomWords());
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[]; // NEW
  final _biggerFont = const TextStyle(fontSize: 18); // NEW
  final _saved = <WordPair>{};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Startup Name Generator'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  final tiles = _saved.map((e) {
                    return ListTile(
                      title: Text(
                        e.asPascalCase,
                        style: _biggerFont,
                      ),
                    );
                  });
                  final dividend = tiles.isNotEmpty
                      ? ListTile.divideTiles(tiles: tiles, context: context)
                          .toList()
                      : <Widget>[];
                  return Scaffold(
                      appBar: AppBar(
                        title: Text("Saved Suggestions"),
                      ),
                      body: ListView(children: dividend));
                }));
              },
              icon: Icon(Icons.list),
              tooltip: 'Saved Suggestions',
            )
          ],
        ),
        body: _buildSuggestions());
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return const Divider();

        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        final alreadySaved = _saved.contains(_suggestions[index]);
        return ListTile(
          title: Text(
            _suggestions[index].asPascalCase,
            style: _biggerFont,
          ),
          trailing: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
              color: alreadySaved ? Colors.red : null,
              semanticLabel: alreadySaved ? 'Remove from saved' : 'Save'),
          onTap: () {
            setState(() {
              alreadySaved
                  ? _saved.remove(_suggestions[index])
                  : _saved.add(_suggestions[index]);
            });
          },
        );
      },
    );
  }
}
