import { repairRequestService } from "../services/repair-request.service.js";
import { repairRequestValidator } from "../validators/repair-request.validator.js";
import AppError from "../utils/app-error.js";
import { apiResponse } from "../utils/api-response.js";

async function createRepairRequest(req, res, next) {
  try {
    const validatedData = repairRequestValidator.validateCreateRepairRequest(
      req.body,
    );

    const imageUrl = req.file
      ? `/uploads/repair-requests/${req.file.filename}`
      : null;

    const repairRequest = await repairRequestService.createRepairRequest({
      ...validatedData,
      imageUrl,
      createdBy: req.user.id,
    });

    return apiResponse.sendSuccess(res, {
      statusCode: 201,
      message: "Tạo yêu cầu sửa chữa thành công",
      data: {
        repairRequest,
      },
    });
  } catch (error) {
    return next(error);
  }
}

async function getRepairRequests(req, res, next) {
  try {
    const filters = repairRequestValidator.validateRepairRequestFilters(
      req.query,
    );

    const pagination = repairRequestValidator.validatePagination(req.query);

    const result = await repairRequestService.getRepairRequests({
      userId: req.user.id,
      role: req.user.role,
      ...filters,
      ...pagination,
    });

    return apiResponse.sendSuccess(res, {
      message: "Lấy danh sách yêu cầu sửa chữa thành công",
      data: {
        repairRequests: result.repairRequests,
        pagination: {
          page: pagination.page,
          pageSize: pagination.pageSize,
          totalItems: result.totalItems,
          totalPages: result.totalPages,
        },
        filters: {
          status: filters.status ?? null,
          category: filters.category ?? null,
          priority: filters.priority ?? null,
          search: filters.search ?? null,
        },
        sort: {
          sortBy: filters.sortBy,
          sortOrder: filters.sortOrder,
        },
      },
    });
  } catch (error) {
    return next(error);
  }
}

async function getRepairRequestById(req, res, next) {
  try {
    const repairRequestId = repairRequestValidator.validateRepairRequestId(
      req.params.id,
    );

    const repairRequest = await repairRequestService.getRepairRequestById({
      repairRequestId,
      userId: req.user.id,
      role: req.user.role,
    });

    if (!repairRequest) {
      throw new AppError("Không tìm thấy yêu cầu sửa chữa", 404, "NOT_FOUND");
    }

    return apiResponse.sendSuccess(res, {
      message: "Lấy chi tiết yêu cầu sửa chữa thành công",
      data: {
        repairRequest,
      },
    });
  } catch (error) {
    return next(error);
  }
}

async function updateRepairRequestStatus(req, res, next) {
  try {
    const repairRequestId = repairRequestValidator.validateRepairRequestId(
      req.params.id,
    );

    const validatedData = repairRequestValidator.validateStatusUpdate(req.body);

    const existingRepairRequest =
      await repairRequestService.getRepairRequestById({
        repairRequestId,
        userId: req.user.id,
        role: req.user.role,
      });

    if (!existingRepairRequest) {
      throw new AppError("Không tìm thấy yêu cầu sửa chữa", 404, "NOT_FOUND");
    }

    const repairRequest = await repairRequestService.updateRepairRequestStatus({
      repairRequestId,
      ...validatedData,
    });

    return apiResponse.sendSuccess(res, {
      message: "Cập nhật trạng thái yêu cầu sửa chữa thành công",
      data: {
        repairRequest,
      },
    });
  } catch (error) {
    return next(error);
  }
}

export const repairRequestController = {
  createRepairRequest,
  getRepairRequests,
  getRepairRequestById,
  updateRepairRequestStatus,
};
