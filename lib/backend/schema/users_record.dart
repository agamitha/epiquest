import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "module1Completed" field.
  bool? _module1Completed;
  bool get module1Completed => _module1Completed ?? false;
  bool hasModule1Completed() => _module1Completed != null;

  // "module2Completed" field.
  bool? _module2Completed;
  bool get module2Completed => _module2Completed ?? false;
  bool hasModule2Completed() => _module2Completed != null;

  // "module1Score" field.
  int? _module1Score;
  int get module1Score => _module1Score ?? 0;
  bool hasModule1Score() => _module1Score != null;

  // "module2Score" field.
  int? _module2Score;
  int get module2Score => _module2Score ?? 0;
  bool hasModule2Score() => _module2Score != null;

  // "module1HintsUsed" field.
  int? _module1HintsUsed;
  int get module1HintsUsed => _module1HintsUsed ?? 0;
  bool hasModule1HintsUsed() => _module1HintsUsed != null;

  // "module2HintsUsed" field.
  int? _module2HintsUsed;
  int get module2HintsUsed => _module2HintsUsed ?? 0;
  bool hasModule2HintsUsed() => _module2HintsUsed != null;

  // "studyGroup" field.
  String? _studyGroup;
  String get studyGroup => _studyGroup ?? '';
  bool hasStudyGroup() => _studyGroup != null;

  // "module1LessonDone" field.
  bool? _module1LessonDone;
  bool get module1LessonDone => _module1LessonDone ?? false;
  bool hasModule1LessonDone() => _module1LessonDone != null;

  // "module2LessonDone" field.
  bool? _module2LessonDone;
  bool get module2LessonDone => _module2LessonDone ?? false;
  bool hasModule2LessonDone() => _module2LessonDone != null;

  // "module1Game1Score" field.
  int? _module1Game1Score;
  int get module1Game1Score => _module1Game1Score ?? 0;
  bool hasModule1Game1Score() => _module1Game1Score != null;

  // "module1Game2Score" field.
  int? _module1Game2Score;
  int get module1Game2Score => _module1Game2Score ?? 0;
  bool hasModule1Game2Score() => _module1Game2Score != null;

  // "module1Game3Score" field.
  int? _module1Game3Score;
  int get module1Game3Score => _module1Game3Score ?? 0;
  bool hasModule1Game3Score() => _module1Game3Score != null;

  // "module1Game4Score" field.
  int? _module1Game4Score;
  int get module1Game4Score => _module1Game4Score ?? 0;
  bool hasModule1Game4Score() => _module1Game4Score != null;

  // "module1AvgScore" field.
  int? _module1AvgScore;
  int get module1AvgScore => _module1AvgScore ?? 0;
  bool hasModule1AvgScore() => _module1AvgScore != null;

  // "module2Game1Score" field.
  int? _module2Game1Score;
  int get module2Game1Score => _module2Game1Score ?? 0;
  bool hasModule2Game1Score() => _module2Game1Score != null;

  // "module2Game2Score" field.
  int? _module2Game2Score;
  int get module2Game2Score => _module2Game2Score ?? 0;
  bool hasModule2Game2Score() => _module2Game2Score != null;

  // "module2Game3Score" field.
  int? _module2Game3Score;
  int get module2Game3Score => _module2Game3Score ?? 0;
  bool hasModule2Game3Score() => _module2Game3Score != null;

  // "module2Game4Score" field.
  int? _module2Game4Score;
  int get module2Game4Score => _module2Game4Score ?? 0;
  bool hasModule2Game4Score() => _module2Game4Score != null;

  // "module2AvgScore" field.
  int? _module2AvgScore;
  int get module2AvgScore => _module2AvgScore ?? 0;
  bool hasModule2AvgScore() => _module2AvgScore != null;

  // "sessionCode" field.
  String? _sessionCode;
  String get sessionCode => _sessionCode ?? '';
  bool hasSessionCode() => _sessionCode != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _module1Completed = snapshotData['module1Completed'] as bool?;
    _module2Completed = snapshotData['module2Completed'] as bool?;
    _module1Score = castToType<int>(snapshotData['module1Score']);
    _module2Score = castToType<int>(snapshotData['module2Score']);
    _module1HintsUsed = castToType<int>(snapshotData['module1HintsUsed']);
    _module2HintsUsed = castToType<int>(snapshotData['module2HintsUsed']);
    _studyGroup = snapshotData['studyGroup'] as String?;
    _module1LessonDone = snapshotData['module1LessonDone'] as bool?;
    _module2LessonDone = snapshotData['module2LessonDone'] as bool?;
    _module1Game1Score = castToType<int>(snapshotData['module1Game1Score']);
    _module1Game2Score = castToType<int>(snapshotData['module1Game2Score']);
    _module1Game3Score = castToType<int>(snapshotData['module1Game3Score']);
    _module1Game4Score = castToType<int>(snapshotData['module1Game4Score']);
    _module1AvgScore = castToType<int>(snapshotData['module1AvgScore']);
    _module2Game1Score = castToType<int>(snapshotData['module2Game1Score']);
    _module2Game2Score = castToType<int>(snapshotData['module2Game2Score']);
    _module2Game3Score = castToType<int>(snapshotData['module2Game3Score']);
    _module2Game4Score = castToType<int>(snapshotData['module2Game4Score']);
    _module2AvgScore = castToType<int>(snapshotData['module2AvgScore']);
    _sessionCode = snapshotData['sessionCode'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  bool? module1Completed,
  bool? module2Completed,
  int? module1Score,
  int? module2Score,
  int? module1HintsUsed,
  int? module2HintsUsed,
  String? studyGroup,
  bool? module1LessonDone,
  bool? module2LessonDone,
  int? module1Game1Score,
  int? module1Game2Score,
  int? module1Game3Score,
  int? module1Game4Score,
  int? module1AvgScore,
  int? module2Game1Score,
  int? module2Game2Score,
  int? module2Game3Score,
  int? module2Game4Score,
  int? module2AvgScore,
  String? sessionCode,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'module1Completed': module1Completed,
      'module2Completed': module2Completed,
      'module1Score': module1Score,
      'module2Score': module2Score,
      'module1HintsUsed': module1HintsUsed,
      'module2HintsUsed': module2HintsUsed,
      'studyGroup': studyGroup,
      'module1LessonDone': module1LessonDone,
      'module2LessonDone': module2LessonDone,
      'module1Game1Score': module1Game1Score,
      'module1Game2Score': module1Game2Score,
      'module1Game3Score': module1Game3Score,
      'module1Game4Score': module1Game4Score,
      'module1AvgScore': module1AvgScore,
      'module2Game1Score': module2Game1Score,
      'module2Game2Score': module2Game2Score,
      'module2Game3Score': module2Game3Score,
      'module2Game4Score': module2Game4Score,
      'module2AvgScore': module2AvgScore,
      'sessionCode': sessionCode,
    }.withoutNulls,
  );

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.module1Completed == e2?.module1Completed &&
        e1?.module2Completed == e2?.module2Completed &&
        e1?.module1Score == e2?.module1Score &&
        e1?.module2Score == e2?.module2Score &&
        e1?.module1HintsUsed == e2?.module1HintsUsed &&
        e1?.module2HintsUsed == e2?.module2HintsUsed &&
        e1?.studyGroup == e2?.studyGroup &&
        e1?.module1LessonDone == e2?.module1LessonDone &&
        e1?.module2LessonDone == e2?.module2LessonDone &&
        e1?.module1Game1Score == e2?.module1Game1Score &&
        e1?.module1Game2Score == e2?.module1Game2Score &&
        e1?.module1Game3Score == e2?.module1Game3Score &&
        e1?.module1Game4Score == e2?.module1Game4Score &&
        e1?.module1AvgScore == e2?.module1AvgScore &&
        e1?.module2Game1Score == e2?.module2Game1Score &&
        e1?.module2Game2Score == e2?.module2Game2Score &&
        e1?.module2Game3Score == e2?.module2Game3Score &&
        e1?.module2Game4Score == e2?.module2Game4Score &&
        e1?.module2AvgScore == e2?.module2AvgScore &&
        e1?.sessionCode == e2?.sessionCode;
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.photoUrl,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber,
        e?.module1Completed,
        e?.module2Completed,
        e?.module1Score,
        e?.module2Score,
        e?.module1HintsUsed,
        e?.module2HintsUsed,
        e?.studyGroup,
        e?.module1LessonDone,
        e?.module2LessonDone,
        e?.module1Game1Score,
        e?.module1Game2Score,
        e?.module1Game3Score,
        e?.module1Game4Score,
        e?.module1AvgScore,
        e?.module2Game1Score,
        e?.module2Game2Score,
        e?.module2Game3Score,
        e?.module2Game4Score,
        e?.module2AvgScore,
        e?.sessionCode
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}
