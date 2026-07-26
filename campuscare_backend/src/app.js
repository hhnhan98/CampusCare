import path from "node:path";
import { fileURLToPath } from "node:url";

import cors from "cors";
import express from "express";
import helmet from "helmet";
import morgan from "morgan";

import errorMiddleware from "./middlewares/error.middleware.js";
import notFoundMiddleware from "./middlewares/not-found.middleware.js";
import authRouter from "./routes/auth.routes.js";
import dashboardRouter from "./routes/dashboard.route.js";
import repairRequestRouter from "./routes/repair-request.routes.js";

const app = express();

const currentFilePath = fileURLToPath(import.meta.url);
const currentDirectory = path.dirname(currentFilePath);
const projectRoot = path.resolve(currentDirectory, "..");
const uploadsDirectory = path.join(projectRoot, "uploads");

app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use("/uploads", express.static(uploadsDirectory));

if (process.env.NODE_ENV === "development") {
  app.use(morgan("dev"));
}

app.get("/api/health", (req, res) => {
  return res.status(200).json({
    success: true,
    message: "CampusCare API is running",
    timestamp: new Date().toISOString(),
  });
});

app.use("/api/auth", authRouter);
app.use("/api/repair-requests", repairRequestRouter);
app.use("/api/dashboard", dashboardRouter);

app.use(notFoundMiddleware);
app.use(errorMiddleware);

export default app;
