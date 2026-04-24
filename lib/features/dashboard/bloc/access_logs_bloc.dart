import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sigap_mobile/features/dashboard/data/access_logs_repository.dart';
import 'package:sigap_mobile/features/dashboard/models/access_log_model.dart';

part 'access_logs_event.dart';

part 'access_logs_state.dart';

class AccessLogsBloc extends Bloc<AccessLogsEvent, AccessLogsState> {
  AccessLogsBloc() : super(AccessLogsLoading()) {
    on<LoadAccessLogs>(_onLoadAccessLogs);
  }

  Future<void> _onLoadAccessLogs(
    LoadAccessLogs event,
    Emitter<AccessLogsState> emit,
  ) async {
    emit(AccessLogsLoading());

    AccessLogsRepository accessLogsRepo = AccessLogsRepository();

    await emit.forEach<List<Map<String, dynamic>>>(
      accessLogsRepo.streamAccessLogs(event.uid), // streaming access logs
      onData: (mapLogs) {
        List<AccessLogModel> logs = mapLogs
            .map((log) => AccessLogModel.fromMap(log, log["id"]))
            .toList();

        return AccessLogsLoaded(logs: logs);
      },
      onError: (error, stackTrace) {
        return const AccessLogsLoaded(logs: []);
      },
    );
  }
}
