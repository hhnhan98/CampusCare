import 'dotenv/config';

import app from './app.js';

const port = Number(process.env.PORT) || 3000;

const server = app.listen(port, '0.0.0.0', () => {
  console.log(`CampusCare API is running on http://localhost:${port}`);
});

const shutdown = (signal) => {
  console.log(`\nReceived ${signal}. Shutting down server...`);

  server.close(() => {
    console.log('HTTP server closed.');
    process.exit(0);
  });
};

process.on('SIGINT', () => shutdown('SIGINT'));
process.on('SIGTERM', () => shutdown('SIGTERM'));