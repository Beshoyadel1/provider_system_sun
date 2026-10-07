/// Branch fields shared by service and package API responses.
class ServiceBranch {
  const ServiceBranch({required this.id, this.name = '', this.latinName = ''});

  final int id;
  final String name;
  final String latinName;

  factory ServiceBranch.fromJson(Map<String, dynamic> json) => ServiceBranch(
        id: int.tryParse(
                '${json['id'] ?? json['branchId'] ?? json['branchid']}') ??
            0,
        name:
            '${json['name'] ?? json['branchName'] ?? json['branchname'] ?? ''}',
        latinName:
            '${json['latinName'] ?? json['latinname'] ?? json['branchLatinName'] ?? json['branchlatinname'] ?? ''}',
      );
}

List<int> parseServiceBranchIds(dynamic value) => value is List
    ? value
        .map((id) => int.tryParse('$id'))
        .whereType<int>()
        .where((id) => id > 0)
        .toSet()
        .toList()
    : [];

List<ServiceBranch> parseAvailableServiceBranches(dynamic value) => value
        is List
    ? value
        .whereType<Map>()
        .map((item) => ServiceBranch.fromJson(Map<String, dynamic>.from(item)))
        .where((branch) => branch.id > 0)
        .toList()
    : [];
