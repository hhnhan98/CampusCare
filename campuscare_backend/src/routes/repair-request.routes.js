import { Router } from "express";

import { repairRequestController } from "../controllers/repair-request.controller.js";
import authenticate from "../middlewares/auth.middleware.js";
import authorize from "../middlewares/authorize.middleware.js";

const repairRequestRouter = Router();

repairRequestRouter.get(
  "/",
  authenticate,
  authorize("USER", "MANAGER"),
  repairRequestController.getRepairRequests,
);

repairRequestRouter.get(
  "/:id",
  authenticate,
  authorize("USER", "MANAGER"),
  repairRequestController.getRepairRequestById,
);

repairRequestRouter.patch(
  "/:id/status",
  authenticate,
  authorize("MANAGER"),
  repairRequestController.updateRepairRequestStatus,
);

repairRequestRouter.post(
  "/",
  authenticate,
  authorize("USER"),
  repairRequestController.createRepairRequest,
);

export default repairRequestRouter;