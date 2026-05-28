import 'dart:io';

class FileOrDir {
  const FileOrDir({required this.file, required this.isDir});

  /// 対象のファイル実体。
  final File file;

  /// ディレクトリかどうかを表すフラグ
  final bool isDir;

  /// パスかどうか
  String get path => file.path;

  /// 画像ファイルかどうかを判定する。
  bool get isImageFile {
    if (isDir) {
      return false;
    }

    final path = file.path.toLowerCase();
    return path.endsWith('png') ||
        path.endsWith('jpg') ||
        path.endsWith('jpeg');
  }
}
