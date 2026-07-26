import multer from "multer";

function errorMiddleware(error, req, res, next) {
  if (error instanceof multer.MulterError) {
    if (error.code === "LIMIT_FILE_SIZE") {
      return res.status(400).json({
        success: false,
        message: "Ảnh vượt quá dung lượng cho phép 5 MB",
        error: {
          code: "FILE_TOO_LARGE",
        },
      });
    }

    return res.status(400).json({
      success: false,
      message: "Không thể tải ảnh lên",
      error: {
        code: "UPLOAD_ERROR",
        ...(process.env.NODE_ENV === "development" && {
          details: error.message,
        }),
      },
    });
  }

  const statusCode = error.statusCode || 500;
  const code = error.code || "INTERNAL_SERVER_ERROR";

  if (statusCode >= 500) {
    console.error(error);
  }

  const response = {
    success: false,
    message: statusCode >= 500 ? "Đã xảy ra lỗi trong hệ thống" : error.message,
    error: {
      code,
    },
  };

  if (process.env.NODE_ENV === "development" && statusCode >= 500) {
    response.error.details = error.message;
  }

  return res.status(statusCode).json(response);
}

export default errorMiddleware;
