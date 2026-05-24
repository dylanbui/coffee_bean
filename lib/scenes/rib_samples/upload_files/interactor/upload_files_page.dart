import 'package:db_core/architecture_ribs/note_viewer.dart';
import 'package:db_core/state_management/lib_bloc/cubit_statefull_widget.dart';
import 'package:coffee_bean/scenes/rib_samples/upload_files/interactor/upload_files_event_state.dart';
import 'package:coffee_bean/scenes/rib_samples/upload_files/interactor/upload_files_interactor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The UI page for the UploadFiles module.
//ignore: must_be_immutable
class UploadFilesPage extends CubitStateFulWidget<UploadFilesInteractor, UploadFilesState> with ViewControllable {
  UploadFilesPage({super.key, required super.interactor});

  @override
  State<UploadFilesPage> createState() => _UploadFilesPageState();
}

class _UploadFilesPageState extends CubitState<UploadFilesPage, UploadFilesInteractor, UploadFilesState> {
  String? _selectedFilePath; // Placeholder for selected file path

  @override
  dynamic getAppBar(BuildContext context) => "Upload Files Demo";

  @override
  Widget getBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocConsumer<UploadFilesInteractor, UploadFilesState>(
        listener: (context, state) {
          if (state is UploadFilesSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
          } else if (state is UploadFilesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_selectedFilePath != null)
                Text("Selected file: ${_selectedFilePath!.split('/').last}"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // TODO: Implement actual file picking using a package like `file_picker`
                  // For now, we'll simulate a file path.
                  setState(() {
                    _selectedFilePath = "/data/user/0/com.dylanbui.coffee_bean/cache/my_image.jpg"; // Mock path
                  });
                },
                child: const Text("Select File"),
              ),
              const SizedBox(height: 20),
              if (state is UploadFilesInProgress)
                const CircularProgressIndicator(),
              if (state is UploadFilesProgress)
                Column(
                  children: [
                    LinearProgressIndicator(value: state.progress),
                    Text('${(state.progress * 100).toStringAsFixed(0)}%'),
                  ],
                ),
              if (state is UploadFilesSuccess)
                const Icon(Icons.check_circle, color: Colors.green, size: 50),
              if (state is UploadFilesError)
                const Icon(Icons.error, color: Colors.red, size: 50),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _selectedFilePath != null && state is! UploadFilesInProgress
                    ? () => interactor.uploadFile(_selectedFilePath!)
                    : null,
                child: const Text("Upload File"),
              ),
              const SizedBox(height: 10),
              if (state is! UploadFilesInitial && state is! UploadFilesInProgress)
                TextButton(
                  onPressed: () {
                    interactor.resetState();
                    setState(() {
                      _selectedFilePath = null;
                    });
                  },
                  child: const Text("Reset"),
                ),
              const SizedBox(height: 20),
              _buildStateMessage(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStateMessage(UploadFilesState state) {
    if (state is UploadFilesInitial) {
      return const Text("Select a file to upload.");
    } else if (state is UploadFilesInProgress) {
      return const Text("Upload in progress...");
    } else if (state is UploadFilesProgress) {
      return Text("Uploading: ${(state.progress * 100).toStringAsFixed(0)}%");
    } else if (state is UploadFilesSuccess) {
      return Text("Success: ${state.message}");
    } else if (state is UploadFilesError) {
      return Text("Error: ${state.error.message}");
    }
    return const SizedBox.shrink();
  }
}
