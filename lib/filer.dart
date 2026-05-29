import 'dart:io';
import 'package:nocterm/nocterm.dart';

import 'file_or_dir.dart';
import 'filer_entries.dart';

class Filer extends StatefulComponent {
  const Filer({
    super.key,
    required this.focused,
    required this.onSelected,
  });

  /// フォーカスするかどうか
  final bool focused;

  /// 画像ファイル選択時に通知するコールバック。
  final ValueChanged<File> onSelected;

  /// ファイラコンポーネントの状態を生成する。
  @override
  State<Filer> createState() => _FilerState();
}

class _FilerState extends State<Filer> {
  /// 画像ファイル名の表示色。
  static const _imageFileColor = Color.fromRGB(0, 128, 255);

  /// 通常ファイル名の表示色。
  static const _fileColor = Color.fromRGB(128, 128, 128);

  /// ディレクトリ名の表示色。
  static const _dirColor = Color.fromRGB(255, 0, 0);

  final _controller = ScrollController();

  /// ロードフラグ
  bool _loading = false;

  /// 選択中のファイルインデックス
  int _selectedIndex = 0;

  /// 現在のディレクトリ
  String _currentDir = '.';

  /// ファイル
  List<FileOrDir> _files = [];

  /// 初期ディレクトリを設定して一覧取得を開始する。
  @override
  void initState() {
    super.initState();
    _currentDir = '';
    _fetchCurrentDirectoryEntries();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// ディレクトリを変更する
  void _changeDirectory(String cwd) {
    if (_loading) {
      return;
    }
    setState(() {
      _loading = true;
      _currentDir = cwd;
    });
    _fetchCurrentDirectoryEntries();
  }

  /// 現在ディレクトリのエントリ一覧を取得する。
  Future<void> _fetchCurrentDirectoryEntries() async {
    final files = await listFilerEntries(_currentDir);

    // ディレクトリ内のファイルを列挙
    setState(() {
      _selectedIndex = 0;
      _files = files;
      _loading = false;
    });
  }

  /// ファイラUIを構築する。
  @override
  Component build(BuildContext context) {
    if (_loading) {
      return Center(child: Text('Loading..'));
    }

    return Focusable(
      focused: component.focused,
      onKeyEvent: _handleKeyEvent,
      child: ListView.builder(
        controller: _controller,
        itemCount: _files.length,
        itemBuilder: (_, index) {
          final file = _files[index];
          return Text(
            filerEntryLabel(file, _currentDir),
            style: _getStyle(file, index),
          );
        },
      ),
    );
  }

  /// キーボードイベントを処理する
  bool _handleKeyEvent(KeyboardEvent event) {
    final key = event.logicalKey;

    /// ↑キーで1つ前にカーソル移動する
    if (key == LogicalKey.arrowUp && _selectedIndex > 0) {
      final nextIndex = _selectedIndex - 1;
      setState(() {
        _selectedIndex = nextIndex;
      });
      _controller.jumpTo(nextIndex.toDouble());
      return true;
    }

    /// ↓キーで1つ後にカーソル移動する
    if (key == LogicalKey.arrowDown && _selectedIndex < _files.length - 1) {
      final nextIndex = _selectedIndex + 1;
      setState(() {
        _selectedIndex = nextIndex;
      });
      _controller.jumpTo(nextIndex.toDouble());
      return true;
    }

    if (key != LogicalKey.enter) {
      return false;
    }

    /// Enterを押下した。ディレクトリ移動・または画像ファイル選択
    final file = _files[_selectedIndex];
    if (file.isImageFile) {
      component.onSelected(file.file);
    } else if (file.isDir) {
      _changeDirectory(file.path);
    }
    return true;
  }

  /// ファイル種別と選択状態に応じた表示スタイルを返す。
  TextStyle _getStyle(FileOrDir file, int index) {
    final selected = _selectedIndex == index;
    final bgColor = selected ? Colors.yellow : null;

    if (file.isImageFile) {
      return TextStyle(backgroundColor: bgColor, color: _imageFileColor);
    }

    return TextStyle(
      backgroundColor: bgColor,
      color: file.isDir ? _dirColor : _fileColor,
    );
  }
}
