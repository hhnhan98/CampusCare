import bcrypt from "bcrypt";
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

const SALT_ROUNDS = 10;

async function main() {
  const userPassword = process.env.SEED_USER_PASSWORD;
  const managerPassword = process.env.SEED_MANAGER_PASSWORD;

  if (!userPassword || !managerPassword) {
    throw new Error(
      "Missing SEED_USER_PASSWORD or SEED_MANAGER_PASSWORD in .env",
    );
  }

  const [userPasswordHash, managerPasswordHash] = await Promise.all([
    bcrypt.hash(userPassword, SALT_ROUNDS),
    bcrypt.hash(managerPassword, SALT_ROUNDS),
  ]);

  const user = await prisma.user.upsert({
    where: {
      username: "student01",
    },
    update: {
      passwordHash: userPasswordHash,
      fullName: "Nguyễn Văn Sinh Viên",
      studentCode: "2280600001",
      role: "USER",
    },
    create: {
      username: "student01",
      passwordHash: userPasswordHash,
      fullName: "Nguyễn Văn Sinh Viên",
      studentCode: "2280600001",
      role: "USER",
    },
  });

  const manager = await prisma.user.upsert({
    where: {
      username: "manager01",
    },
    update: {
      passwordHash: managerPasswordHash,
      fullName: "Quản lý Cơ sở vật chất",
      studentCode: null,
      role: "MANAGER",
    },
    create: {
      username: "manager01",
      passwordHash: managerPasswordHash,
      fullName: "Quản lý Cơ sở vật chất",
      studentCode: null,
      role: "MANAGER",
    },
  });

  console.log("Seed completed successfully.");

  console.table([
    {
      id: user.id,
      username: user.username,
      role: user.role,
      studentCode: user.studentCode,
    },
    {
      id: manager.id,
      username: manager.username,
      role: manager.role,
      studentCode: manager.studentCode,
    },
  ]);
}

main()
  .catch((error) => {
    console.error("Seed failed:", error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });