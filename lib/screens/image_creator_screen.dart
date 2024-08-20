import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/services/image_service.dart';

class ImageCreatorScreen extends StatefulWidget {
  const ImageCreatorScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImageCreatorScreenState createState() => _ImageCreatorScreenState();
}

class _ImageCreatorScreenState extends State<ImageCreatorScreen> {
  final TextEditingController _promptController = TextEditingController();
  List<String> _imageUrls = [];
  bool _isLoading = false;

  Future<void> _searchImages() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Image Creater'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _promptController,
              decoration: InputDecoration(
                labelText: 'Enter a prompt',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchImages,
                ),
              ),
              onSubmitted: (_) => _searchImages(),
            ),
          ),
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
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: _imageUrls.length,
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (context, index) {
                          return CachedNetworkImage(
                            imageUrl: _imageUrls[index],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
