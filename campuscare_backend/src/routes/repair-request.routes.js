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

repairRequestRouter.post(
  "/",
  authenticate,
  authorize("USER"),
  repairRequestController.createRepairRequest,
);

export default repairRequestRouter;