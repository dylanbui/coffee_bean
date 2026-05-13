import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CheckboxFilter extends StatefulWidget {
  const CheckboxFilter({super.key, required this.value, this.assetName, this.selectedAssetName});

  final bool value;
  final String? assetName;
  final String? selectedAssetName;

  @override
  State<StatefulWidget> createState() => _CheckboxFilterState();
}

class _CheckboxFilterState extends State<CheckboxFilter> {
  _CheckboxFilterState();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: widget.value == true
            ? SvgPicture.asset(widget.selectedAssetName ?? 'assets/images/checkbox_selected.svg')
            : SvgPicture.asset(widget.assetName ?? 'assets/images/checkbox_normal.svg'),
      ),
    );
  }
}
