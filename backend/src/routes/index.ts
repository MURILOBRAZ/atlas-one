import type { FastifyInstance } from 'fastify';
import { announcementRoutes } from './announcement.routes.js';
import { dashboardRoutes } from './dashboard.routes.js';
import { healthRoutes } from './health.routes.js';
import { operationRoutes } from './operation.routes.js';
import { profileRoutes } from './profile.routes.js';

/** Registra todas as rotas da API sob o prefixo /api. */
export async function registerRoutes(app: FastifyInstance) {
  await app.register(healthRoutes, { prefix: '/api' });
  await app.register(dashboardRoutes, { prefix: '/api' });
  await app.register(profileRoutes, { prefix: '/api' });
  await app.register(operationRoutes, { prefix: '/api' });
  await app.register(announcementRoutes, { prefix: '/api' });
}
