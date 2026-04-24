part of 'access_logs_bloc.dart';

@immutable
sealed class AccessLogsEvent {}

class LoadAccessLogs extends AccessLogsEvent {
  final String uid;

  LoadAccessLogs({required this.uid});
}