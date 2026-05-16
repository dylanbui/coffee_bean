import 'dart:io';
import 'package:coffee_bean/core/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/cubit_statefull_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // This import might be wrong if it's flutter_bloc.dart
import 'package:image_picker/image_picker.dart';
import 'package:coffee_bean/shared/widget/image_wechat_picker_list_view.dart';
import 'problem_report_interactor.dart';
import 'problem_report_event_state.dart';

//ignore: must_be_immutable
class ProblemReportPage extends CubitStateFulWidget<ProblemReportInteractor, ProblemReportState> {
  ProblemReportPage({super.key, required super.interactor});

  @override
  State<ProblemReportPage> createState() => _ProblemReportPageState();
}

class _ProblemReportPageState extends CubitState<ProblemReportPage, ProblemReportInteractor, ProblemReportState> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  dynamic getAppBar(BuildContext context) => "Problems Report";

  @override
  Widget getBody(BuildContext context) {
    return BlocConsumer<ProblemReportInteractor, ProblemReportState>(
      listener: (context, state) {
        if (state is ProblemReportSuccess) {
          _textController.clear(); // Xóa sạch textarea khi thành công
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Problem Report Success"), backgroundColor: Colors.green),
          );
          // Navigator.of(context).pop();
        } else if (state is ProblemReportError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextArea(state),
              const SizedBox(height: 20),
              ImageWechatPickerListView(
                images: state.images,
                maxImages: 5,
                onImagesPicked: interactor.onImagesPicked,
                onRemoveImage: interactor.removeImage,
              ),
              const SizedBox(height: 40),
              _buildSubmitButton(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextArea(ProblemReportState state) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          TextField(
            controller: _textController,
            maxLines: 6,
            maxLength: 1000,
            style: const TextStyle(fontSize: 14),
            decoration: const InputDecoration(
              hintText: "Nhập thông tin",
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              border: InputBorder.none,
              counterText: "", 
            ),
            onChanged: interactor.onTextChanged,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "${state.text.length}/1000",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSubmitButton(ProblemReportState state) {
    bool isSubmitting = state is ProblemReportSubmitting;
    bool isValid = state.text.isNotEmpty;
    
    return ElevatedButton(
      onPressed: (isValid && !isSubmitting) ? interactor.submitReport : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey[300],
        disabledForegroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: isSubmitting 
          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : const Text("Gửi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
