class WorkTimeModel {
  final int? worktimeid;
  final int? provid;

  final bool? sat;
  final bool? sun;
  final bool? mon;
  final bool? tue;
  final bool? wed;
  final bool? thr;
  final bool? fri;

  final String? fromTime;
  final String? toTime;

  WorkTimeModel({
    this.worktimeid,
    this.provid,
    this.sat = false,
    this.sun = false,
    this.mon = false,
    this.tue = false,
    this.wed = false,
    this.thr = false,
    this.fri = false,
    this.fromTime,
    this.toTime,
  });

  factory WorkTimeModel.fromJson(Map<String, dynamic> json) {
    return WorkTimeModel(
      worktimeid: json['worktimeid'],
      provid: json['provid'],
      sat: json['sat'],
      sun: json['sun'],
      mon: json['mon'],
      tue: json['tue'],
      wed: json['wed'],
      thr: json['thr'],
      fri: json['fri'],
      fromTime: json['fromtime'],
      toTime: json['totime'],
    );
  }

  static List<WorkTimeModel> fromJsonList(dynamic data) {
    if (data is! List) return [];

    return data
        .whereType<Map>()
        .map(
          (item) => WorkTimeModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      if (worktimeid != null && worktimeid != 0) "worktimeid": worktimeid,
      "provid": provid,
      "sat": sat,
      "sun": sun,
      "mon": mon,
      "tue": tue,
      "wed": wed,
      "thr": thr,
      "fri": fri,
      "fromtime": fromTime,
      "totime": toTime,
    };
  }
}
