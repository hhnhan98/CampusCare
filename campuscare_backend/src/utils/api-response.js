function sendSuccess(
  res,
  {
    statusCode = 200,
    message = "Thao tác thành công",
    data = null,
  } = {},
) {
  const response = {
    success: true,
    message,
  };

  if (data !== null) {
    response.data = data;
  }

  return res.status(statusCode).json(response);
}

export const apiResponse = {
  sendSuccess,
};