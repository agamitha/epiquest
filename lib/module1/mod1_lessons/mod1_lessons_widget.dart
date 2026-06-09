import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'mod1_lessons_model.dart';
export 'mod1_lessons_model.dart';

class Mod1LessonsWidget extends StatefulWidget {
  const Mod1LessonsWidget({super.key});

  static String routeName = 'mod1Lessons';
  static String routePath = '/mod1Lessons';

  @override
  State<Mod1LessonsWidget> createState() => _Mod1LessonsWidgetState();
}

class _Mod1LessonsWidgetState extends State<Mod1LessonsWidget> {
  late Mod1LessonsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Mod1LessonsModel());

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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                child: custom_widgets.Module1Lessons(
                  width: double.infinity,
                  height: double.infinity,
                  onDone: () async {
                    context.pushNamed(GameIntroMod1Widget.routeName);
                  },
                  onBack: () async {
                    context.pushNamed(HomePageWidget.routeName);
                  },
                ),
              ),
              AuthUserStreamWidget(
                builder: (context) => Container(
                  width: 1.0,
                  height: 1.0,
                  child: custom_widgets.SessionMonitor(
                    width: 1.0,
                    height: 1.0,
                    sessionCode:
                        valueOrDefault(currentUserDocument?.sessionCode, ''),
                    onSessionEnded: () async {
                      context.goNamed(SessionEndedPageWidget.routeName);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
