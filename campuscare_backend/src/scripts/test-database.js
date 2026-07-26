import prisma from "../config/prisma.js";

async function testDatabaseConnection() {
  try {
    const users = await prisma.user.findMany({
      select: {
        id: true,
        username: true,
        fullName: true,
        studentCode: true,
        role: true,
      },
      orderBy: {
        id: "asc",
      },
    });

    console.log("Database connection successful.");
    console.table(users);
  } catch (error) {
    console.error("Database connection failed:", error);
    process.exitCode = 1;
  } finally {
    await prisma.$disconnect();
  }
}

testDatabaseConnection();