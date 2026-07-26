import { dashboardService } from "../services/dashboard.service.js";
import { apiResponse } from "../utils/api-response.js";

async function getDashboardSummary(req, res, next) {
  try {
    const summary = await dashboardService.getDashboardSummary({
      userId: req.user.id,
      role: req.user.role,
    });

    return apiResponse.sendSuccess(res, {
      message: "Lấy thống kê tổng quan thành công",
      data: summary,
    });
  } catch (error) {
    return next(error);
  }
}

export const dashboardController = {
  getDashboardSummary,
};
