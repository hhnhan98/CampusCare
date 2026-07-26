import prisma from "../config/prisma.js";

async function createRepairRequest({
  title,
  description,
  category,
  priority,
  campus,
  location,
  createdBy,
}) {
  return prisma.repairRequest.create({
    data: {
      title,
      description,
      category,
      priority,
      campus,
      location,
      createdBy,
    },
    select: {
      id: true,
      title: true,
      description: true,
      category: true,
      priority: true,
      campus: true,
      location: true,
      imageUrl: true,
      status: true,
      managerNote: true,
      createdAt: true,
      updatedAt: true,
      creator: {
        select: {
          id: true,
          username: true,
          fullName: true,
          studentCode: true,
          role: true,
        },
      },
    },
  });
}

async function getRepairRequests({ userId, role }) {
  const where = role === "USER"
    ? {
        createdBy: userId,
      }
    : {};

  return prisma.repairRequest.findMany({
    where,
    orderBy: {
      createdAt: "desc",
    },
    select: {
      id: true,
      title: true,
      description: true,
      category: true,
      priority: true,
      campus: true,
      location: true,
      imageUrl: true,
      status: true,
      managerNote: true,
      createdAt: true,
      updatedAt: true,
      creator: {
        select: {
          id: true,
          username: true,
          fullName: true,
          studentCode: true,
          role: true,
        },
      },
    },
  });
}

async function getRepairRequestById({
  repairRequestId,
  userId,
  role,
}) {
  const where = {
    id: repairRequestId,
    ...(role === "USER"
      ? {
          createdBy: userId,
        }
      : {}),
  };

  return prisma.repairRequest.findFirst({
    where,
    select: {
      id: true,
      title: true,
      description: true,
      category: true,
      priority: true,
      campus: true,
      location: true,
      imageUrl: true,
      status: true,
      managerNote: true,
      createdAt: true,
      updatedAt: true,
      creator: {
        select: {
          id: true,
          username: true,
          fullName: true,
          studentCode: true,
          role: true,
        },
      },
    },
  });
}

async function updateRepairRequestStatus({
  repairRequestId,
  status,
  managerNote,
}) {
  return prisma.repairRequest.update({
    where: {
      id: repairRequestId,
    },
    data: {
      status,
      managerNote,
    },
    select: {
      id: true,
      title: true,
      description: true,
      category: true,
      priority: true,
      campus: true,
      location: true,
      imageUrl: true,
      status: true,
      managerNote: true,
      createdAt: true,
      updatedAt: true,
      creator: {
        select: {
          id: true,
          username: true,
          fullName: true,
          studentCode: true,
          role: true,
        },
      },
    },
  });
}

export const repairRequestService = {
  createRepairRequest,
  getRepairRequests,
  getRepairRequestById,
  updateRepairRequestStatus,
};