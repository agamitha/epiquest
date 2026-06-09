import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await actions.startSessionListener(
        valueOrDefault(currentUserDocument?.sessionCode, ''),
        () async {
          if (Navigator.of(context).canPop()) {
            context.pop();
          }
          context.pushNamed(SessionEndedPageWidget.routeName);
        },
      );
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
    return StreamBuilder<List<UsersRecord>>(
      stream: queryUsersRecord(
        queryBuilder: (usersRecord) => usersRecord.where(
          'uid',
          isEqualTo: currentUserUid,
        ),
        singleRecord: true,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }
        List<UsersRecord> homePageUsersRecordList = snapshot.data!;
        // Return an empty Container when the item does not exist.
        if (snapshot.data!.isEmpty) {
          return Container();
        }
        final homePageUsersRecord = homePageUsersRecordList.isNotEmpty
            ? homePageUsersRecordList.first
            : null;

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
                      child: custom_widgets.HomePage(
                        width: double.infinity,
                        height: double.infinity,
                        displayName: currentUserDisplayName,
                        module1LessonDone:
                            homePageUsersRecord?.module1LessonDone,
                        module1Completed: homePageUsersRecord?.module1Completed,
                        module2LessonDone:
                            homePageUsersRecord?.module2LessonDone,
                        module2Completed: homePageUsersRecord?.module2Completed,
                        module1AvgScore: valueOrDefault(
                            currentUserDocument?.module1AvgScore, 0),
                        module1Game1Score: valueOrDefault(
                            currentUserDocument?.module1Game1Score, 0),
                        module1Game2Score: valueOrDefault(
                            currentUserDocument?.module1Game2Score, 0),
                        module1Game3Score: valueOrDefault(
                            currentUserDocument?.module1Game3Score, 0),
                        module1Game4Score: valueOrDefault(
                            currentUserDocument?.module1Game4Score, 0),
                        onGoToMod1Lesson: () async {
                          context.pushNamed(Mod1LessonsWidget.routeName);
                        },
                        onGoToMod1Games: () async {
                          context.pushNamed(GameIntroMod1Widget.routeName);
                        },
                        onGoToMod2Lesson: () async {
                          context.pushNamed(Mod2LessonsWidget.routeName);
                        },
                        onGoToMod2Games: () async {
                          context.pushNamed(GameIntroMod2Widget.routeName);
                        },
                        onGoToFinalGame: () async {
                          context.pushNamed(FirewaterbalanceWidget.routeName);
                        },
                        onLogout: () async {
                          GoRouter.of(context).prepareAuthEvent();
                          await authManager.signOut();
                          GoRouter.of(context).clearRedirectLocation();

                          if (Navigator.of(context).canPop()) {
                            context.pop();
                          }
                          context.pushNamedAuth(
                              LoginPageWidget.routeName, context.mounted);
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
                        sessionCode: valueOrDefault(
                            currentUserDocument?.sessionCode, ''),
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
      },
    );
  }
}
