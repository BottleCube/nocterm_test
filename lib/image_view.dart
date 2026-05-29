import 'package:nocterm/nocterm.dart';

import 'ascii_art.dart';
import 'ramp.dart';

/// 画像ビュー
class ImageView extends StatefulComponent {
  const ImageView({super.key, required this.fileName, required this.ramp});

  /// 表示対象の画像ファイルパス。
  final String? fileName;

  /// アスキーアート変換に使う文字セット。
  final Ramp ramp;

  /// 画像ビューコンポーネントの状態を生成する。
  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  /// 量子化時の縦横比補正係数。
  static const _quantizeAspect = 0.6;

  /// 量子化時の高さ分割サイズ。
  static const _quantizeHeight = 32;

  /// 読み込み中かどうかを表すフラグ。
  bool _loading = true;

  /// 描画用のアスキーアート行データ。
  List<String> _asciiLines = const [];

  /// 初回表示時に画像読み込みを開始する。
  @override
  void initState() {
    super.initState();
    if (component.fileName != null) {
      _loadImage();
    }
  }

  /// 画像をアスキーアート化して状態に反映する。
  Future<void> _loadImage() async {
    final lines = asciiArtFromFileName(
      component.fileName!,
      ramp: component.ramp,
      quantizeWidth: (_quantizeHeight * _quantizeAspect).floor(),
      quantizeHeight: _quantizeHeight,
    );

    setState(() {
      _asciiLines = lines;
      _loading = false;
    });
  }

  /// 画像ビューUIを構築する。
  @override
  Component build(BuildContext context) {
    final filename = component.fileName;
    return Column(
      children: [
        if (filename == null)
          Text('No image selected', style: TextStyle(color: Colors.yellow))
        else if (_loading)
          Text(filename, style: TextStyle(color: Colors.blue))
        else if (_loading)
          const Text('Loading...'),
        ListView.builder(
          itemCount: _asciiLines.length,
          itemBuilder: (_, index) {
            return Text(
              _asciiLines[index],
              style: TextStyle(color: Color.fromRGB(255, 210, 210)),
            );
          },
        ),
      ],
    );
  }
}
