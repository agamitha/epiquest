import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'crossword_game_mod1_model.dart';
export 'crossword_game_mod1_model.dart';

class CrosswordGameMod1Widget extends StatefulWidget {
  const CrosswordGameMod1Widget({super.key});

  static String routeName = 'CrosswordGameMod1';
  static String routePath = '/crosswordGameMod1';

  @override
  State<CrosswordGameMod1Widget> createState() =>
      _CrosswordGameMod1WidgetState();
}

class _CrosswordGameMod1WidgetState extends State<CrosswordGameMod1Widget> {
  late CrosswordGameMod1Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CrosswordGameMod1Model());

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
              AuthUserStreamWidget(
                builder: (context) => Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: custom_widgets.CrosswordGameMod1(
                    width: double.infinity,
                    height: double.infinity,
                    savedScore: valueOrDefault(
                        currentUserDocument?.module1Game2Score, 0),
                    onGameComplete: (scorePercent) async {
                      await currentUserReference!.update(createUsersRecordData(
                        module1Game2Score: scorePercent,
                      ));
                    },
                    onNextGame: () async {
                      context.pushNamed(WordFinderMod1Widget.routeName);
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
      ),
    );
  }
}
