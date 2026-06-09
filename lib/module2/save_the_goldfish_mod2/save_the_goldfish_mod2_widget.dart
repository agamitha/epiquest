import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'save_the_goldfish_mod2_model.dart';
export 'save_the_goldfish_mod2_model.dart';

class SaveTheGoldfishMod2Widget extends StatefulWidget {
  const SaveTheGoldfishMod2Widget({super.key});

  static String routeName = 'SaveTheGoldfishMod2';
  static String routePath = '/saveTheGoldfishMod2';

  @override
  State<SaveTheGoldfishMod2Widget> createState() =>
      _SaveTheGoldfishMod2WidgetState();
}

class _SaveTheGoldfishMod2WidgetState extends State<SaveTheGoldfishMod2Widget> {
  late SaveTheGoldfishMod2Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SaveTheGoldfishMod2Model());

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
                  child: custom_widgets.SaveTheGoldfish(
                    width: double.infinity,
                    height: double.infinity,
                    savedScore: valueOrDefault(
                        currentUserDocument?.module2Game4Score, 0),
                    onGameComplete: (scorePercent) async {
                      await currentUserReference!.update(createUsersRecordData(
                        module2Game4Score: scorePercent,
                      ));
                    },
                    onNextGame: () async {},
                    onGoHome: () async {},
                    onBackToMenu: () async {},
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
