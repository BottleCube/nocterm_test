/// アスキーアート変換に使う文字ランプの種類。
enum Ramp {
  /// 低密度ランプ。
  ramp0,

  /// 中密度ランプ。
  ramp1,

  /// 高密度ランプ。
  ramp2;

  /// 次のenum値を取得する
  Ramp getNextRamp() {
    return switch (this) {
      Ramp.ramp0 => Ramp.ramp1,
      Ramp.ramp1 => Ramp.ramp2,
      Ramp.ramp2 => Ramp.ramp0,
    };
  }
}
