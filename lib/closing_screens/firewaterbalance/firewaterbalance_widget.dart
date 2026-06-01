import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'firewaterbalance_model.dart';
export 'firewaterbalance_model.dart';

class FirewaterbalanceWidget extends StatefulWidget {
  const FirewaterbalanceWidget({super.key});

  static String routeName = 'firewaterbalance';
  static String routePath = '/firewaterbalance';

  @override
  State<FirewaterbalanceWidget> createState() => _FirewaterbalanceWidgetState();
}

class _FirewaterbalanceWidgetState extends State<FirewaterbalanceWidget> {
  late FirewaterbalanceModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FirewaterbalanceModel());

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
            Container(
              width: double.infinity,
              height: 800.0,
              child: custom_widgets.FireWaterBalance(
                width: double.infinity,
                height: 800.0,
                onGameComplete: () async {
                  await currentUserReference!.update(createUsersRecordData(
                    module2Completed: true,
                  ));
                },
                onGoHome: () async {
                  context.pushNamed(HomePageWidget.routeName);
                },
                onBackToHome: () async {
                  context.pushNamed(HomePageWidget.routeName);
                },
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
