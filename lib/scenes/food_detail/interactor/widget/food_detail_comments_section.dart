import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/avatar_widget.dart';
import 'package:coffee_bean/shared/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FoodDetailCommentsSection extends StatelessWidget {
  const FoodDetailCommentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> mockComments = [
      {
        "name": "Lorem ipsum",
        "avatar": "https://i.pravatar.cc/150?u=1",
        "date": "2025/01/01",
        "rating": 4.0,
        "content": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure",
        "images": [
          "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800&q=80",
          "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800&q=80",
        ]
      },
      {
        "name": "Lorem ipsum",
        "avatar": "https://i.pravatar.cc/150?u=2",
        "date": "2025/01/01",
        "rating": 4.5,
        "content": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore riure",
        "images": [
          "https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=800&q=80",
        ]
      }
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Đánh giá",
                style: TMLabsTextStyle.h2,
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Text("Tất cả", style: TMLabsTextStyle.body.copyWith(color: Colors.grey[600])),
                    Icon(Icons.chevron_right, size: 20, color: Colors.grey[600]),
                  ],
                ),
              ),
            ],
          ),
          ...mockComments.map((comment) => _buildCommentItem(context, comment)),
        ],
      ),
    );
  }

  Widget _buildCommentItem(BuildContext context, Map<String, dynamic> comment) {
    final List<String> images = comment['images'] ?? [];

    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AvatarWidget(
                imageUrl: comment['avatar'],
                size: 40,
                backgroundColor: TMLabsColor.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment['name'],
                      style: TMLabsTextStyle.bodyBold,
                    ),
                    Text(
                      comment['date'],
                      style: TMLabsTextStyle.caption,
                    ),
                  ],
                ),
              ),
              RatingBarIndicator(
                rating: comment['rating'],
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.orange,
                ),
                itemCount: 5,
                itemSize: 18.0,
                direction: Axis.horizontal,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            comment['content'],
            style: TMLabsTextStyle.body.copyWith(color: Colors.black87, height: 1.4),
          ),
          if (images.isNotEmpty) ...[
            const SizedBox(height: 15),
            if (images.length == 1)
              GestureDetector(
                onTap: () => _showFullScreenImage(context, images, 0),
                child: CachedImageWidget(
                  imageUrl: images[0],
                  width: double.infinity,
                  height: 220,
                  borderRadius: 12,
                ),
              )
            else
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () => _showFullScreenImage(context, images, index),
                        child: CachedImageWidget(
                          imageUrl: images[index],
                          width: 120,
                          height: 120,
                          borderRadius: 12,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, List<String> images, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0,
          ),
          body: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(images[index]),
                initialScale: PhotoViewComputedScale.contained,
                heroAttributes: PhotoViewHeroAttributes(tag: images[index]),
              );
            },
            itemCount: images.length,
            loadingBuilder: (context, event) => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            pageController: PageController(initialPage: initialIndex),
          ),
        ),
      ),
    );
  }
}
