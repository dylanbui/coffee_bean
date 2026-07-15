import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

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
  final Function(String) onSave;
  final HtmlEditorStyleConfig? styleConfig;

  const HtmlEditorWidget({
    super.key,
    required this.initialHtml,
    required this.onSave,
    this.styleConfig,
  });

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
    // Lấy nội dung HTML từ editor
    String html = await _controller.getText();

    if (html.isNotEmpty) {
      // Regex lọc bỏ tag (img, video, iframe) lần cuối trước khi gửi về
      html = html.replaceAll(RegExp(r'<img[^>]*>', caseSensitive: false), '');
      html = html.replaceAll(RegExp(r'<video[^>]*>.*?</video>', caseSensitive: false, dotAll: true), '');
      html = html.replaceAll(RegExp(r'<iframe[^>]*>.*?</iframe>', caseSensitive: false, dotAll: true), '');
    }

    widget.onSave(html);

    if (mounted) {
      Navigator.pop(context);
    }
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
            toolbarType: ToolbarType.nativeScrollable,
            // Sử dụng màu sắc từ config đã được thiết lập
            buttonColor: _style.buttonColor,
            buttonSelectedColor: _style.buttonSelectedColor,
            dropdownBackgroundColor: _style.dropdownBackgroundColor,
            // Thêm nút Save vào Toolbar (kiêm luôn hành động Close)
            customToolbarButtons: [
              IconButton(
                icon: Icon(Icons.save, color: _style.saveButtonColor),
                onPressed: _saveContent,
                tooltip: "Save & Close",
              ),
            ],
            customToolbarInsertionIndices: const [0], // Đặt ở vị trí đầu tiên của Toolbar
            // Giới hạn chức năng: Bold, Underline, Font Size, Color và Paragraph
            defaultToolbarButtons: [
              const FontButtons(
                bold: true,
                italic: true,
                underline: true,
                clearAll: false,
              ),
              const FontSettingButtons(
                fontName: false,
                fontSize: true,
                fontSizeUnit: false,
              ),
              const ColorButtons(
                foregroundColor: true,
                highlightColor: true,
              ),
              const ParagraphButtons(
                alignLeft: true,
                alignCenter: true,
                alignRight: true,
                alignJustify: true,
              ),
              const ListButtons(
                ul: true,
                ol: true,
                listStyles: false,
              ),
              const OtherButtons(
                undo: true,
                redo: true,
                fullscreen: false,
                codeview: false,
                help: false,
              ),
            ],
          ),
          callbacks: Callbacks(
            onInit: () {
              // Giải pháp triệt để: Inject JS trực tiếp để xử lý màu nền và lọc nội dung khi paste
              
              // Lấy mã HEX của màu nền để inject vào CSS của editor
              final hexColor = '#${_style.editorBackgroundColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
              
              _controller.editorController?.evaluateJavascript(source: """
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
              """);
            },
          ),
          otherOptions: OtherOptions(
            // Tính toán chiều cao full màn hình sau khi trừ SafeArea
            height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
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
