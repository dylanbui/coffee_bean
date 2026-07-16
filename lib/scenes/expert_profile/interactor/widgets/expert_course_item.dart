import 'package:coffee_bean/data/model/response/hub/course_info.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';

class ExpertCourseItem extends StatelessWidget {
  final CourseInfo data;
  final VoidCallback onTap;

  const ExpertCourseItem({
    super.key,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TapEffect(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: DbCachedImageWidget(
                  imageUrl: data.courseCover ?? '',
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.courseName,
                      style: TMLabsTextStyle.bodyBold,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.courseTypeArray?.isNotEmpty == true
                          ? data.courseTypeArray!.first.label
                          : "Loại khóa học",
                      style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
                    ),
                    const Spacer(),
                    if (data.coursePrice > 0)
                      Text(
                        "¥${data.coursePrice.toInt()}",
                        style: TMLabsTextStyle.bodyBold.copyWith(color: Colors.red),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "Miễn phí",
                          style: TMLabsTextStyle.caption.copyWith(color: Colors.white, fontSize: 10),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
