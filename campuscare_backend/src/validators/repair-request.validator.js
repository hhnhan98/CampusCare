import {
  ALLOWED_CATEGORIES,
  ALLOWED_PRIORITIES,
  ALLOWED_SORT_FIELDS,
  ALLOWED_SORT_ORDERS,
  ALLOWED_STATUSES,
} from "../constants/repair-request.constants.js";
import AppError from "../utils/app-error.js";

const STATUS_LABELS = {
  PENDING: "Ch? x? l?",
  IN_PROGRESS: "?ang x? l?",
  COMPLETED: "?? ho?n th?nh",
};

const ALLOWED_STATUS_TRANSITIONS = {
  PENDING: ["PENDING", "IN_PROGRESS"],
  IN_PROGRESS: ["IN_PROGRESS", "COMPLETED"],
  COMPLETED: ["COMPLETED"],
};

function validateRequiredString(value, fieldName, maxLength) {
  if (typeof value !== "string" || value.trim() === "") {
    throw new AppError(`${fieldName} l? b?t bu?c`, 400, "VALIDATION_ERROR");
  }

  const normalizedValue = value.trim();

  if (normalizedValue.length > maxLength) {
    throw new AppError(
      `${fieldName} kh?ng ???c v??t qu? ${maxLength} k? t?`,
      400,
      "VALIDATION_ERROR",
    );
  }

  return normalizedValue;
}

function validateRepairRequestId(id) {
  const repairRequestId = Number(id);

  if (!Number.isInteger(repairRequestId) || repairRequestId <= 0) {
    throw new AppError("ID y?u c?u kh?ng h?p l?", 400, "VALIDATION_ERROR");
  }

  return repairRequestId;
}

function validateCreateRepairRequest(body) {
  const { title, description, category, priority, campus, location } = body;

  const normalizedTitle = validateRequiredString(title, "Ti?u ??", 150);

  const normalizedDescription = validateRequiredString(
    description,
    "M? t?",
    2000,
  );

  const normalizedCampus = validateRequiredString(campus, "C? s?", 100);

  const normalizedLocation = validateRequiredString(location, "V? tr?", 150);

  if (typeof category !== "string" || !ALLOWED_CATEGORIES.includes(category)) {
    throw new AppError("Lo?i s? c? kh?ng h?p l?", 400, "VALIDATION_ERROR");
  }

  if (typeof priority !== "string" || !ALLOWED_PRIORITIES.includes(priority)) {
    throw new AppError("M?c ?? ?u ti?n kh?ng h?p l?", 400, "VALIDATION_ERROR");
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
    throw new AppError("Tr?ng th?i l?c kh?ng h?p l?", 400, "VALIDATION_ERROR");
  }

  if (category !== undefined && !ALLOWED_CATEGORIES.includes(category)) {
    throw new AppError("Lo?i s? c? l?c kh?ng h?p l?", 400, "VALIDATION_ERROR");
  }

  if (priority !== undefined && !ALLOWED_PRIORITIES.includes(priority)) {
    throw new AppError(
      "M?c ?? ?u ti?n l?c kh?ng h?p l?",
      400,
      "VALIDATION_ERROR",
    );
  }

  if (!ALLOWED_SORT_FIELDS.includes(sortBy)) {
    throw new AppError("Tr??ng s?p x?p kh?ng h?p l?", 400, "VALIDATION_ERROR");
  }

  if (!ALLOWED_SORT_ORDERS.includes(sortOrder)) {
    throw new AppError("Th? t? s?p x?p kh?ng h?p l?", 400, "VALIDATION_ERROR");
  }

  let normalizedSearch;

  if (search !== undefined) {
    if (typeof search !== "string") {
      throw new AppError(
        "T? kh?a t?m ki?m kh?ng h?p l?",
        400,
        "VALIDATION_ERROR",
      );
    }

    normalizedSearch = search.trim();

    if (normalizedSearch.length > 100) {
      throw new AppError(
        "T? kh?a t?m ki?m kh?ng ???c v??t qu? 100 k? t?",
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
      throw new AppError("S? trang kh?ng h?p l?", 400, "VALIDATION_ERROR");
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
        "K?ch th??c trang kh?ng h?p l?",
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
      "Tr?ng th?i y?u c?u kh?ng h?p l?",
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
          "Ghi ch? x? l? ph?i l? chu?i",
          400,
          "VALIDATION_ERROR",
        );
      }

      normalizedManagerNote = managerNote.trim();

      if (normalizedManagerNote.length > 2000) {
        throw new AppError(
          "Ghi ch? x? l? kh?ng ???c v??t qu? 2000 k? t?",
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

function validateStatusTransition(currentStatus, nextStatus) {
  const allowedNextStatuses = ALLOWED_STATUS_TRANSITIONS[currentStatus];

  if (!allowedNextStatuses || !allowedNextStatuses.includes(nextStatus)) {
    const currentLabel = STATUS_LABELS[currentStatus] ?? currentStatus;
    const nextLabel = STATUS_LABELS[nextStatus] ?? nextStatus;

    throw new AppError(
      `Kh?ng th? chuy?n tr?ng th?i t? ${currentLabel} sang ${nextLabel}`,
      409,
      "INVALID_STATUS_TRANSITION",
    );
  }
}

export const repairRequestValidator = {
  validateRepairRequestId,
  validateCreateRepairRequest,
  validateRepairRequestFilters,
  validateStatusUpdate,
  validateStatusTransition,
  validatePagination,
};
