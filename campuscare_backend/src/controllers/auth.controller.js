import { authService } from "../services/auth.service.js";
import AppError from "../utils/app-error.js";

async function login(req, res, next) {
  try {
    const { username, password } = req.body;

    if (typeof username !== "string" || username.trim() === "") {
      throw new AppError(
        "Tên đăng nhập là bắt buộc",
        400,
        "VALIDATION_ERROR",
      );
    }

    if (typeof password !== "string" || password === "") {
      throw new AppError(
        "Mật khẩu là bắt buộc",
        400,
        "VALIDATION_ERROR",
      );
    }

    if (username.trim().length > 50) {
      throw new AppError(
        "Tên đăng nhập không được vượt quá 50 ký tự",
        400,
        "VALIDATION_ERROR",
      );
    }

    const result = await authService.login({
      username,
      password,
    });

    return res.status(200).json({
      success: true,
      message: "Đăng nhập thành công",
      data: result,
    });
  } catch (error) {
    return next(error);
  }
}

export const authController = {
  login,
};