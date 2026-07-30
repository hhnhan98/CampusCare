import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../data/models/repair_request.dart';
import '../controllers/repair_request_list_controller.dart';
import '../states/repair_request_list_state.dart';

class RepairRequestListPage extends ConsumerWidget {
  const RepairRequestListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsyncState = ref.watch(repairRequestListControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Yêu cầu sửa chữa')),
      body: listAsyncState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _UnexpectedErrorView(
          onRetry: () {
            ref.read(repairRequestListControllerProvider.notifier).refresh();
          },
        ),
        data: (listState) => _RepairRequestListContent(
          state: listState,
          onRefresh: () {
            return ref
                .read(repairRequestListControllerProvider.notifier)
                .refresh();
          },
          onLoadMore: () {
            ref
                .read(repairRequestListControllerProvider.notifier)
                .loadNextPage();
          },
        ),
      ),
    );
  }
}

class _RepairRequestListContent extends StatelessWidget {
  const _RepairRequestListContent({
    required this.state,
    required this.onRefresh,
    required this.onLoadMore,
  });

  final RepairRequestListState state;
  final Future<void> Function() onRefresh;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    if (state.isEmpty && state.errorMessage != null) {
      return _InitialErrorView(
        message: state.errorMessage!,
        onRetry: onRefresh,
      );
    }

    if (state.isEmpty) {
      return _EmptyView(onRefresh: onRefresh);
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: state.repairRequests.length + 1,
        separatorBuilder: (context, index) {
          return const SizedBox(height: 12);
        },
        itemBuilder: (context, index) {
          if (index < state.repairRequests.length) {
            final repairRequest = state.repairRequests[index];

            return _RepairRequestCard(
              repairRequest: repairRequest,
              onTap: () {
                context.push('${AppRoutes.repairRequests}/${repairRequest.id}');
              },
            );
          }

          return _ListFooter(state: state, onLoadMore: onLoadMore);
        },
      ),
    );
  }
}

class _RepairRequestCard extends StatelessWidget {
  const _RepairRequestCard({required this.repairRequest, required this.onTap});

  final RepairRequest repairRequest;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      repairRequest.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _StatusBadge(label: _statusLabel(repairRequest.status.name)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                repairRequest.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              _InformationRow(
                icon: Icons.category_outlined,
                text: _categoryLabel(repairRequest.category.name),
              ),
              const SizedBox(height: 8),
              _InformationRow(
                icon: Icons.flag_outlined,
                text: 'Ưu tiên: ${_priorityLabel(repairRequest.priority.name)}',
              ),
              const SizedBox(height: 8),
              _InformationRow(
                icon: Icons.apartment_outlined,
                text: repairRequest.campus,
              ),
              const SizedBox(height: 8),
              _InformationRow(
                icon: Icons.location_on_outlined,
                text: repairRequest.location,
              ),
              const SizedBox(height: 12),
              Text(
                'Ngày tạo: ${_formatDateTime(repairRequest.createdAt)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _statusLabel(String statusName) {
    return switch (statusName) {
      'pending' => 'Chờ xử lý',
      'inProgress' => 'Đang xử lý',
      'completed' => 'Đã hoàn thành',
      'rejected' => 'Đã từ chối',
      'cancelled' => 'Đã hủy',
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

class _InformationRow extends StatelessWidget {
  const _InformationRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}

class _ListFooter extends StatelessWidget {
  const _ListFooter({required this.state, required this.onLoadMore});

  final RepairRequestListState state;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 20),
        child: Column(
          children: [
            Text(
              state.errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: onLoadMore,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử tải lại'),
            ),
          ],
        ),
      );
    }

    if (state.hasNextPage) {
      return Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 20),
        child: OutlinedButton.icon(
          onPressed: onLoadMore,
          icon: const Icon(Icons.expand_more),
          label: const Text('Tải thêm'),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 20),
      child: Text(
        'Đã hiển thị tất cả yêu cầu',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _InitialErrorView extends StatelessWidget {
  const _InitialErrorView({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRetry,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 120),
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Center(
            child: FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ),
        ],
      ),
    );
  }
}

class _UnexpectedErrorView extends StatelessWidget {
  const _UnexpectedErrorView({required this.onRetry});

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
              'Đã xảy ra lỗi không mong muốn.',
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

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 120),
          Icon(
            Icons.inbox_outlined,
            size: 72,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 20),
          Text(
            'Chưa có yêu cầu sửa chữa',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Các yêu cầu bạn đã gửi sẽ xuất hiện tại đây.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
