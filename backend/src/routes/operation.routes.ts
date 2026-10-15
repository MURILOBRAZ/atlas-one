import type { FastifyInstance } from 'fastify';
import { getPreview } from '../controllers/operation.controller.js';

export async function operationRoutes(app: FastifyInstance) {
  app.get('/operations/preview', getPreview);
}
