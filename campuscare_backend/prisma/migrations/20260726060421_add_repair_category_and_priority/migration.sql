/*
  Warnings:

  - Added the required column `priority` to the `repair_requests` table without a default value. This is not possible if the table is not empty.
  - Changed the type of `category` on the `repair_requests` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- CreateEnum
CREATE TYPE "RepairCategory" AS ENUM ('ELECTRICAL', 'WATER', 'AIR_CONDITIONER', 'INTERNET', 'FURNITURE', 'OTHER');

-- CreateEnum
CREATE TYPE "RepairPriority" AS ENUM ('LOW', 'MEDIUM', 'HIGH');

-- AlterTable
ALTER TABLE "repair_requests" ADD COLUMN     "priority" "RepairPriority" NOT NULL,
DROP COLUMN "category",
ADD COLUMN     "category" "RepairCategory" NOT NULL;

-- CreateIndex
CREATE INDEX "repair_requests_category_idx" ON "repair_requests"("category");

-- CreateIndex
CREATE INDEX "repair_requests_priority_idx" ON "repair_requests"("priority");
