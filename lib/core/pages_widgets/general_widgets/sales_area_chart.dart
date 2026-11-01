import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat, NumberFormat;
import 'package:syncfusion_flutter_charts/charts.dart' as sf;

class SalesChartPoint {
  const SalesChartPoint(this.label, this.value);
  final String label;
  final double value;
}

/// A data-only plot shared by the dashboard and service statistics pages.
class SalesAreaChart extends StatelessWidget {
  const SalesAreaChart(
      {super.key,
      required this.points,
      required this.color,
      this.compact = false,
      this.zoomable = false,
      this.valueSuffix = ''});
  final List<SalesChartPoint> points;
  final Color color;
  final bool compact;
  final bool zoomable;
  final String valueSuffix;

  @override
  Widget build(BuildContext context) {
    final finite = points.where((p) => p.value.isFinite).toList();
    if (finite.isEmpty) return const SizedBox.shrink();
    if (zoomable && !compact) {
      return _ZoomableSalesAreaChart(points: finite, color: color);
    }
    final values = finite.map((p) => p.value);
    final lowest = math.min(0.0, values.reduce(math.min));
    final highest = values.reduce(math.max);
    final range = math.max(1.0, highest - lowest);
    final rawInterval = range / 4;
    final power =
        math.pow(10, (math.log(rawInterval) / math.ln10).floor()).toDouble();
    final fraction = rawInterval / power;
    final interval = (fraction <= 1
            ? 1
            : fraction <= 2
                ? 2
                : fraction <= 5
                    ? 5
                    : 10) *
        power;
    final minimum = compact ? lowest : (lowest / interval).floor() * interval;
    final maximum = compact
        ? (highest <= 0 ? lowest + range : highest + range * .18)
        : math.max(minimum + interval, (highest / interval).ceil() * interval);
    final lastX = (finite.length - 1).toDouble();
    final formatter = NumberFormat.compact(
        locale: Localizations.localeOf(context).languageCode);
    return Directionality(
      // Chronological order remains left-to-right in both application locales.
      textDirection: TextDirection.ltr,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: math.max(1.0, lastX),
          minY: minimum,
          maxY: maximum,
          clipData: const FlClipData.all(),
          gridData: FlGridData(
              show: !compact,
              drawVerticalLine: false,
              horizontalInterval: interval,
              getDrawingHorizontalLine: (_) => const FlLine(
                  color: Color(0xFFE9EDF2), strokeWidth: 1, dashArray: [5, 5])),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            show: !compact,
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: !compact,
                    reservedSize: 48,
                    interval: interval,
                    getTitlesWidget: (value, meta) => Text(
                        formatter.format(value),
                        style: const TextStyle(
                            fontSize: 10, color: Color(0xFF9399A3))))),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: !compact,
                    reservedSize: 32,
                    interval: math.max(1.0, (lastX / 4).ceilToDouble()),
                    getTitlesWidget: (value, meta) {
                      final index = value.round();
                      if (index < 0 ||
                          index >= finite.length ||
                          (value - index).abs() > .01) {
                        return const SizedBox.shrink();
                      }
                      final label = finite[index].label;
                      final date = DateTime.tryParse(label);
                      return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 10,
                          fitInside: SideTitleFitInsideData.fromTitleMeta(meta,
                              distanceFromEdge: 4),
                          child: Text(
                              date == null
                                  ? label
                                  : DateFormat.MMMd(
                                          Localizations.localeOf(context)
                                              .languageCode)
                                      .format(date),
                              style: const TextStyle(
                                  fontSize: 9, color: Color(0xFF9399A3)),
                              maxLines: 1));
                    })),
          ),
          lineTouchData: LineTouchData(
            enabled: !compact,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.white,
              tooltipRoundedRadius: 12,
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipItems: (spots) => spots.map((spot) {
                final index = spot.x.round().clamp(0, finite.length - 1);
                return LineTooltipItem(
                    '${finite[index].label}\n${NumberFormat('#,##0.##').format(spot.y)} $valueSuffix',
                    TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w600));
              }).toList(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var i = 0; i < finite.length; i++)
                  FlSpot(i.toDouble(), finite[i].value)
              ],
              isCurved: true,
              preventCurveOverShooting: true,
              color: color,
              barWidth: compact ? 1.2 : 1.7,
              dotData: FlDotData(show: finite.length == 1),
              belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(colors: [
                    color.withValues(alpha: compact ? .65 : .28),
                    color.withValues(alpha: .015)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            )
          ],
        ),
        duration: const Duration(milliseconds: 200),
      ),
    );
  }
}

/// Preserve the existing service pages' horizontal pinch/pan interaction.
class _ZoomableSalesAreaChart extends StatefulWidget {
  const _ZoomableSalesAreaChart({required this.points, required this.color});
  final List<SalesChartPoint> points;
  final Color color;
  @override
  State<_ZoomableSalesAreaChart> createState() =>
      _ZoomableSalesAreaChartState();
}

class _ZoomableSalesAreaChartState extends State<_ZoomableSalesAreaChart> {
  final _zoom = sf.ZoomPanBehavior(
      enablePinching: true, enablePanning: true, zoomMode: sf.ZoomMode.x);
  @override
  Widget build(BuildContext context) => sf.SfCartesianChart(
        zoomPanBehavior: _zoom,
        primaryXAxis: const sf.CategoryAxis(),
        primaryYAxis: const sf.NumericAxis(),
        series: <sf.CartesianSeries>[
          sf.AreaSeries<SalesChartPoint, String>(
            dataSource: widget.points,
            xValueMapper: (p, _) => p.label,
            yValueMapper: (p, _) => p.value,
            color: widget.color.withValues(alpha: .2),
            borderColor: Colors.transparent,
          ),
          sf.FastLineSeries<SalesChartPoint, String>(
            dataSource: widget.points,
            xValueMapper: (p, _) => p.label,
            yValueMapper: (p, _) => p.value,
            color: widget.color,
            width: 2,
          ),
        ],
      );
}
