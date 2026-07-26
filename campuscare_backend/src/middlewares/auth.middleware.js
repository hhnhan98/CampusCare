import jwt from "jsonwebtoken";

import prisma from "../config/prisma.js";
import AppError from "../utils/app-error.js";

async function authenticate(req, res, next) {
  try {
    const authorizationHeader = req.headers.authorization;

    if (
      typeof authorizationHeader !== "string" ||
      !authorizationHeader.startsWith("Bearer ")
    ) {
      throw new AppError(
        "Bạn chưa cung cấp access token",
        401,
        "AUTHENTICATION_REQUIRED",
      );
    }

    const accessToken = authorizationHeader.slice(7).trim();

    if (!accessToken) {
      throw new AppError(
        "Access token không hợp lệ",
        401,
        "INVALID_ACCESS_TOKEN",
      );
    }

    const jwtSecret = process.env.JWT_SECRET;

    if (!jwtSecret) {
      throw new AppError(
        "JWT_SECRET chưa được cấu hình",
        500,
        "JWT_CONFIGURATION_ERROR",
      );
    }

    let payload;

    try {
      payload = jwt.verify(accessToken, jwtSecret);
    } catch (error) {
      if (error.name === "TokenExpiredError") {
        throw new AppError(
          "Phiên đăng nhập đã hết hạn",
          401,
          "ACCESS_TOKEN_EXPIRED",
        );
      }

      throw new AppError(
        "Access token không hợp lệ",
        401,
        "INVALID_ACCESS_TOKEN",
      );
    }

    const userId = Number(payload.sub);

    if (!Number.isInteger(userId) || userId <= 0) {
      throw new AppError(
        "Access token không hợp lệ",
        401,
        "INVALID_ACCESS_TOKEN",
      );
    }

    const user = await prisma.user.findUnique({
      where: {
        id: userId,
      },
      select: {
        id: true,
        username: true,
        fullName: true,
        studentCode: true,
        role: true,
      },
    });

    if (!user) {
      throw new AppError(
        "Tài khoản không còn tồn tại",
        401,
        "USER_NOT_FOUND",
      );
    }

    req.user = user;

    return next();
  } catch (error) {
    return next(error);
  }
}

export default authenticate;