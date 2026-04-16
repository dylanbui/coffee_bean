
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './architecture_ribs/note_router.dart';
import 'state_management/base_provider.dart';
import 'coordinator/constants.dart';

//ignore: must_be_immutable
abstract class BaseStateLessWidget<P extends BaseProvider> extends StatelessWidget {

  late P pageProvider;
  DbNavigation? nav;
  DbNoteRouter? router;

  BaseStateLessWidget({super.key, this.nav, this.router});

  Widget getLayout(BuildContext context);

  @override
  Widget build(BuildContext context) {
    pageProvider = Provider.of<P>(context);
    return getLayout(context);
  }
}