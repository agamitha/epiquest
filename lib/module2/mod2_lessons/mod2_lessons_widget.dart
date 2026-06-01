import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'mod2_lessons_model.dart';
export 'mod2_lessons_model.dart';

class Mod2LessonsWidget extends StatefulWidget {
  const Mod2LessonsWidget({super.key});

  static String routeName = 'mod2Lessons';
  static String routePath = '/mod2Lessons';

  @override
  State<Mod2LessonsWidget> createState() => _Mod2LessonsWidgetState();
}

class _Mod2LessonsWidgetState extends State<Mod2LessonsWidget> {
  late Mod2LessonsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Mod2LessonsModel());

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
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: custom_widgets.Module2Lessons(
                width: double.infinity,
                height: double.infinity,
                onDone: () async {
                  context.pushNamed(GameIntroMod2Widget.routeName);
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
    );
  }
}
