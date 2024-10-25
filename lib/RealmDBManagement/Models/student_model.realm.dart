// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Student extends _Student with RealmEntity, RealmObjectBase, RealmObject {
  Student(
    String id,
    String name,
    String group, {
    Iterable<SessionItem> progress = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'group', group);
    RealmObjectBase.set<RealmList<SessionItem>>(
        this, 'progress', RealmList<SessionItem>(progress));
  }

  Student._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get group => RealmObjectBase.get<String>(this, 'group') as String;
  @override
  set group(String value) => RealmObjectBase.set(this, 'group', value);

  @override
  RealmList<SessionItem> get progress =>
      RealmObjectBase.get<SessionItem>(this, 'progress')
          as RealmList<SessionItem>;
  @override
  set progress(covariant RealmList<SessionItem> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<Student>> get changes =>
      RealmObjectBase.getChanges<Student>(this);

  @override
  Stream<RealmObjectChanges<Student>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Student>(this, keyPaths);

  @override
  Student freeze() => RealmObjectBase.freezeObject<Student>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'name': name.toEJson(),
      'group': group.toEJson(),
      'progress': progress.toEJson(),
    };
  }

  static EJsonValue _toEJson(Student value) => value.toEJson();
  static Student _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'name': EJsonValue name,
        'group': EJsonValue group,
      } =>
        Student(
          fromEJson(id),
          fromEJson(name),
          fromEJson(group),
          progress: fromEJson(ejson['progress']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Student._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Student, 'Student', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('group', RealmPropertyType.string),
      SchemaProperty('progress', RealmPropertyType.object,
          linkTarget: 'SessionItem', collectionType: RealmCollectionType.list),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class SessionItem extends _SessionItem
    with RealmEntity, RealmObjectBase, RealmObject {
  SessionItem(
    ObjectId id,
    String date, {
    Iterable<int> params = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'date', date);
    RealmObjectBase.set<RealmList<int>>(this, 'params', RealmList<int>(params));
  }

  SessionItem._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get date => RealmObjectBase.get<String>(this, 'date') as String;
  @override
  set date(String value) => RealmObjectBase.set(this, 'date', value);

  @override
  RealmList<int> get params =>
      RealmObjectBase.get<int>(this, 'params') as RealmList<int>;
  @override
  set params(covariant RealmList<int> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<SessionItem>> get changes =>
      RealmObjectBase.getChanges<SessionItem>(this);

  @override
  Stream<RealmObjectChanges<SessionItem>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<SessionItem>(this, keyPaths);

  @override
  SessionItem freeze() => RealmObjectBase.freezeObject<SessionItem>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'date': date.toEJson(),
      'params': params.toEJson(),
    };
  }

  static EJsonValue _toEJson(SessionItem value) => value.toEJson();
  static SessionItem _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'date': EJsonValue date,
      } =>
        SessionItem(
          fromEJson(id),
          fromEJson(date),
          params: fromEJson(ejson['params']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(SessionItem._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, SessionItem, 'SessionItem', [
      SchemaProperty('id', RealmPropertyType.objectid),
      SchemaProperty('date', RealmPropertyType.string),
      SchemaProperty('params', RealmPropertyType.int,
          collectionType: RealmCollectionType.list),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
