import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";

import prisma from "../config/prisma.js";
import AppError from "../utils/app-error.js";

function generateAccessToken(user) {
  const jwtSecret = process.env.JWT_SECRET;
  const jwtExpiresIn = process.env.JWT_EXPIRES_IN || "7d";

  if (!jwtSecret) {
    throw new AppError(
      "JWT_SECRET chưa được cấu hình",
      500,
      "JWT_CONFIGURATION_ERROR",
    );
  }

  return jwt.sign(
    {
      role: user.role,
    },
    jwtSecret,
    {
      subject: String(user.id),
      expiresIn: jwtExpiresIn,
    },
  );
}

async function login({ username, password }) {
  const normalizedUsername = username.trim().toLowerCase();

  const user = await prisma.user.findUnique({
    where: {
      username: normalizedUsername,
    },
  });

  if (!user) {
    throw new AppError(
      "Tên đăng nhập hoặc mật khẩu không đúng",
      401,
      "INVALID_CREDENTIALS",
    );
  }

  const passwordMatches = await bcrypt.compare(
    password,
    user.passwordHash,
  );

  if (!passwordMatches) {
    throw new AppError(
      "Tên đăng nhập hoặc mật khẩu không đúng",
      401,
      "INVALID_CREDENTIALS",
    );
  }

  const accessToken = generateAccessToken(user);

  return {
    accessToken,
    tokenType: "Bearer",
    expiresIn: process.env.JWT_EXPIRES_IN || "7d",
    user: {
      id: user.id,
      username: user.username,
      fullName: user.fullName,
      studentCode: user.studentCode,
      role: user.role,
    },
  };
}

export const authService = {
  login,
};