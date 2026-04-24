part of 'access_logs_bloc.dart';

@immutable
sealed class AccessLogsState {
  final List<AccessLogModel> logs;

  const AccessLogsState({required this.logs});
}

class AccessLogsLoading extends AccessLogsState {
  AccessLogsLoading() : super(logs: []);
}

class AccessLogsLoaded extends AccessLogsState {
  const AccessLogsLoaded({required super.logs});
}