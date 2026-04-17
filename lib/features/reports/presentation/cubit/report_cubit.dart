import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/use_cases/send_report_use_case.dart';

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final SendReportUseCase sendReportUseCase;

  ReportCubit(this.sendReportUseCase) : super(ReportInitial());

  Future<void> sendReport(ReportEntity report) async {
    emit(ReportLoading());
    final result = await sendReportUseCase(report);
    result.fold(
      (failure) => emit(ReportError(failure.message)),
      (_) => emit(ReportSuccess()),
    );
  }
}
