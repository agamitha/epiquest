import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'game_intro_mod1_model.dart';
export 'game_intro_mod1_model.dart';

/// Game Introductions for Module1
class GameIntroMod1Widget extends StatefulWidget {
  const GameIntroMod1Widget({super.key});

  static String routeName = 'GameIntroMod1';
  static String routePath = '/gameIntroMod1';

  @override
  State<GameIntroMod1Widget> createState() => _GameIntroMod1WidgetState();
}

class _GameIntroMod1WidgetState extends State<GameIntroMod1Widget> {
  late GameIntroMod1Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GameIntroMod1Model());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().mod1GameCompleted = true;
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
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              AuthUserStreamWidget(
                builder: (context) => Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: custom_widgets.GameIntroMod1(
                    width: double.infinity,
                    height: double.infinity,
                    game1Score: valueOrDefault(
                        currentUserDocument?.module1Game1Score, 0),
                    game2Score: valueOrDefault(
                        currentUserDocument?.module1Game2Score, 0),
                    game3Score: valueOrDefault(
                        currentUserDocument?.module1Game3Score, 0),
                    game4Score: valueOrDefault(
                        currentUserDocument?.module1Game4Score, 0),
                    onPlayGame1: () async {
                      context.pushNamed(SaveThePrincessMod1Widget.routeName);
                    },
                    onPlayGame2: () async {
                      context.pushNamed(CrosswordGameMod1Widget.routeName);
                    },
                    onPlayGame3: () async {
                      context.pushNamed(WordFinderMod1Widget.routeName);
                    },
                    onPlayGame4: () async {
                      context.pushNamed(DragDropGameMod1Widget.routeName);
                    },
                    onViewResults: () async {
                      context.pushNamed(GameCompletionMod1Widget.routeName);
                    },
                    onGoHome: () async {
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
      ),
    );
  }
}
