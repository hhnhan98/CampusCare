import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/repair_category.dart';
import '../../data/models/repair_priority.dart';
import '../controllers/create_repair_request_controller.dart';
import '../states/create_repair_request_state.dart';

class CreateRepairRequestPage extends ConsumerStatefulWidget {
  const CreateRepairRequestPage({super.key});

  @override
  ConsumerState<CreateRepairRequestPage> createState() =>
      _CreateRepairRequestPageState();
}

class _CreateRepairRequestPageState
    extends ConsumerState<CreateRepairRequestPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _campusController = TextEditingController();
  final _locationController = TextEditingController();

  RepairCategory? _selectedCategory;
  RepairPriority? _selectedPriority;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _campusController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final category = _selectedCategory;
    final priority = _selectedPriority;

    if (category == null || priority == null) {
      return;
    }

    await ref
        .read(createRepairRequestControllerProvider.notifier)
        .createRepairRequest(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          category: category,
          priority: priority,
          campus: _campusController.text.trim(),
          location: _locationController.text.trim(),
        );
  }

  void _resetForm() {
    _formKey.currentState?.reset();

    _titleController.clear();
    _descriptionController.clear();
    _campusController.clear();
    _locationController.clear();

    setState(() {
      _selectedCategory = null;
      _selectedPriority = null;
    });

    ref.read(createRepairRequestControllerProvider.notifier).reset();
  }

  String? _validateRequiredText(
    String? value, {
    required String fieldName,
    required int maxLength,
  }) {
    final normalizedValue = value?.trim() ?? '';

    if (normalizedValue.isEmpty) {
      return 'Vui lòng nhập $fieldName';
    }

    if (normalizedValue.length > maxLength) {
      return '$fieldName không được vượt quá $maxLength ký tự';
    }

    return null;
  }

  String _categoryLabel(RepairCategory category) {
    return switch (category) {
      RepairCategory.electrical => 'Điện',
      RepairCategory.water => 'Nước',
      RepairCategory.airConditioner => 'Máy lạnh',
      RepairCategory.internet => 'Internet',
      RepairCategory.furniture => 'Bàn ghế và nội thất',
      RepairCategory.other => 'Khác',
    };
  }

  String _priorityLabel(RepairPriority priority) {
    return switch (priority) {
      RepairPriority.low => 'Thấp',
      RepairPriority.medium => 'Trung bình',
      RepairPriority.high => 'Cao',
    };
  }

  @override
  Widget build(BuildContext context) {
    final createRequestAsyncState = ref.watch(
      createRepairRequestControllerProvider,
    );
    final isLoading = createRequestAsyncState.isLoading;

    ref.listen<AsyncValue<CreateRepairRequestState>>(
      createRepairRequestControllerProvider,
      (previous, next) {
        final createRequestState = next.value;

        if (createRequestState?.status == CreateRepairRequestStatus.failure) {
          final message =
              createRequestState?.errorMessage ??
              'Không thể tạo yêu cầu sửa chữa';

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(message)));
        }

        if (createRequestState?.status == CreateRepairRequestStatus.success) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Tạo yêu cầu sửa chữa thành công')),
            );

          _resetForm();
        }
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Tạo yêu cầu sửa chữa')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Thông tin sự cố',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Vui lòng mô tả rõ sự cố để nhà trường dễ dàng tiếp nhận và xử lý.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleController,
                enabled: !isLoading,
                textInputAction: TextInputAction.next,
                maxLength: 150,
                decoration: const InputDecoration(
                  labelText: 'Tiêu đề',
                  hintText: 'Ví dụ: Máy lạnh phòng A-01.05 không hoạt động',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) => _validateRequiredText(
                  value,
                  fieldName: 'tiêu đề',
                  maxLength: 150,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                enabled: !isLoading,
                textInputAction: TextInputAction.newline,
                minLines: 4,
                maxLines: 6,
                maxLength: 2000,
                decoration: const InputDecoration(
                  labelText: 'Mô tả',
                  hintText: 'Mô tả tình trạng và thời điểm phát hiện sự cố',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                validator: (value) => _validateRequiredText(
                  value,
                  fieldName: 'mô tả',
                  maxLength: 2000,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<RepairCategory>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Loại sự cố',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: RepairCategory.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(_categoryLabel(category)),
                      ),
                    )
                    .toList(),
                onChanged: isLoading
                    ? null
                    : (category) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                validator: (category) {
                  if (category == null) {
                    return 'Vui lòng chọn loại sự cố';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<RepairPriority>(
                value: _selectedPriority,
                decoration: const InputDecoration(
                  labelText: 'Mức độ ưu tiên',
                  prefixIcon: Icon(Icons.flag_outlined),
                ),
                items: RepairPriority.values
                    .map(
                      (priority) => DropdownMenuItem(
                        value: priority,
                        child: Text(_priorityLabel(priority)),
                      ),
                    )
                    .toList(),
                onChanged: isLoading
                    ? null
                    : (priority) {
                        setState(() {
                          _selectedPriority = priority;
                        });
                      },
                validator: (priority) {
                  if (priority == null) {
                    return 'Vui lòng chọn mức độ ưu tiên';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _campusController,
                enabled: !isLoading,
                textInputAction: TextInputAction.next,
                maxLength: 100,
                decoration: const InputDecoration(
                  labelText: 'Cơ sở',
                  hintText: 'Ví dụ: Cơ sở Ung Văn Khiêm',
                  prefixIcon: Icon(Icons.apartment_outlined),
                ),
                validator: (value) => _validateRequiredText(
                  value,
                  fieldName: 'cơ sở',
                  maxLength: 100,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                enabled: !isLoading,
                textInputAction: TextInputAction.done,
                maxLength: 150,
                decoration: const InputDecoration(
                  labelText: 'Vị trí cụ thể',
                  hintText: 'Ví dụ: Phòng A-01.05, tầng 1',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                validator: (value) => _validateRequiredText(
                  value,
                  fieldName: 'vị trí',
                  maxLength: 150,
                ),
                onFieldSubmitted: isLoading ? null : (_) => _submitForm(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: isLoading ? null : _submitForm,
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                      : const Icon(Icons.send_outlined),
                  label: Text(isLoading ? 'Đang gửi...' : 'Gửi yêu cầu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
