# nocterm_test

Dart 製 TUI フレームワーク [nocterm](https://pub.dev/packages/nocterm) を使った、ターミナル上で動く画像ビューアです。

左側にファイラ、右側に画像の ASCII アート表示領域を配置し、ディレクトリを移動しながら `png` / `jpg` / `jpeg` 画像を選択して表示できます。

## 主な機能

- ターミナル上でのファイル・ディレクトリ一覧表示
- 矢印キーによるファイル選択
- Enter キーによるディレクトリ移動・画像表示
- 画像のグレースケール ASCII アート変換
- `R` キーによる ASCII 変換文字セットの切り替え
- `Q` / `Ctrl+C` による終了

## 開発環境

このプロジェクトは fvm でdart SDKを管理しています。

- Dart SDK: `^3.11.1`
- 主な依存パッケージ:
  - `nocterm`
  - `image`
  - `path`

```bash
fvm use 3.41.3
```

## 実行方法

プロジェクトルートで次を実行します。
```bash
fvm dart run lib/main.dart
```

またはコンパイル後にバイナリを実行します。
```bash
fvm dart compile exe lib/main.dart -o viewer
./viewer
```
