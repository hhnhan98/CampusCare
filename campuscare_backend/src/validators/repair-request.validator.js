import {
  ALLOWED_CATEGORIES,
  ALLOWED_PRIORITIES,
  ALLOWED_SORT_FIELDS,
  ALLOWED_SORT_ORDERS,
  ALLOWED_STATUSES,
} from "../constants/repair-request.constants.js";
import AppError from "../utils/app-error.js";

function validateRequiredString(value, fieldName, maxLength) {
  if (typeof value !== "string" || value.trim() === "") {
    throw new AppError(`${fieldName} là bắt buộc`, 400, "VALIDATION_ERROR");
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

function validateRepairRequestId(id) {
  const repairRequestId = Number(id);

  if (!Number.isInteger(repairRequestId) || repairRequestId <= 0) {
    throw new AppError("ID yêu cầu không hợp lệ", 400, "VALIDATION_ERROR");
  }

  return repairRequestId;
}

function validateCreateRepairRequest(body) {
  const { title, description, category, priority, campus, location } = body;

  const normalizedTitle = validateRequiredString(title, "Tiêu đề", 150);

  const normalizedDescription = validateRequiredString(
    description,
    "Mô tả",
    2000,
  );

  const normalizedCampus = validateRequiredString(campus, "Cơ sở", 100);

  const normalizedLocation = validateRequiredString(location, "Vị trí", 150);

  if (typeof category !== "string" || !ALLOWED_CATEGORIES.includes(category)) {
    throw new AppError("Loại sự cố không hợp lệ", 400, "VALIDATION_ERROR");
  }

  if (typeof priority !== "string" || !ALLOWED_PRIORITIES.includes(priority)) {
    throw new AppError("Mức độ ưu tiên không hợp lệ", 400, "VALIDATION_ERROR");
  }

  return {
    title: normalizedTitle,
    description: normalizedDescription,
    category,
    priority,
    campus: normalizedCampus,
    location: normalizedLocation,
  };
}

function validateRepairRequestFilters(query) {
  const {
    status,
    category,
    priority,
    search,
    sortBy = "createdAt",
    sortOrder = "desc",
  } = query;

  if (status !== undefined && !ALLOWED_STATUSES.includes(status)) {
    throw new AppError("Trạng thái lọc không hợp lệ", 400, "VALIDATION_ERROR");
  }

  if (category !== undefined && !ALLOWED_CATEGORIES.includes(category)) {
    throw new AppError("Loại sự cố lọc không hợp lệ", 400, "VALIDATION_ERROR");
  }

  if (priority !== undefined && !ALLOWED_PRIORITIES.includes(priority)) {
    throw new AppError(
      "Mức độ ưu tiên lọc không hợp lệ",
      400,
      "VALIDATION_ERROR",
    );
  }

  if (!ALLOWED_SORT_FIELDS.includes(sortBy)) {
    throw new AppError("Trường sắp xếp không hợp lệ", 400, "VALIDATION_ERROR");
  }

  if (!ALLOWED_SORT_ORDERS.includes(sortOrder)) {
    throw new AppError("Thứ tự sắp xếp không hợp lệ", 400, "VALIDATION_ERROR");
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
  return {
    status,
    category,
    priority,
    search: normalizedSearch,
    sortBy,
    sortOrder,
  };
}

function validatePagination(query) {
  const DEFAULT_PAGE = 1;
  const DEFAULT_PAGE_SIZE = 10;
  const MAX_PAGE_SIZE = 100;

  let page = DEFAULT_PAGE;
  let pageSize = DEFAULT_PAGE_SIZE;

  if (query.page !== undefined) {
    page = Number(query.page);

    if (!Number.isInteger(page) || page <= 0) {
      throw new AppError("Số trang không hợp lệ", 400, "VALIDATION_ERROR");
    }
  }

  if (query.pageSize !== undefined) {
    pageSize = Number(query.pageSize);

    if (
      !Number.isInteger(pageSize) ||
      pageSize <= 0 ||
      pageSize > MAX_PAGE_SIZE
    ) {
      throw new AppError(
        "Kích thước trang không hợp lệ",
        400,
        "VALIDATION_ERROR",
      );
    }
  }

  return {
    page,
    pageSize,
  };
}

function validateStatusUpdate(body) {
  const { status, managerNote } = body;

  if (typeof status !== "string" || !ALLOWED_STATUSES.includes(status)) {
    throw new AppError(
      "Trạng thái yêu cầu không hợp lệ",
      400,
      "VALIDATION_ERROR",
    );
  }

  let normalizedManagerNote;

  if (managerNote !== undefined) {
    if (managerNote === null) {
      normalizedManagerNote = null;
    } else {
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
  }

  return {
    status,
    ...(managerNote !== undefined
      ? {
          managerNote: normalizedManagerNote,
        }
      : {}),
  };
}

export const repairRequestValidator = {
  validateRepairRequestId,
  validateCreateRepairRequest,
  validateRepairRequestFilters,
  validateStatusUpdate,
  validatePagination,
};
