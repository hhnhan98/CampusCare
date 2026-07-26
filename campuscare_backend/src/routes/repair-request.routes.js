import { Router } from "express";

import { repairRequestController } from "../controllers/repair-request.controller.js";
import authenticate from "../middlewares/auth.middleware.js";
import authorize from "../middlewares/authorize.middleware.js";

const repairRequestRouter = Router();

repairRequestRouter.post(
  "/",
  authenticate,
  authorize("USER"),
  repairRequestController.createRepairRequest,
);

export default repairRequestRouter;