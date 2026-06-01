import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'login_page_model.dart';
export 'login_page_model.dart';

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({super.key});

  static String routeName = 'loginPage';
  static String routePath = '/loginPage';

  @override
  State<LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  late LoginPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginPageModel());

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
          child: custom_widgets.SignInPage(
            width: double.infinity,
            height: double.infinity,
            onLoginSuccess: () async {
              if (Navigator.of(context).canPop()) {
                context.pop();
              }
              context.pushNamed(HomePageWidget.routeName);
            },
            onGoToSignUp: () async {
              context.pushNamed(CreatePageWidget.routeName);
            },
            onAdminLoginSuccess: () async {
              if (Navigator.of(context).canPop()) {
                context.pop();
              }
              context.pushNamed(AdminPanelWidget.routeName);
            },
          ),
        ),
      ),
    );
  }
}
