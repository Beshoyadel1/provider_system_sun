import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/order_status_design/presentation/cubit/order_status_cubit/order_status_cubit.dart';
import 'package:sun_web_system/features/order_status_design/presentation/custom_widget/show_order_status_confirmation_dialog.dart';
import '../../data/model/order_employee_assignment.dart';
import '../cubit/order_status_cubit/order_status_state.dart';
import 'order_employee_assignment_dialog.dart';

import '../../../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../../../core/language/language_constant.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/theming/fonts.dart';
import '../../../../../../../core/theming/text_styles.dart';

class OrderStatusActionsWidget extends StatefulWidget {
  final int? status;
  final int orderId;
  final double? textSize;
  final OrderEmployeeAssignment assignment;

  const OrderStatusActionsWidget({
    super.key,
    required this.status,
    required this.orderId,
    required this.assignment,
    this.textSize,
  });

  @override
  State<OrderStatusActionsWidget> createState() =>
      _OrderStatusActionsWidgetState();
}

class _OrderStatusActionsWidgetState extends State<OrderStatusActionsWidget> {
  bool _acting = false;
  int? get status => widget.status;
  int get orderId => widget.orderId;
  double? get textSize => widget.textSize;

  // ============================================================
  // STATUS CHECK
  // ============================================================

  bool get _isNewOrder =>
      status == OrderStatus.newOrderForProvider ||
      status == OrderStatus.newOrderForCompany;

  bool get _isWaitingAppointment => status == OrderStatus.waitingAppointment;

  bool get _isEmployeeInRoad => status == OrderStatus.employeeInRoad;

  bool get _isWorkInProgress => status == OrderStatus.workInProgress;

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    if (status == null) {
      return const SizedBox.shrink();
    }

    // ============================================================
    // NEW ORDER
    // ============================================================

    if (_isNewOrder) {
      return _buildActions(
        context,
        actions: const [
          _ActionData(
            text: AppLanguageKeys.acceptOrder,
            icon: Icons.check_circle_outline,
            backgroundColor: AppColors.partGreenMixColor,
            color: AppColors.whiteColor,
            dialogColor: AppColors.greenColor,
            nextStatus: OrderStatus.waitingAppointment,
          ),
          _ActionData(
            text: AppLanguageKeys.rejectedByProvider,
            icon: Icons.close,
            backgroundColor: AppColors.partPinkMixColor,
            color: AppColors.whiteColor,
            dialogColor: AppColors.redColor,
            nextStatus: OrderStatus.rejectedByProvider,
          ),
          _ActionData(
            text: AppLanguageKeys.cancelledByUser,
            icon: Icons.cancel_outlined,
            backgroundColor: AppColors.blackColor,
            color: AppColors.whiteColor,
            dialogColor: AppColors.darkColor,
            nextStatus: OrderStatus.cancelledByUser,
          ),
        ],
      );
    }

    // ============================================================
    // WAITING APPOINTMENT
    // ============================================================

    if (_isWaitingAppointment) {
      return _buildActions(
        context,
        actions: const [
          _ActionData(
            text: AppLanguageKeys.employeeInRound,
            icon: Icons.airport_shuttle_outlined,
            backgroundColor: AppColors.blueColor,
            color: AppColors.whiteColor,
            dialogColor: AppColors.blueColor,
            nextStatus: OrderStatus.employeeInRoad,
          ),
          _ActionData(
            text: AppLanguageKeys.cancelledByUser,
            icon: Icons.cancel_outlined,
            backgroundColor: AppColors.blackColor,
            color: AppColors.whiteColor,
            dialogColor: AppColors.darkColor,
            nextStatus: OrderStatus.cancelledByUser,
          ),
        ],
      );
    }

    // ============================================================
    // EMPLOYEE IN ROAD
    // ============================================================

    if (_isEmployeeInRoad) {
      return _buildActions(
        context,
        actions: const [
          _ActionData(
            text: AppLanguageKeys.workInProgress,
            icon: Icons.settings_outlined,
            backgroundColor: AppColors.orangeColor,
            color: AppColors.whiteColor,
            dialogColor: AppColors.orangeColor,
            nextStatus: OrderStatus.workInProgress,
          ),
          _ActionData(
            text: AppLanguageKeys.cancelledByUser,
            icon: Icons.cancel_outlined,
            backgroundColor: AppColors.blackColor,
            color: AppColors.whiteColor,
            dialogColor: AppColors.darkColor,
            nextStatus: OrderStatus.cancelledByUser,
          ),
        ],
      );
    }

    // ============================================================
    // WORK IN PROGRESS
    // ============================================================

    if (_isWorkInProgress) {
      return _buildActions(
        context,
        actions: const [
          _ActionData(
            text: AppLanguageKeys.orderCompleted,
            icon: Icons.done_all,
            backgroundColor: AppColors.greenColor,
            color: AppColors.whiteColor,
            dialogColor: AppColors.greenColor,
            nextStatus: OrderStatus.orderCompleted,
          ),
          _ActionData(
            text: AppLanguageKeys.cancelledByUser,
            icon: Icons.cancel_outlined,
            backgroundColor: AppColors.blackColor,
            color: AppColors.whiteColor,
            dialogColor: AppColors.darkColor,
            nextStatus: OrderStatus.cancelledByUser,
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  // ============================================================
  // ACTIONS
  // ============================================================

  Widget _buildActions(
    BuildContext context, {
    required List<_ActionData> actions,
  }) {
    return Wrap(
      spacing: 20,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: actions.map(
        (action) {
          return _buildActionButton(
            context,
            action: action,
          );
        },
      ).toList(),
    );
  }

  // ============================================================
  // ACTION BUTTON
  // ============================================================

  Widget _buildActionButton(
    BuildContext context, {
    required _ActionData action,
  }) {
    return InkWell(
      onTap: () async {
        final cubit = context.read<OrderStatusCubit>();
        if (_acting || cubit.state is OrderStatusLoading) return;
        setState(() => _acting = true);
        try {
          List<int>? employeeIds;
          if (action.nextStatus == OrderStatus.waitingAppointment) {
            employeeIds = await showOrderEmployeeAssignmentDialog(context,
                assignment: widget.assignment);
            if (employeeIds == null || employeeIds.isEmpty) return;
          } else {
            final confirmed = await showOrderStatusConfirmationDialog(context,
                actionText: action.text, actionColor: action.dialogColor);
            if (confirmed != true) return;
          }
          if (!mounted) return;
          await cubit.updateOrderStatus(
              orderId: orderId,
              status: action.nextStatus,
              employeeIds: employeeIds ?? const []);
        } finally {
          if (mounted) setState(() => _acting = false);
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: action.backgroundColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(
            color: action.color,
          ),
        ),
        child: Wrap(
          spacing: 5,
          runSpacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: [
            Icon(
              action.icon,
              size: 12,
              color: action.color,
            ),
            TextInAppWidget(
              text: action.text,
              textSize: textSize ?? 15,
              fontWeightIndex: FontSelectionData.regularFontFamily,
              textColor: action.color,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ACTION DATA
// ============================================================

class _ActionData {
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final Color color;
  final Color dialogColor;
  final int nextStatus;

  const _ActionData({
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.color,
    required this.dialogColor,
    required this.nextStatus,
  });
}
