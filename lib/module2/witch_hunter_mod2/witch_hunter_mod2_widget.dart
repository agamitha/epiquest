import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'witch_hunter_mod2_model.dart';
export 'witch_hunter_mod2_model.dart';

/// Witch Hunter Game for Module2
class WitchHunterMod2Widget extends StatefulWidget {
  const WitchHunterMod2Widget({super.key});

  static String routeName = 'WitchHunterMod2';
  static String routePath = '/witchHunterMod2';

  @override
  State<WitchHunterMod2Widget> createState() => _WitchHunterMod2WidgetState();
}

class _WitchHunterMod2WidgetState extends State<WitchHunterMod2Widget> {
  late WitchHunterMod2Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WitchHunterMod2Model());

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
                child: custom_widgets.WitchHunter(
                  width: double.infinity,
                  height: double.infinity,
                  savedScore:
                      valueOrDefault(currentUserDocument?.module2Game2Score, 0),
                  onGameComplete: () async {
                    await currentUserReference!.update(createUsersRecordData(
                      module2Game2Score: 100,
                    ));
                  },
                  onNextGame: () async {
                    context.pushNamed(CrosswordGameMod2Widget.routeName);
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
    );
  }
}
