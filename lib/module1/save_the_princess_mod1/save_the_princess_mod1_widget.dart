import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'save_the_princess_mod1_model.dart';
export 'save_the_princess_mod1_model.dart';

class SaveThePrincessMod1Widget extends StatefulWidget {
  const SaveThePrincessMod1Widget({super.key});

  static String routeName = 'SaveThePrincessMod1';
  static String routePath = '/saveThePrincessMod1';

  @override
  State<SaveThePrincessMod1Widget> createState() =>
      _SaveThePrincessMod1WidgetState();
}

class _SaveThePrincessMod1WidgetState extends State<SaveThePrincessMod1Widget> {
  late SaveThePrincessMod1Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SaveThePrincessMod1Model());

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
            AuthUserStreamWidget(
              builder: (context) => Container(
                width: double.infinity,
                height: double.infinity,
                child: custom_widgets.SaveThePrincessMod1(
                  width: double.infinity,
                  height: double.infinity,
                  savedScore:
                      valueOrDefault(currentUserDocument?.module1Game1Score, 0),
                  onGameComplete: (scorePercent) async {
                    await currentUserReference!.update(createUsersRecordData(
                      module1Game1Score: scorePercent,
                    ));
                  },
                  onNextGame: () async {
                    context.pushNamed(CrosswordGameMod1Widget.routeName);
                  },
                  onReviewContent: () async {
                    context.pushNamed(Mod1LessonsWidget.routeName);
                  },
                  onGoHome: () async {
                    context.pushNamed(HomePageWidget.routeName);
                  },
                  onBackToMenu: () async {
                    context.pushNamed(GameIntroMod1Widget.routeName);
                  },
                ),
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
