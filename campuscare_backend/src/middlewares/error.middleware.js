function errorMiddleware(error, req, res, next) {
  const statusCode = error.statusCode || 500;
  const code = error.code || "INTERNAL_SERVER_ERROR";

  if (statusCode >= 500) {
    console.error(error);
  }

  const response = {
    success: false,
    message:
      statusCode >= 500
        ? "Đã xảy ra lỗi trong hệ thống"
        : error.message,
    error: {
      code,
    },
  };

  if (
    process.env.NODE_ENV === "development" &&
    statusCode >= 500
  ) {
    response.error.details = error.message;
  }

  return res.status(statusCode).json(response);
}

export default errorMiddleware;