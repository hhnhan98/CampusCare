import AppError from "../utils/app-error.js";

function notFoundMiddleware(req, res, next) {
  const error = new AppError(
    `Không tìm thấy endpoint ${req.method} ${req.originalUrl}`,
    404,
    "ROUTE_NOT_FOUND",
  );

  return next(error);
}

export default notFoundMiddleware;