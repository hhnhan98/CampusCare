import { Router } from "express";

import { authController } from "../controllers/auth.controller.js";
import authenticate from "../middlewares/auth.middleware.js";
import authorize from "../middlewares/authorize.middleware.js";

const authRouter = Router();

authRouter.post("/login", authController.login);

authRouter.get(
  "/me",
  authenticate,
  authController.getCurrentUser,
);

authRouter.get(
  "/user-only",
  authenticate,
  authorize("USER"),
  authController.userOnly,
);

authRouter.get(
  "/manager-only",
  authenticate,
  authorize("MANAGER"),
  authController.managerOnly,
);

export default authRouter;