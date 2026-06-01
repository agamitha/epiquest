import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'game_intro_mod2_model.dart';
export 'game_intro_mod2_model.dart';

/// Game Introductions for Module2
class GameIntroMod2Widget extends StatefulWidget {
  const GameIntroMod2Widget({super.key});

  static String routeName = 'GameIntroMod2';
  static String routePath = '/gameIntroMod2';

  @override
  State<GameIntroMod2Widget> createState() => _GameIntroMod2WidgetState();
}

class _GameIntroMod2WidgetState extends State<GameIntroMod2Widget> {
  late GameIntroMod2Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GameIntroMod2Model());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().mod2GameCompleted = true;
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
                height: 800.0,
                child: custom_widgets.GameIntroMod2(
                  width: double.infinity,
                  height: 800.0,
                  game1Score:
                      valueOrDefault(currentUserDocument?.module2Game1Score, 0),
                  game2Score:
                      valueOrDefault(currentUserDocument?.module2Game2Score, 0),
                  game3Score:
                      valueOrDefault(currentUserDocument?.module2Game3Score, 0),
                  game4Score:
                      valueOrDefault(currentUserDocument?.module2Game4Score, 0),
                  onPlayGame1: () async {
                    context.pushNamed(SaveThePrincesMod2Widget.routeName);
                  },
                  onPlayGame2: () async {
                    context.pushNamed(WitchHunterMod2Widget.routeName);
                  },
                  onPlayGame3: () async {
                    context.pushNamed(CrosswordGameMod2Widget.routeName);
                  },
                  onPlayGame4: () async {
                    context.pushNamed(SaveTheGoldfishMod2Widget.routeName);
                  },
                  onViewResults: () async {
                    context.pushNamed(GameCompletionMod2Widget.routeName);
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
    );
  }
}
