import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'game_completion_mod1_model.dart';
export 'game_completion_mod1_model.dart';

class GameCompletionMod1Widget extends StatefulWidget {
  const GameCompletionMod1Widget({super.key});

  static String routeName = 'GameCompletionMod1';
  static String routePath = '/gameCompletionMod1';

  @override
  State<GameCompletionMod1Widget> createState() =>
      _GameCompletionMod1WidgetState();
}

class _GameCompletionMod1WidgetState extends State<GameCompletionMod1Widget> {
  late GameCompletionMod1Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GameCompletionMod1Model());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().module1Complete = true;
      safeSetState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

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
                child: custom_widgets.GameCompletionMod1(
                  width: double.infinity,
                  height: double.infinity,
                  game1Score:
                      valueOrDefault(currentUserDocument?.module1Game1Score, 0),
                  game2Score:
                      valueOrDefault(currentUserDocument?.module1Game2Score, 0),
                  game3Score:
                      valueOrDefault(currentUserDocument?.module1Game3Score, 0),
                  game4Score:
                      valueOrDefault(currentUserDocument?.module1Game4Score, 0),
                  onBackToHome: () async {
                    await currentUserReference!.update(createUsersRecordData(
                      module1Completed: true,
                    ));

                    context.pushNamed(HomePageWidget.routeName);
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
