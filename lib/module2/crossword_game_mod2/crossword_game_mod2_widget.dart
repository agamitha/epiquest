import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'crossword_game_mod2_model.dart';
export 'crossword_game_mod2_model.dart';

class CrosswordGameMod2Widget extends StatefulWidget {
  const CrosswordGameMod2Widget({super.key});

  static String routeName = 'CrosswordGameMod2';
  static String routePath = '/crosswordGameMod2';

  @override
  State<CrosswordGameMod2Widget> createState() =>
      _CrosswordGameMod2WidgetState();
}

class _CrosswordGameMod2WidgetState extends State<CrosswordGameMod2Widget> {
  late CrosswordGameMod2Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CrosswordGameMod2Model());

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
                  child: custom_widgets.CrosswordGridMod2(
                    width: double.infinity,
                    height: double.infinity,
                    savedScore: valueOrDefault(
                        currentUserDocument?.module2Game3Score, 0),
                    onGameComplete: (scorePercent) async {
                      await currentUserReference!.update(createUsersRecordData(
                        module2Game3Score: scorePercent,
                      ));
                    },
                    onNextGame: () async {
                      context.pushNamed(SaveTheGoldfishMod2Widget.routeName);
                    },
                    onGoHome: () async {
                      context.pushNamed(HomePageWidget.routeName);
                    },
                    onBackToMenu: () async {
                      context.pushNamed(GameIntroMod2Widget.routeName);
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
