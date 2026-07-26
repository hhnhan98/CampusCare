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
    const repairRequests =
      await repairRequestService.getRepairRequests({
        userId: req.user.id,
        role: req.user.role,
      });

    return res.status(200).json({
      success: true,
      message: "Lấy danh sách yêu cầu sửa chữa thành công",
      data: {
        repairRequests,
        total: repairRequests.length,
      },
    });
  } catch (error) {
    return next(error);
  }
}

export const repairRequestController = {
  createRepairRequest,
    getRepairRequests,
};