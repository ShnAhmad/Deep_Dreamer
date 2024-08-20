import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/services/image_service.dart';

class ImageCreatorScreen extends StatefulWidget {
  const ImageCreatorScreen({super.key});

  @override
  _ImageCreatorScreenState createState() => _ImageCreatorScreenState();
}

class _ImageCreatorScreenState extends State<ImageCreatorScreen> {
  final TextEditingController _promptController = TextEditingController();
  List<String> _imageUrls = [];
  bool _isLoading = false;

  Future<void> _searchImages() async {
    if (_promptController.text.trim().isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        final imageUrls =
            await ImageService.searchAiImages(_promptController.text);
        setState(() {
          _imageUrls = imageUrls;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to search images: ${e.toString()}')),
        );
      }
    }
  }

  void _dismissKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AI Image Creator'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _promptController,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Enter a prompt',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                ),
                onSubmitted: (_) => _searchImages(),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _imageUrls.isEmpty
                        ? const Center(child: Text('No images found'))
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.0,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: _imageUrls.length,
                            padding: const EdgeInsets.all(16),
                            itemBuilder: (context, index) {
                              return ClipRoundedImage(
                                imageUrl: _imageUrls[index],
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _searchImages,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Create',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}

class ClipRoundedImage extends StatelessWidget {
  final String imageUrl;

  const ClipRoundedImage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
