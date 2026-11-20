import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_error_handler.dart';
import 'package:egypto/core/networking/api_service.dart';
import 'package:egypto/features/admin/data/models/admin_pending_page.dart';
import 'package:egypto/features/admin/data/repository/admin_repo.dart';
import 'package:egypto/features/admin/presentation/cubit/admin_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('confirmed identity approval removes the item and refreshes the queue', () async {
    const userId = 'user-1';
    final repository = _AdminRepo()
      ..identityPage = _page([
        {'userId': userId, 'status': 'Pending'},
      ]);
    final cubit = AdminCubit(repository);
    addTearDown(cubit.close);

    await cubit.loadPendingIdentity();
    final succeeded = await cubit.approveIdentity(userId);

    expect(succeeded, isTrue);
    expect(repository.approvedUserIds, [userId]);
    expect(repository.identityLoads, 2);
    expect(cubit.state.identityPage?.items, isEmpty);
  });

  test('failed identity rejection leaves the item in the pending queue', () async {
    const userId = 'user-2';
    final repository = _AdminRepo()
      ..identityPage = _page([
        {'userId': userId, 'status': 'Pending'},
      ])
      ..rejectError = const AppException(
        errorType: AppErrorType.forbidden,
        message: 'Forbidden',
      );
    final cubit = AdminCubit(repository);
    addTearDown(cubit.close);

    await cubit.loadPendingIdentity();
    final succeeded = await cubit.rejectIdentity(userId);

    expect(succeeded, isFalse);
    expect(repository.rejectedUserIds, [userId]);
    expect(repository.identityLoads, 1);
    expect(cubit.state.identityPage?.items.single['userId'], userId);
    expect(cubit.state.actionError, AppErrorType.forbidden);
  });
}

AdminPendingPage _page(List<Map<String, dynamic>> items) => AdminPendingPage(
  items: items,
  pageNumber: 1,
  totalPages: 1,
  totalCount: items.length,
  hasPreviousPage: false,
  hasNextPage: false,
);

class _AdminRepo extends AdminRepo {
  _AdminRepo() : super(ApiService(Dio()), Dio());

  AdminPendingPage identityPage = _page([]);
  AppException? rejectError;
  int identityLoads = 0;
  final List<String> approvedUserIds = [];
  final List<String> rejectedUserIds = [];

  @override
  Future<AdminPendingPage> getPendingIdentity({
    required int pageNumber,
    required int pageSize,
  }) async {
    identityLoads++;
    return identityPage;
  }

  @override
  Future<Object?> approveIdentity(String userId) async {
    approvedUserIds.add(userId);
    identityPage = _page([]);
    return null;
  }

  @override
  Future<Object?> rejectIdentity(String userId) async {
    rejectedUserIds.add(userId);
    final error = rejectError;
    if (error != null) throw error;
    identityPage = _page([]);
    return null;
  }
}