import cors from "cors";
import express from "express";
import helmet from "helmet";
import morgan from "morgan";

import authRouter from "./routes/auth.routes.js";
import repairRequestRouter from "./routes/repair-request.routes.js";
import errorMiddleware from "./middlewares/error.middleware.js";
import notFoundMiddleware from "./middlewares/not-found.middleware.js";
const app = express();

app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

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

app.use(notFoundMiddleware);
app.use(errorMiddleware);

export default app;