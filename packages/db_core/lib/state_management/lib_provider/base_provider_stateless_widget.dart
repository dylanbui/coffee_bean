
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:db_core/state_management/lib_provider/base_provider.dart';

//ignore: must_be_immutable
abstract class BaseProviderStateLessWidget<P extends BaseProvider> extends StatelessWidget {

  late P pageProvider;

  BaseProviderStateLessWidget({super.key});

  Widget getLayout(BuildContext context);

  @override
  Widget build(BuildContext context) {
    pageProvider = Provider.of<P>(context);
    return getLayout(context);
  }
}