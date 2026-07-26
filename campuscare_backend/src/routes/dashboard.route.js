import express from "express";
import { dashboardController } from "../controllers/dashboard.controller.js";
import authenticate from "../middlewares/auth.middleware.js";

const router = express.Router();

router.get("/summary", authenticate, dashboardController.getDashboardSummary);

export default router;
