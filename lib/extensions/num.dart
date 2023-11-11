const _kMin = 1e-15;

extension CalcNumExt on num {
  ///Safely divide by the given [value]
  num sDiv(num value) => this / (value + _kMin);

  ///returns the square of the number
  num get sq => this * this;
}