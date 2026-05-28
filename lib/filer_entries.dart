import 'dart:io';

import 'package:path/path.dart' as path;

import 'file_or_dir.dart';

/// ファイラに表示するディレクトリエントリ一覧を取得する。
Future<List<FileOrDir>> listFilerEntries(String currentDir) async {
  final entries = <FileOrDir>[];
  final dir = Directory(currentDir);

  final absoluteDir = dir.absolute;
  final parentDir = absoluteDir.parent;
  if (absoluteDir.path != parentDir.path) {
    entries.add(FileOrDir(file: File(parentDir.path), isDir: true));
  }

  await for (final entity in dir.list(followLinks: false)) {
    final entityPath = entity.path;
    if (isFilerEntryExcluded(entityPath)) {
      continue;
    }

    final file = File(entityPath);
    entries.add(FileOrDir(file: file, isDir: await isDirectory(file)));
  }

  return entries;
}

/// ファイラ表示から除外するパスかどうかを判断する。
bool isFilerEntryExcluded(String filePath) {
  if (filePath == '.') {
    return true;
  }

  if (path.basename(filePath).startsWith('.')) {
    return true;
  }

  if (filePath.endsWith('${Platform.pathSeparator}.')) {
    return true;
  }

  return false;
}

/// File がディレクトリかどうか判別する。
Future<bool> isDirectory(File file) async {
  final type = await FileSystemEntity.type(file.path);
  return switch (type) {
    FileSystemEntityType.directory => true,
    _ => false,
  };
}

/// 一覧に表示するラベル文字列を返す。
String filerEntryLabel(FileOrDir file, String currentDir) {
  if (file.isDir) {
    final current = Directory(currentDir).absolute;
    final parent = current.parent;
    if (current.path != parent.path && file.path == parent.path) {
      return '..';
    }
  }

  return path.basename(file.path);
}
