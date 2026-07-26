import prisma from "../config/prisma.js";

async function getDashboardSummary({ userId, role }) {
  const where = role === "MANAGER" ? {} : { createdBy: userId };

  const [totalRequests, pending, inProgress, completed] =
    await prisma.$transaction([
      prisma.repairRequest.count({
        where,
      }),

      prisma.repairRequest.count({
        where: {
          ...where,
          status: "PENDING",
        },
      }),

      prisma.repairRequest.count({
        where: {
          ...where,
          status: "IN_PROGRESS",
        },
      }),

      prisma.repairRequest.count({
        where: {
          ...where,
          status: "COMPLETED",
        },
      }),
    ]);

  return {
    totalRequests,
    pending,
    inProgress,
    completed,
  };
}

export const dashboardService = {
  getDashboardSummary,
};
