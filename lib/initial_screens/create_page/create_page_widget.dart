import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'create_page_model.dart';
export 'create_page_model.dart';

class CreatePageWidget extends StatefulWidget {
  const CreatePageWidget({super.key});

  static String routeName = 'createPage';
  static String routePath = '/createPage';

  @override
  State<CreatePageWidget> createState() => _CreatePageWidgetState();
}

class _CreatePageWidgetState extends State<CreatePageWidget> {
  late CreatePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreatePageModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: custom_widgets.CreateAccountPage(
            width: double.infinity,
            height: double.infinity,
            onCreateSuccess: () async {
              if (Navigator.of(context).canPop()) {
                context.pop();
              }
              context.pushNamed(LoginPageWidget.routeName);
            },
            onGoToLogin: () async {
              context.pushNamed(LoginPageWidget.routeName);
            },
          ),
        ),
      ),
    );
  }
}
