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

  const student01 = await prisma.user.upsert({
    where: {
      username: "student01",
    },
    update: {
      passwordHash: userPasswordHash,
      fullName: "Nguy\u1ec5n V\u0103n Sinh Vi\u00ean",
      studentCode: "2280600001",
      role: "USER",
    },
    create: {
      username: "student01",
      passwordHash: userPasswordHash,
      fullName: "Nguy\u1ec5n V\u0103n Sinh Vi\u00ean",
      studentCode: "2280600001",
      role: "USER",
    },
  });

  const student02 = await prisma.user.upsert({
    where: {
      username: "student02",
    },
    update: {
      passwordHash: userPasswordHash,
      fullName: "Tr\u1ea7n Th\u1ecb Minh Anh",
      studentCode: "2280600002",
      role: "USER",
    },
    create: {
      username: "student02",
      passwordHash: userPasswordHash,
      fullName: "Tr\u1ea7n Th\u1ecb Minh Anh",
      studentCode: "2280600002",
      role: "USER",
    },
  });

  const manager = await prisma.user.upsert({
    where: {
      username: "manager01",
    },
    update: {
      passwordHash: managerPasswordHash,
      fullName: "Qu\u1ea3n l\u00fd C\u01a1 s\u1edf v\u1eadt ch\u1ea5t",
      studentCode: null,
      role: "MANAGER",
    },
    create: {
      username: "manager01",
      passwordHash: managerPasswordHash,
      fullName: "Qu\u1ea3n l\u00fd C\u01a1 s\u1edf v\u1eadt ch\u1ea5t",
      studentCode: null,
      role: "MANAGER",
    },
  });

  console.log("Seed completed successfully.");

  console.table(
    [student01, student02, manager].map((user) => ({
      id: user.id,
      username: user.username,
      role: user.role,
      studentCode: user.studentCode,
    })),
  );
}

main()
  .catch((error) => {
    console.error("Seed failed:", error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
