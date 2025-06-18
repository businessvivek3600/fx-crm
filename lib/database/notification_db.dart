import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotificationDatabase {
  static final NotificationDatabase _instance =
      NotificationDatabase._internal();
  factory NotificationDatabase() => _instance;
  NotificationDatabase._internal();

  Database? _database;
  final StreamController<List<Map<String, dynamic>>> _notificationController =
      StreamController.broadcast();


  Stream<List<Map<String, dynamic>>> get notificationStream =>
      _notificationController.stream;


  Future<Database> get database async {
    return _database ??= await _initDB();
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notifications.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
      CREATE TABLE notifications(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        body TEXT,
        image TEXT,
        timestamp TEXT,
        isRead INTEGER DEFAULT 0
      )
    ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE notifications ADD COLUMN isRead INTEGER DEFAULT 0');
        }
      },
    );
  }

  Future<void> insertNotification(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('notifications', {...data,'isRead': 0,});
    _pushUpdate();
  }

  Future<void> deleteNotification(int id) async {
    final db = await database;
    await db.delete('notifications', where: 'id = ?', whereArgs: [id]);
    _pushUpdate();
  }

  Future<void> _pushUpdate() async {
    final db = await database;
    final data = await db.query('notifications', orderBy: 'id DESC');
    _notificationController.add(data);
  }

  Future<List<Map<String, dynamic>>> getAllNotifications() async {
    final db = await database;
    final data = await db.query('notifications', orderBy: 'id DESC');
    _notificationController.add(data);
    return data;
  }

  Future<void> clearNotifications() async {
    final db = await database;
    await db.delete('notifications');
    _pushUpdate();
  }
  Future<void> markAllAsRead() async {
    final db = await database;
    await db.update(
      'notifications',
      {'isRead': 1},
      where: 'isRead = ?',
      whereArgs: [0],
    );
  }

}
