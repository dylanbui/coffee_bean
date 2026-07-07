import 'package:coffee_bean/data/model/response/hub/course_info.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';
import 'package:coffee_bean/utils/number_to_vietnamese.dart';

class InstructorCourseItem extends StatelessWidget {
  final CourseInfo data;
  final VoidCallback onTap;

  const InstructorCourseItem({
    super.key,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TapEffect(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              // Cover Image
              DbCachedImageWidget(
                imageUrl: data.courseCover,
                width: 120,
                height: 100,
                fit: BoxFit.cover,
              ),
              
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.courseName,
                        style: TMLabsTextStyle.bodyBold.copyWith(height: 1.2),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.courseDesc ?? "",
                        style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      _buildPrice(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrice() {
    if (data.coursePrice == 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: TMLabsColor.bgSecond,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          "Miễn phí",
          style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.primary, fontWeight: FontWeight.bold),
        ),
      );
    }
    
    return Text(
      "${NumberToVietnamese.formatNumber(data.coursePrice)} vnd",
      style: TMLabsTextStyle.bodyBold.copyWith(color: Colors.black, fontSize: 14),
    );
  }
}
