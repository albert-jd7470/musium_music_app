import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_provider.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({Key? key}) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearchSubmit(String query) {
    if (query.isNotEmpty) {
      Provider.of<SearchProvider>(context, listen: false).searchSongs(query);
    } else {
      Provider.of<SearchProvider>(context, listen: false).clearSearch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF222222), // Dark grey background
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: TextField(
          controller: _controller,
          onSubmitted: _onSearchSubmit,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Artists, songs, or podcasts...',
            hintStyle: const TextStyle(
              color: Colors.white54,
              fontSize: 16,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.white54,
            ),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white54),
                    onPressed: () {
                      _controller.clear();
                      _onSearchSubmit('');
                      setState(() {});
                    },
                  )
                : const Icon(
                    Icons.mic_none,
                    color: Colors.white54,
                  ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (_) {
            setState(() {});
          },
        ),
      ),
    );
  }
}
