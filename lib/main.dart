import 'dart:io';
import 'package:nocterm/nocterm.dart';

import 'filer.dart';
import 'image_view.dart';
import 'ramp.dart';

/// アプリケーションのエントリーポイント。
void main() {
  runApp(AppMain());
}

/// アプリケーション全体のルートコンポーネント。
class AppMain extends StatefulComponent {
  /// ルートコンポーネントの状態を生成する。
  @override
  State<AppMain> createState() => _AppState();
}

class _AppState extends State<AppMain> {
  /// アスキーアート変換に使う文字セットの選択状態。
  Ramp _ramp = Ramp.ramp1;

  /// 現在選択されている画像ファイルのパス。
  String? _imageFileName;

  /// メインレイアウトを構築する。
  @override
  Component build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Row(
        children: [
          Focusable(
            focused: true,
            onKeyEvent: (event) {
              switch (event.logicalKey) {
                case LogicalKey.keyC:
                  if (event.modifiers.ctrl) {
                    exit(0);
                  }
                case LogicalKey.keyQ:
                  exit(0);
                case LogicalKey.keyR:
                  setState(() {
                    _ramp = switch (_ramp) {
                      Ramp.ramp0 => Ramp.ramp1,
                      Ramp.ramp1 => Ramp.ramp2,
                      Ramp.ramp2 => Ramp.ramp0,
                    };
                  });
                  return true;
                default:
                  break;
              }
              return false;
            },
            child: Container(
              width: 30,
              decoration: BoxDecoration(
                border: BoxBorder(right: BorderSide(color: Colors.white)),
              ),
              child: Filer(
                focused: true,
                onSelected: (file) {
                  setState(() {
                    _imageFileName = file.path;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: ImageView(
              key: Key('${_imageFileName}_$_ramp'),
              fileName: _imageFileName,
              ramp: _ramp,
            ),
          ),
        ],
      ),
    );
  }
}
