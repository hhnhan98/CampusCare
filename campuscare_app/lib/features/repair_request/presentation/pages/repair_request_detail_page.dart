import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/models/repair_request.dart';
import '../controllers/repair_request_detail_controller.dart';
import '../widgets/manager_repair_request_update_section.dart';

class RepairRequestDetailPage extends ConsumerWidget {
  const RepairRequestDetailPage({required this.repairRequestId, super.key});

  final int repairRequestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsyncState = ref.watch(
      repairRequestDetailProvider(repairRequestId),
    );
    final isManager =
        ref.watch(authControllerProvider).value?.isManager ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết yêu cầu')),
      body: detailAsyncState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _ErrorView(
          onRetry: () {
            ref.invalidate(repairRequestDetailProvider(repairRequestId));
          },
        ),
        data: (repairRequest) => _DetailContent(
          repairRequest: repairRequest,
          isManager: isManager,
          onRefresh: () async {
            ref.invalidate(repairRequestDetailProvider(repairRequestId));

            await ref.read(repairRequestDetailProvider(repairRequestId).future);
          },
        ),
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({
    required this.repairRequest,
    required this.isManager,
    required this.onRefresh,
  });

  final RepairRequest repairRequest;
  final bool isManager;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final imageUrl = repairRequest.imageUrl?.trim();
    final managerNote = repairRequest.managerNote?.trim();

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  repairRequest.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _StatusBadge(label: _statusLabel(repairRequest.status.name)),
            ],
          ),
          const SizedBox(height: 24),
          _SectionCard(
            title: 'Mô tả sự cố',
            child: Text(
              repairRequest.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Thông tin yêu cầu',
            child: Column(
              children: [
                _InformationRow(
                  icon: Icons.category_outlined,
                  label: 'Loại sự cố',
                  value: _categoryLabel(repairRequest.category.name),
                ),
                const Divider(height: 24),
                _InformationRow(
                  icon: Icons.flag_outlined,
                  label: 'Mức độ ưu tiên',
                  value: _priorityLabel(repairRequest.priority.name),
                ),
                const Divider(height: 24),
                _InformationRow(
                  icon: Icons.apartment_outlined,
                  label: 'Cơ sở',
                  value: repairRequest.campus,
                ),
                const Divider(height: 24),
                _InformationRow(
                  icon: Icons.location_on_outlined,
                  label: 'Vị trí',
                  value: repairRequest.location,
                ),
              ],
            ),
          ),
          if (imageUrl != null && imageUrl.isNotEmpty) ...[
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Ảnh sự cố',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return const SizedBox(
                      height: 240,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      height: 180,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.broken_image_outlined, size: 48),
                            SizedBox(height: 8),
                            Text('Không thể hiển thị ảnh'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
          if (managerNote != null && managerNote.isNotEmpty) ...[
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Ghi chú của quản lý',
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.admin_panel_settings_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      managerNote,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (isManager) ...[
            const SizedBox(height: 16),
            ManagerRepairRequestUpdateSection(repairRequest: repairRequest),
          ],
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Người gửi',
            child: Column(
              children: [
                _InformationRow(
                  icon: Icons.person_outline,
                  label: 'Họ tên',
                  value: repairRequest.creator.fullName,
                ),
                const Divider(height: 24),
                _InformationRow(
                  icon: Icons.account_circle_outlined,
                  label: 'Tài khoản',
                  value: repairRequest.creator.username,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Thời gian',
            child: Column(
              children: [
                _InformationRow(
                  icon: Icons.schedule_outlined,
                  label: 'Ngày tạo',
                  value: _formatDateTime(repairRequest.createdAt),
                ),
                const Divider(height: 24),
                _InformationRow(
                  icon: Icons.update_outlined,
                  label: 'Cập nhật lần cuối',
                  value: _formatDateTime(repairRequest.updatedAt),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String _statusLabel(String statusName) {
    return switch (statusName) {
      'pending' => 'Chờ xử lý',
      'inProgress' => 'Đang xử lý',
      'completed' => 'Đã hoàn thành',
      _ => statusName,
    };
  }

  String _categoryLabel(String categoryName) {
    return switch (categoryName) {
      'electrical' => 'Điện',
      'water' => 'Nước',
      'airConditioner' => 'Máy lạnh',
      'furniture' => 'Bàn ghế và nội thất',
      'internet' => 'Internet',
      'other' => 'Khác',
      _ => categoryName,
    };
  }

  String _priorityLabel(String priorityName) {
    return switch (priorityName) {
      'low' => 'Thấp',
      'medium' => 'Trung bình',
      'high' => 'Cao',
      _ => priorityName,
    };
  }

  String _formatDateTime(DateTime dateTime) {
    final localDateTime = dateTime.toLocal();

    final day = localDateTime.day.toString().padLeft(2, '0');
    final month = localDateTime.month.toString().padLeft(2, '0');
    final year = localDateTime.year.toString();

    final hour = localDateTime.hour.toString().padLeft(2, '0');
    final minute = localDateTime.minute.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute';
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _InformationRow extends StatelessWidget {
  const _InformationRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            const Text(
              'Không thể tải chi tiết yêu cầu.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}
