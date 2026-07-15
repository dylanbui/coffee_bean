import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

/// Interface cho các sự kiện của HtmlEditor
abstract class HtmlEditorListener {
  void onSaved(String html);
}

/// Class cấu hình màu sắc dùng chung cho HtmlEditor tuân thủ TMLab Design System
class HtmlEditorStyleConfig {
  final Color buttonColor;
  final Color buttonSelectedColor;
  final Color dropdownBackgroundColor;
  final Color editorBackgroundColor;
  final Color borderColor;
  final Color saveButtonColor;

  const HtmlEditorStyleConfig({
    required this.buttonColor,
    required this.buttonSelectedColor,
    required this.dropdownBackgroundColor,
    required this.editorBackgroundColor,
    required this.borderColor,
    required this.saveButtonColor,
  });

  /// Cấu hình chuẩn TMLab theo Design System
  static HtmlEditorStyleConfig get tmlab => const HtmlEditorStyleConfig(
    buttonColor: TMLabsColor.grey,
    buttonSelectedColor: TMLabsColor.primary,
    dropdownBackgroundColor: Colors.white,
    editorBackgroundColor: Colors.white,
    borderColor: TMLabsColor.lightGrey,
    saveButtonColor: TMLabsColor.success,
  );
}

class HtmlEditorWidget extends StatefulWidget {
  final String initialHtml;
  final HtmlEditorListener listener;
  final HtmlEditorStyleConfig? styleConfig;

  const HtmlEditorWidget({super.key, required this.initialHtml, required this.listener, this.styleConfig});

  @override
  State<HtmlEditorWidget> createState() => _HtmlEditorWidgetState();
}

class _HtmlEditorWidgetState extends State<HtmlEditorWidget> {
  late HtmlEditorController _controller;
  late HtmlEditorStyleConfig _style;

  @override
  void initState() {
    super.initState();
    _controller = HtmlEditorController();
    // Ưu tiên config từ bên ngoài, nếu không dùng chuẩn TMLab
    _style = widget.styleConfig ?? HtmlEditorStyleConfig.tmlab;
  }

  void _saveContent() async {
    // Ép WebView ẩn bàn phím trước khi lấy dữ liệu
    _controller.clearFocus();

    // Lấy nội dung HTML từ editor
    String html = await _controller.getText();

    if (html.isNotEmpty) {
      // Regex lọc bỏ tag (img, video, iframe) lần cuối trước khi gửi về
      html = html.replaceAll(RegExp(r'<img[^>]*>', caseSensitive: false), '');
      html = html.replaceAll(RegExp(r'<video[^>]*>.*?</video>', caseSensitive: false, dotAll: true), '');
      html = html.replaceAll(RegExp(r'<iframe[^>]*>.*?</iframe>', caseSensitive: false, dotAll: true), '');
    }

    widget.listener.onSaved(html);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _style.editorBackgroundColor,
      body: SafeArea(
        child: HtmlEditor(
          controller: _controller,
          htmlEditorOptions: HtmlEditorOptions(
            hint: 'Nhập nội dung...',
            initialText: widget.initialHtml,
            shouldEnsureVisible: true,
            autoAdjustHeight: true,
          ),
          htmlToolbarOptions: HtmlToolbarOptions(
            toolbarPosition: ToolbarPosition.aboveEditor,
            toolbarType: ToolbarType.nativeGrid, // Hiển thị lưới để tự động xuống dòng
            
            gridViewHorizontalSpacing: 0,
            gridViewVerticalSpacing: 0,

            // Sử dụng màu sắc từ config đã được thiết lập
            buttonColor: _style.buttonColor,
            buttonSelectedColor: _style.buttonSelectedColor,
            dropdownBackgroundColor: _style.dropdownBackgroundColor,
            // Gộp các nút Save, Undo, Redo, Bold, Italic, Underline vào 1 ô để dồn hàng (tổng cộng 6 ô = 2 hàng)
            customToolbarButtons: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.save, color: _style.saveButtonColor),
                    onPressed: _saveContent,
                    tooltip: "Save & Close",
                  ),
                  IconButton(
                    icon: Icon(Icons.undo, color: _style.buttonColor),
                    onPressed: () => _controller.undo(),
                    tooltip: "Undo",
                  ),
                  IconButton(
                    icon: Icon(Icons.redo, color: _style.buttonColor),
                    onPressed: () => _controller.redo(),
                    tooltip: "Redo",
                  ),
                  const SizedBox(width: 4),
                  Container(width: 1, height: 24, color: TMLabsColor.lightGrey),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: Icon(Icons.format_bold, color: _style.buttonColor),
                    onPressed: () => _controller.execCommand('bold'),
                    tooltip: "Bold",
                  ),
                  IconButton(
                    icon: Icon(Icons.format_italic, color: _style.buttonColor),
                    onPressed: () => _controller.execCommand('italic'),
                    tooltip: "Italic",
                  ),
                  IconButton(
                    icon: Icon(Icons.format_underlined, color: _style.buttonColor),
                    onPressed: () => _controller.execCommand('underline'),
                    tooltip: "Underline",
                  ),
                ],
              ),
            ],
            customToolbarInsertionIndices: const [0], // Đặt ở vị trí đầu tiên của Toolbar
            // Giới hạn chức năng: Font Size, Color và Paragraph...
            defaultToolbarButtons: [
              // OtherButtons và FontButtons đã được gộp vào customToolbarButtons ở trên
              const FontSettingButtons(fontName: false, fontSize: true, fontSizeUnit: false),
              const ColorButtons(foregroundColor: true, highlightColor: true),
              const ParagraphButtons(
                alignLeft: true,
                alignCenter: true,
                alignRight: true,
                alignJustify: false,
                increaseIndent: false,
                decreaseIndent: false,
                textDirection: false,
                lineHeight: false,
                caseConverter: false,
              ),
              const ListButtons(ul: true, ol: true, listStyles: false),
              const InsertButtons(
                table: true,
                link: true,
                hr: true,
                audio: false,
                picture: false, // Tắt vì đã có logic lọc bỏ img
                video: false, // Tắt vì đã có logic lọc bỏ video
                otherFile: false,
              ),
            ],
          ),
          callbacks: Callbacks(
            onInit: () {
              // Giải pháp triệt để: Inject JS trực tiếp để xử lý màu nền và lọc nội dung khi paste

              // Lấy mã HEX của màu nền để inject vào CSS của editor
              final hexColor =
                  '#${_style.editorBackgroundColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';

              _controller.editorController?.evaluateJavascript(
                source:
                    """
                // Cấu hình màu nền cho body editor để đồng bộ với Flutter UI
                document.querySelector('.note-editable').style.backgroundColor = '$hexColor';
                
                // Lọc nội dung ngay khi người dùng paste để chặn img, video, iframe
                document.querySelector('.note-editable').addEventListener('paste', function (e) {
                  var clipboardData = e.clipboardData || window.clipboardData;
                  var html = clipboardData.getData('text/html');
                  if (html && (html.includes('<img') || html.includes('<video') || html.includes('<iframe'))) {
                    e.preventDefault(); 
                    var div = document.createElement('div');
                    div.innerHTML = html;
                    var elements = div.querySelectorAll('img, video, iframe');
                    elements.forEach(el => el.remove());
                    document.execCommand('insertHTML', false, div.innerHTML);
                  }
                });
              """,
              );
            },
          ),
          otherOptions: OtherOptions(
            // Tính toán chiều cao full màn hình sau khi trừ SafeArea
            height:
                MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom,
            decoration: BoxDecoration(
              color: _style.editorBackgroundColor,
              border: Border.all(color: _style.borderColor),
            ),
          ),
        ),
      ),
    );
  }
}
