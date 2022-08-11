class Bar {
  double thc;
  double cbd;
  final int? heartbeatRate;
  final int? sleepRate;
  final int? steps;
  final DateTime dateTime;

  Bar(
    this.thc,
    this.cbd,
    this.heartbeatRate,
    this.sleepRate,
    this.steps,
    this.dateTime,
  );

  @override
  String toString() {
    return 'Day: $dateTime\n$thc: $thc\ncbd: $cbd\nsleepRate: ${sleepRate ?? 0}\nheartbeatRate: ${heartbeatRate ?? 0}\nsteps: ${steps ?? 0}';
  }
}
