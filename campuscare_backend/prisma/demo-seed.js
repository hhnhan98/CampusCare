import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

function hoursAgo(hours) {
  return new Date(Date.now() - hours * 60 * 60 * 1000);
}

async function findDemoUser(username) {
  const user = await prisma.user.findUnique({
    where: {
      username,
    },
    select: {
      id: true,
      username: true,
      fullName: true,
      role: true,
    },
  });

  if (!user) {
    throw new Error(
      `Demo user "${username}" was not found. Run the main seed first.`,
    );
  }

  if (user.role !== "USER") {
    throw new Error(
      `Demo account "${username}" must have role USER.`,
    );
  }

  return user;
}

async function main() {
  const [student01, student02] = await Promise.all([
    findDemoUser("student01"),
    findDemoUser("student02"),
  ]);

  const deletedResult = await prisma.repairRequest.deleteMany();

  const demoRequests = [
    {
      title: "\u0110\u00e8n ph\u00f2ng A-101 kh\u00f4ng ho\u1ea1t \u0111\u1ed9ng",
      description:
        "Hai b\u00f3ng \u0111\u00e8n ph\u00eda cu\u1ed1i ph\u00f2ng A-101 kh\u00f4ng s\u00e1ng, l\u00e0m khu v\u1ef1c h\u1ecdc b\u1ecb thi\u1ebfu \u00e1nh s\u00e1ng.",
      category: "ELECTRICAL",
      priority: "HIGH",
      campus: "C\u01a1 s\u1edf ch\u00ednh",
      location: "Ph\u00f2ng A-101",
      imageUrl: null,
      status: "PENDING",
      managerNote: null,
      createdBy: student01.id,
      createdAt: hoursAgo(2),
      updatedAt: hoursAgo(2),
    },
    {
      title: "M\u00e1y l\u1ea1nh ph\u00f2ng B-203 kh\u00f4ng m\u00e1t",
      description:
        "M\u00e1y l\u1ea1nh v\u1eabn ho\u1ea1t \u0111\u1ed9ng nh\u01b0ng kh\u00f4ng l\u00e0m m\u00e1t ph\u00f2ng, c\u00f3 ti\u1ebfng k\u00eau nh\u1eb9 khi kh\u1edfi \u0111\u1ed9ng.",
      category: "AIR_CONDITIONER",
      priority: "MEDIUM",
      campus: "C\u01a1 s\u1edf ch\u00ednh",
      location: "Ph\u00f2ng B-203",
      imageUrl: null,
      status: "IN_PROGRESS",
      managerNote:
        "\u0110\u00e3 ti\u1ebfp nh\u1eadn v\u00e0 chuy\u1ec3n b\u1ed9 ph\u1eadn k\u1ef9 thu\u1eadt ki\u1ec3m tra.",
      createdBy: student01.id,
      createdAt: hoursAgo(26),
      updatedAt: hoursAgo(5),
    },
    {
      title: "V\u00f2i n\u01b0\u1edbc nh\u00e0 v\u1ec7 sinh b\u1ecb r\u00f2 r\u1ec9",
      description:
        "V\u00f2i r\u1eeda tay t\u1ea1i nh\u00e0 v\u1ec7 sinh t\u1ea7ng 2 b\u1ecb r\u00f2 n\u01b0\u1edbc li\u00ean t\u1ee5c.",
      category: "WATER",
      priority: "HIGH",
      campus: "C\u01a1 s\u1edf ch\u00ednh",
      location: "Nh\u00e0 v\u1ec7 sinh t\u1ea7ng 2, khu A",
      imageUrl: null,
      status: "COMPLETED",
      managerNote:
        "\u0110\u00e3 thay ron v\u00f2i n\u01b0\u1edbc v\u00e0 ki\u1ec3m tra ho\u1ea1t \u0111\u1ed9ng \u1ed5n \u0111\u1ecbnh.",
      createdBy: student01.id,
      createdAt: hoursAgo(52),
      updatedAt: hoursAgo(28),
    },
    {
      title: "B\u00e0n h\u1ecdc ph\u00f2ng C-305 b\u1ecb g\u00e3y",
      description:
        "M\u1ed9t b\u00e0n h\u1ecdc \u1edf h\u00e0ng cu\u1ed1i b\u1ecb g\u00e3y ch\u00e2n v\u00e0 kh\u00f4ng th\u1ec3 s\u1eed d\u1ee5ng an to\u00e0n.",
      category: "FURNITURE",
      priority: "MEDIUM",
      campus: "C\u01a1 s\u1edf ch\u00ednh",
      location: "Ph\u00f2ng C-305",
      imageUrl: null,
      status: "PENDING",
      managerNote: null,
      createdBy: student02.id,
      createdAt: hoursAgo(74),
      updatedAt: hoursAgo(74),
    },
    {
      title: "Wi-Fi th\u01b0 vi\u1ec7n kh\u00f4ng \u1ed5n \u0111\u1ecbnh",
      description:
        "M\u1ea1ng Wi-Fi t\u1ea1i khu t\u1ef1 h\u1ecdc th\u01b0\u1eddng xuy\u00ean m\u1ea5t k\u1ebft n\u1ed1i v\u00e0 t\u1ed1c \u0111\u1ed9 truy c\u1eadp ch\u1eadm.",
      category: "INTERNET",
      priority: "MEDIUM",
      campus: "C\u01a1 s\u1edf ch\u00ednh",
      location: "Th\u01b0 vi\u1ec7n, khu t\u1ef1 h\u1ecdc t\u1ea7ng 3",
      imageUrl: null,
      status: "IN_PROGRESS",
      managerNote:
        "B\u1ed9 ph\u1eadn IT \u0111ang ki\u1ec3m tra thi\u1ebft b\u1ecb ph\u00e1t s\u00f3ng t\u1ea1i t\u1ea7ng 3.",
      createdBy: student02.id,
      createdAt: hoursAgo(98),
      updatedAt: hoursAgo(14),
    },
  ];

  const createdResult = await prisma.repairRequest.createMany({
    data: demoRequests,
  });

  const seededRequests = await prisma.repairRequest.findMany({
    orderBy: {
      createdAt: "desc",
    },
    select: {
      id: true,
      title: true,
      category: true,
      priority: true,
      status: true,
      managerNote: true,
      creator: {
        select: {
          username: true,
        },
      },
    },
  });

  console.log("");
  console.log("Demo seed completed successfully.");
  console.log(`Deleted repair requests: ${deletedResult.count}`);
  console.log(`Created demo requests: ${createdResult.count}`);
  console.log("");

  console.table(
    seededRequests.map((request) => ({
      id: request.id,
      creator: request.creator.username,
      title: request.title,
      category: request.category,
      priority: request.priority,
      status: request.status,
      hasManagerNote: request.managerNote !== null,
    })),
  );
}

main()
  .catch((error) => {
    console.error("Demo seed failed:", error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
