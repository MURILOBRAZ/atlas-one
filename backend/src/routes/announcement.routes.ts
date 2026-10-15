import type { FastifyInstance } from 'fastify';
import { getAnnouncements } from '../controllers/announcement.controller.js';

export async function announcementRoutes(app: FastifyInstance) {
  app.get('/announcements', getAnnouncements);
}
