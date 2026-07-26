import AppError from "../utils/app-error.js";

function authorize(...allowedRoles) {
  return function authorizationMiddleware(req, res, next) {
    if (!req.user) {
      return next(
        new AppError(
          "Bạn chưa đăng nhập",
          401,
          "AUTHENTICATION_REQUIRED",
        ),
      );
    }

    if (!allowedRoles.includes(req.user.role)) {
      return next(
        new AppError(
          "Bạn không có quyền thực hiện thao tác này",
          403,
          "FORBIDDEN",
        ),
      );
    }

    return next();
  };
}

export default authorize;