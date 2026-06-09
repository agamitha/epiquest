import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'word_finder_mod1_model.dart';
export 'word_finder_mod1_model.dart';

class WordFinderMod1Widget extends StatefulWidget {
  const WordFinderMod1Widget({super.key});

  static String routeName = 'WordFinderMod1';
  static String routePath = '/wordFinderMod1';

  @override
  State<WordFinderMod1Widget> createState() => _WordFinderMod1WidgetState();
}

class _WordFinderMod1WidgetState extends State<WordFinderMod1Widget> {
  late WordFinderMod1Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WordFinderMod1Model());

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
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(2.0, 0.0, 2.0, 0.0),
                child: AuthUserStreamWidget(
                  builder: (context) => Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: custom_widgets.WordFinder(
                      width: double.infinity,
                      height: double.infinity,
                      savedScore: valueOrDefault(
                          currentUserDocument?.module1Game3Score, 0),
                      onGameComplete: (scorePercent) async {
                        await currentUserReference!
                            .update(createUsersRecordData(
                          module1Game3Score: scorePercent,
                        ));
                      },
                      onNextGame: () async {
                        context.pushNamed(DragDropGameMod1Widget.routeName);
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
