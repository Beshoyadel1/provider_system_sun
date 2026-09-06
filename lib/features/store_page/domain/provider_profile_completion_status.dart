import 'package:sun_web_system/features/store_page/data/model/get_provider_branches_model/provider_branch_model.dart';
import 'package:sun_web_system/features/store_page/data/model/upload_provider_work_times_model/work_time_model.dart';

enum ProviderProfileCompletionDestination {
  myAccount,
  branches,
  workingHours,
}

class ProviderProfileCompletionStatus {
  const ProviderProfileCompletionStatus({
    required this.hasActiveBranch,
    required this.hasWorkTime,
  });

  factory ProviderProfileCompletionStatus.fromData({
    required List<ProviderBranchModel> branches,
    required List<WorkTimeModel> workTimes,
  }) {
    return ProviderProfileCompletionStatus(
      hasActiveBranch: branches.any((branch) => branch.isActive == true),
      hasWorkTime: workTimes.isNotEmpty,
    );
  }

  final bool hasActiveBranch;
  final bool hasWorkTime;

  bool get isComplete => hasActiveBranch && hasWorkTime;

  ProviderProfileCompletionDestination get destination {
    if (!hasActiveBranch && !hasWorkTime) {
      return ProviderProfileCompletionDestination.myAccount;
    }
    if (!hasActiveBranch) {
      return ProviderProfileCompletionDestination.branches;
    }
    return ProviderProfileCompletionDestination.workingHours;
  }
}
