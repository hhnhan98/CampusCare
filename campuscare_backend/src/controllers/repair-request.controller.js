import { repairRequestService } from "../services/repair-request.service.js";
import AppError from "../utils/app-error.js";

const ALLOWED_CATEGORIES = [
  "ELECTRICAL",
  "WATER",
  "AIR_CONDITIONER",
  "INTERNET",
  "FURNITURE",
  "OTHER",
];

const ALLOWED_PRIORITIES = [
  "LOW",
  "MEDIUM",
  "HIGH",
];

const ALLOWED_STATUSES = [
  "PENDING",
  "IN_PROGRESS",
  "COMPLETED",
];

function validateRequiredString(value, fieldName, maxLength) {
  if (typeof value !== "string" || value.trim() === "") {
    throw new AppError(
      `${fieldName} là bắt buộc`,
      400,
      "VALIDATION_ERROR",
    );
  }

  const normalizedValue = value.trim();

  if (normalizedValue.length > maxLength) {
    throw new AppError(
      `${fieldName} không được vượt quá ${maxLength} ký tự`,
      400,
      "VALIDATION_ERROR",
    );
  }

  return normalizedValue;
}

async function createRepairRequest(req, res, next) {
  try {
    const {
      title,
      description,
      category,
      priority,
      campus,
      location,
    } = req.body;

    const normalizedTitle = validateRequiredString(
      title,
      "Tiêu đề",
      150,
    );

    const normalizedDescription = validateRequiredString(
      description,
      "Mô tả",
      2000,
    );

    const normalizedCampus = validateRequiredString(
      campus,
      "Cơ sở",
      100,
    );

    const normalizedLocation = validateRequiredString(
      location,
      "Vị trí",
      150,
    );

    if (
      typeof category !== "string" ||
      !ALLOWED_CATEGORIES.includes(category)
    ) {
      throw new AppError(
        "Loại sự cố không hợp lệ",
        400,
        "VALIDATION_ERROR",
      );
    }

    if (
      typeof priority !== "string" ||
      !ALLOWED_PRIORITIES.includes(priority)
    ) {
      throw new AppError(
        "Mức độ ưu tiên không hợp lệ",
        400,
        "VALIDATION_ERROR",
      );
    }

    const repairRequest =
      await repairRequestService.createRepairRequest({
        title: normalizedTitle,
        description: normalizedDescription,
        category,
        priority,
        campus: normalizedCampus,
        location: normalizedLocation,
        createdBy: req.user.id,
      });

    return res.status(201).json({
      success: true,
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
    const {
      status,
      category,
      priority,
      search,
    } = req.query;

    if (
      status !== undefined &&
      !ALLOWED_STATUSES.includes(status)
    ) {
      throw new AppError(
        "Trạng thái lọc không hợp lệ",
        400,
        "VALIDATION_ERROR",
      );
    }

    if (
      category !== undefined &&
      !ALLOWED_CATEGORIES.includes(category)
    ) {
      throw new AppError(
        "Loại sự cố lọc không hợp lệ",
        400,
        "VALIDATION_ERROR",
      );
    }

    if (
      priority !== undefined &&
      !ALLOWED_PRIORITIES.includes(priority)
    ) {
      throw new AppError(
        "Mức độ ưu tiên lọc không hợp lệ",
        400,
        "VALIDATION_ERROR",
      );
    }

    let normalizedSearch;

    if (search !== undefined) {
      if (typeof search !== "string") {
        throw new AppError(
          "Từ khóa tìm kiếm không hợp lệ",
          400,
          "VALIDATION_ERROR",
        );
      }

      normalizedSearch = search.trim();

      if (normalizedSearch.length > 100) {
        throw new AppError(
          "Từ khóa tìm kiếm không được vượt quá 100 ký tự",
          400,
          "VALIDATION_ERROR",
        );
      }

      if (normalizedSearch === "") {
        normalizedSearch = undefined;
      }
    }

    const repairRequests =
      await repairRequestService.getRepairRequests({
        userId: req.user.id,
        role: req.user.role,
        status,
        category,
        priority,
        search: normalizedSearch,
      });

    return res.status(200).json({
      success: true,
      message: "Lấy danh sách yêu cầu sửa chữa thành công",
      data: {
        repairRequests,
        total: repairRequests.length,
        filters: {
          status: status ?? null,
          category: category ?? null,
          priority: priority ?? null,
          search: normalizedSearch ?? null,
        },
      },
    });
  } catch (error) {
    return next(error);
  }
}

async function getRepairRequestById(req, res, next) {
  try {
    const repairRequestId = Number(req.params.id);

    if (
      !Number.isInteger(repairRequestId) ||
      repairRequestId <= 0
    ) {
      throw new AppError(
        "ID yêu cầu không hợp lệ",
        400,
        "VALIDATION_ERROR",
      );
    }

    const repairRequest =
      await repairRequestService.getRepairRequestById({
        repairRequestId,
        userId: req.user.id,
        role: req.user.role,
      });

    if (!repairRequest) {
      throw new AppError(
        "Không tìm thấy yêu cầu sửa chữa",
        404,
        "NOT_FOUND",
      );
    }

    return res.status(200).json({
      success: true,
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
    const repairRequestId = Number(req.params.id);

    if (
      !Number.isInteger(repairRequestId) ||
      repairRequestId <= 0
    ) {
      throw new AppError(
        "ID yêu cầu không hợp lệ",
        400,
        "VALIDATION_ERROR",
      );
    }

    const { status, managerNote } = req.body;

    if (
      typeof status !== "string" ||
      !ALLOWED_STATUSES.includes(status)
    ) {
      throw new AppError(
        "Trạng thái yêu cầu không hợp lệ",
        400,
        "VALIDATION_ERROR",
      );
    }

    let normalizedManagerNote = null;

    if (managerNote !== undefined && managerNote !== null) {
      if (typeof managerNote !== "string") {
        throw new AppError(
          "Ghi chú xử lý phải là chuỗi",
          400,
          "VALIDATION_ERROR",
        );
      }

      normalizedManagerNote = managerNote.trim();

      if (normalizedManagerNote.length > 2000) {
        throw new AppError(
          "Ghi chú xử lý không được vượt quá 2000 ký tự",
          400,
          "VALIDATION_ERROR",
        );
      }

      if (normalizedManagerNote === "") {
        normalizedManagerNote = null;
      }
    }

    const existingRepairRequest =
      await repairRequestService.getRepairRequestById({
        repairRequestId,
        userId: req.user.id,
        role: req.user.role,
      });

    if (!existingRepairRequest) {
      throw new AppError(
        "Không tìm thấy yêu cầu sửa chữa",
        404,
        "NOT_FOUND",
      );
    }

    const repairRequest =
      await repairRequestService.updateRepairRequestStatus({
        repairRequestId,
        status,
        managerNote: normalizedManagerNote,
      });

    return res.status(200).json({
      success: true,
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