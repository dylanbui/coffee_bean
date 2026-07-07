import 'package:coffee_bean/data/model/response/product/product_comment.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentReplyWidget extends StatelessWidget {
  final ProductComment comment;

  const CommentReplyWidget({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    final String? content = comment.replyContent;
    if (content == null || content.isEmpty) return const SizedBox.shrink();

    final String formattedDate = comment.replyTime != null 
        ? DateFormat('yyyy/MM/dd HH:mm').format(comment.replyTime!) 
        : "";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.reply, size: 16, color: TMLabsColor.primary),
                  const SizedBox(width: 6),
                  Text(
                    "Phản hồi của cửa hàng",
                    style: TMLabsTextStyle.bodyBold.copyWith(
                      color: TMLabsColor.primary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              if (formattedDate.isNotEmpty)
                Text(
                  formattedDate,
                  style: TMLabsTextStyle.caption.copyWith(fontSize: 11),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: TMLabsTextStyle.body.copyWith(
              color: Colors.black87,
              height: 1.4,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
