import 'dart:async';

import 'package:campuscare_app/core/network/api_exception.dart';
import 'package:campuscare_app/features/repair_request/data/models/repair_request_detail_response.dart';
import 'package:campuscare_app/features/repair_request/data/models/repair_request_status.dart';
import 'package:campuscare_app/features/repair_request/data/repositories/repair_request_repository.dart';
import 'package:campuscare_app/features/repair_request/data/services/repair_request_api_service.dart';
import 'package:campuscare_app/features/repair_request/presentation/controllers/update_repair_request_controller.dart';
import 'package:campuscare_app/features/repair_request/presentation/states/update_repair_request_state.dart';
import 'package:campuscare_app/features/repair_request/providers/repair_request_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

typedef UpdateHandler =
    Future<RepairRequestDetailResponse> Function({
      required int id,
      required RepairRequestStatus status,
      String? managerNote,
    });

class _FakeRepairRequestRepository extends RepairRequestRepository {
  _FakeRepairRequestRepository(this._handler)
    : super(apiService: RepairRequestApiService(Dio()));

  final UpdateHandler _handler;

  int? receivedId;
  RepairRequestStatus? receivedStatus;
  String? receivedManagerNote;

  @override
  Future<RepairRequestDetailResponse> updateRepairRequestStatus({
    required int id,
    required RepairRequestStatus status,
    String? managerNote,
  }) {
    receivedId = id;
    receivedStatus = status;
    receivedManagerNote = managerNote;

    return _handler(id: id, status: status, managerNote: managerNote);
  }
}

void main() {
  group('UpdateRepairRequestController', () {
    test('starts with initial state', () async {
      final repository = _FakeRepairRequestRepository(({
        required id,
        required status,
        managerNote,
      }) async {
        return _successResponse;
      });
      final container = _createContainer(repository);

      addTearDown(container.dispose);

      final initialState = await container.read(
        updateRepairRequestControllerProvider.future,
      );

      expect(initialState.status, UpdateRepairRequestStatus.initial);
      expect(initialState.repairRequest, isNull);
      expect(initialState.errorMessage, isNull);
    });

    test('sets loading then success and trims manager note', () async {
      final completer = Completer<RepairRequestDetailResponse>();
      final repository = _FakeRepairRequestRepository(({
        required id,
        required status,
        managerNote,
      }) {
        return completer.future;
      });
      final container = _createContainer(repository);

      addTearDown(container.dispose);

      await container.read(updateRepairRequestControllerProvider.future);

      final updateFuture = container
          .read(updateRepairRequestControllerProvider.notifier)
          .updateStatus(
            repairRequestId: 15,
            status: RepairRequestStatus.inProgress,
            managerNote: '  ?? ti?p nh?n x? l?  ',
          );

      final loadingState = container
          .read(updateRepairRequestControllerProvider)
          .value;

      expect(loadingState?.status, UpdateRepairRequestStatus.loading);
      expect(repository.receivedId, 15);
      expect(repository.receivedStatus, RepairRequestStatus.inProgress);
      expect(repository.receivedManagerNote, '?? ti?p nh?n x? l?');

      completer.complete(_successResponse);
      await updateFuture;

      final successState = container
          .read(updateRepairRequestControllerProvider)
          .value;

      expect(successState?.status, UpdateRepairRequestStatus.success);
      expect(successState?.repairRequest?.id, 15);
      expect(
        successState?.repairRequest?.status,
        RepairRequestStatus.inProgress,
      );
      expect(successState?.repairRequest?.managerNote, '?? ti?p nh?n x? l?');
      expect(successState?.errorMessage, isNull);
    });

    test('converts blank manager note to null', () async {
      final repository = _FakeRepairRequestRepository(({
        required id,
        required status,
        managerNote,
      }) async {
        return _successResponse;
      });
      final container = _createContainer(repository);

      addTearDown(container.dispose);

      await container.read(updateRepairRequestControllerProvider.future);

      await container
          .read(updateRepairRequestControllerProvider.notifier)
          .updateStatus(
            repairRequestId: 15,
            status: RepairRequestStatus.completed,
            managerNote: '   ',
          );

      expect(repository.receivedManagerNote, isNull);
    });

    test('uses ApiException message on failure', () async {
      final repository = _FakeRepairRequestRepository(({
        required id,
        required status,
        managerNote,
      }) async {
        throw const ApiException(
          message: 'B?n kh?ng c? quy?n c?p nh?t y?u c?u n?y',
          code: 'FORBIDDEN',
        );
      });
      final container = _createContainer(repository);

      addTearDown(container.dispose);

      await container.read(updateRepairRequestControllerProvider.future);

      await container
          .read(updateRepairRequestControllerProvider.notifier)
          .updateStatus(
            repairRequestId: 15,
            status: RepairRequestStatus.completed,
          );

      final failureState = container
          .read(updateRepairRequestControllerProvider)
          .value;

      expect(failureState?.status, UpdateRepairRequestStatus.failure);
      expect(
        failureState?.errorMessage,
        'B?n kh?ng c? quy?n c?p nh?t y?u c?u n?y',
      );
      expect(failureState?.repairRequest, isNull);
    });

    test('uses fallback message for unexpected error', () async {
      final repository = _FakeRepairRequestRepository(({
        required id,
        required status,
        managerNote,
      }) async {
        throw StateError('Unexpected failure');
      });
      final container = _createContainer(repository);

      addTearDown(container.dispose);

      await container.read(updateRepairRequestControllerProvider.future);

      await container
          .read(updateRepairRequestControllerProvider.notifier)
          .updateStatus(
            repairRequestId: 15,
            status: RepairRequestStatus.completed,
          );

      final failureState = container
          .read(updateRepairRequestControllerProvider)
          .value;

      expect(failureState?.status, UpdateRepairRequestStatus.failure);
      expect(
        failureState?.errorMessage,
        'Không thể cập nhật yêu cầu. Vui lòng thử lại.',
      );
    });
  });
}

ProviderContainer _createContainer(RepairRequestRepository repository) {
  return ProviderContainer(
    overrides: [repairRequestRepositoryProvider.overrideWithValue(repository)],
  );
}

final _successResponse = RepairRequestDetailResponse.fromJson({
  'success': true,
  'message': 'C?p nh?t tr?ng th?i y?u c?u s?a ch?a th?nh c?ng',
  'data': {
    'repairRequest': {
      'id': 15,
      'title': '??n ph?ng h?c b? h?ng',
      'description': '??n t?i ph?ng A-101 kh?ng ho?t ??ng',
      'category': 'ELECTRICAL',
      'priority': 'HIGH',
      'campus': 'C? s? ch?nh',
      'location': 'Ph?ng A-101',
      'imageUrl': null,
      'status': 'IN_PROGRESS',
      'managerNote': '?? ti?p nh?n x? l?',
      'createdAt': '2026-07-30T08:00:00.000Z',
      'updatedAt': '2026-07-30T09:00:00.000Z',
      'creator': {
        'id': 1,
        'username': 'student01',
        'fullName': 'Nguy?n V?n Sinh Vi?n',
        'studentCode': 'SV001',
        'role': 'USER',
      },
    },
  },
});
