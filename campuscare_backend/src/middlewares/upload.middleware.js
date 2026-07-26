import crypto from "node:crypto";
import path from "node:path";
import { fileURLToPath } from "node:url";

import multer from "multer";

import AppError from "../utils/app-error.js";

const currentFilePath = fileURLToPath(import.meta.url);
const currentDirectory = path.dirname(currentFilePath);

const projectRoot = path.resolve(currentDirectory, "../..");

const repairRequestUploadDirectory = path.join(
  projectRoot,
  "uploads",
  "repair-requests",
);

const ALLOWED_MIME_TYPES = ["image/jpeg", "image/png"];

const MAX_IMAGE_SIZE = 5 * 1024 * 1024;

const storage = multer.diskStorage({
  destination(req, file, callback) {
    callback(null, repairRequestUploadDirectory);
  },

  filename(req, file, callback) {
    const fileExtension = path.extname(file.originalname).toLowerCase();
    const uniqueFileName = `${Date.now()}-${crypto.randomUUID()}${fileExtension}`;

    callback(null, uniqueFileName);
  },
});

function imageFileFilter(req, file, callback) {
  if (!ALLOWED_MIME_TYPES.includes(file.mimetype)) {
    return callback(
      new AppError(
        "Ảnh không hợp lệ. Chỉ chấp nhận tệp JPG, JPEG hoặc PNG",
        400,
        "INVALID_IMAGE_TYPE",
      ),
    );
  }

  return callback(null, true);
}

const uploadRepairRequestImage = multer({
  storage,
  limits: {
    fileSize: MAX_IMAGE_SIZE,
    files: 1,
  },
  fileFilter: imageFileFilter,
});

export default uploadRepairRequestImage;
