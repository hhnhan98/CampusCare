import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/repair_request.dart';
import '../../data/models/repair_request_status.dart';
import '../controllers/repair_request_detail_controller.dart';
import '../controllers/repair_request_list_controller.dart';
import '../controllers/update_repair_request_controller.dart';
import '../states/update_repair_request_state.dart';

class ManagerRepairRequestUpdateSection extends ConsumerStatefulWidget {
  const ManagerRepairRequestUpdateSection({
    required this.repairRequest,
    super.key,
  });

  final RepairRequest repairRequest;

  @override
  ConsumerState<ManagerRepairRequestUpdateSection> createState() =>
      _ManagerRepairRequestUpdateSectionState();
}

class _ManagerRepairRequestUpdateSectionState
    extends ConsumerState<ManagerRepairRequestUpdateSection> {
  final _formKey = GlobalKey<FormState>();
  final _managerNoteController = TextEditingController();

  RepairRequestStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();

    _selectedStatus = widget.repairRequest.status;
    _managerNoteController.text = widget.repairRequest.managerNote ?? '';
  }

  @override
  void didUpdateWidget(covariant ManagerRepairRequestUpdateSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.repairRequest.updatedAt == widget.repairRequest.updatedAt) {
      return;
    }

    _selectedStatus = widget.repairRequest.status;
    _managerNoteController.text = widget.repairRequest.managerNote ?? '';
  }

  @override
  void dispose() {
    _managerNoteController.dispose();
    super.dispose();
  }

  Future<void> _submitUpdate() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final selectedStatus = _selectedStatus;

    if (selectedStatus == null) {
      return;
    }

    await ref
        .read(updateRepairRequestControllerProvider.notifier)
        .updateStatus(
          repairRequestId: widget.repairRequest.id,
          status: selectedStatus,
          managerNote: _managerNoteController.text,
        );
  }

  String _statusLabel(RepairRequestStatus status) {
    return switch (status) {
      RepairRequestStatus.pending => 'Chờ xử lý',
      RepairRequestStatus.inProgress => 'Đang xử lý',
      RepairRequestStatus.completed => 'Đã hoàn thành',
    };
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final updateAsyncState = ref.watch(updateRepairRequestControllerProvider);
    final isLoading =
        updateAsyncState.value?.isLoading ?? updateAsyncState.isLoading;

    ref.listen<AsyncValue<UpdateRepairRequestState>>(
      updateRepairRequestControllerProvider,
      (previous, next) {
        final previousStatus = previous?.value?.status;
        final updateState = next.value;
        final currentStatus = updateState?.status;

        if (previousStatus == currentStatus) {
          return;
        }

        if (currentStatus == UpdateRepairRequestStatus.failure) {
          _showMessage(
            updateState?.errorMessage ??
                'Không thể cập nhật yêu cầu. Vui lòng thử lại.',
          );
        }

        if (currentStatus == UpdateRepairRequestStatus.success) {
          ref.invalidate(repairRequestDetailProvider(widget.repairRequest.id));
          ref.invalidate(repairRequestListControllerProvider);

          _showMessage('Cập nhật yêu cầu sửa chữa thành công');
        }
      },
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Cập nhật xử lý',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Chức năng dành cho quản lý cơ sở vật chất.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<RepairRequestStatus>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Trạng thái',
                  prefixIcon: Icon(Icons.sync_alt_outlined),
                ),
                items: RepairRequestStatus.values
                    .map(
                      (status) => DropdownMenuItem(
                        value: status,
                        child: Text(_statusLabel(status)),
                      ),
                    )
                    .toList(),
                onChanged: isLoading
                    ? null
                    : (status) {
                        setState(() {
                          _selectedStatus = status;
                        });
                      },
                validator: (status) {
                  if (status == null) {
                    return 'Vui lòng chọn trạng thái';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _managerNoteController,
                enabled: !isLoading,
                minLines: 3,
                maxLines: 5,
                maxLength: 2000,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú xử lý',
                  hintText: 'Không bắt buộc',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
                validator: (value) {
                  if ((value?.trim().length ?? 0) > 2000) {
                    return 'Ghi chú không được vượt quá 2000 ký tự';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 50,
                child: FilledButton.icon(
                  onPressed: isLoading ? null : _submitUpdate,
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(isLoading ? 'Đang cập nhật...' : 'Lưu cập nhật'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
