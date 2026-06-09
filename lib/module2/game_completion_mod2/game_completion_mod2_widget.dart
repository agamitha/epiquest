import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'game_completion_mod2_model.dart';
export 'game_completion_mod2_model.dart';

class GameCompletionMod2Widget extends StatefulWidget {
  const GameCompletionMod2Widget({super.key});

  static String routeName = 'GameCompletionMod2';
  static String routePath = '/gameCompletionMod2';

  @override
  State<GameCompletionMod2Widget> createState() =>
      _GameCompletionMod2WidgetState();
}

class _GameCompletionMod2WidgetState extends State<GameCompletionMod2Widget> {
  late GameCompletionMod2Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GameCompletionMod2Model());

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
                builder: (context) => InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    await currentUserReference!.update(createUsersRecordData(
                      email: '',
                    ));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 800.0,
                    child: custom_widgets.GameCompletionMod2(
                      width: double.infinity,
                      height: 800.0,
                      game1Score: valueOrDefault(
                          currentUserDocument?.module2Game1Score, 0),
                      game2Score: valueOrDefault(
                          currentUserDocument?.module2Game2Score, 0),
                      game3Score: valueOrDefault(
                          currentUserDocument?.module2Game3Score, 0),
                      game4Score: valueOrDefault(
                          currentUserDocument?.module2Game4Score, 0),
                      onBackToHome: () async {
                        context.pushNamed(HomePageWidget.routeName);
                      },
                      onPlayFinalGame: () async {
                        context.pushNamed(FirewaterbalanceWidget.routeName);
                      },
                    ),
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
