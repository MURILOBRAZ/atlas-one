import type { FastifyReply, FastifyRequest } from 'fastify';
import { listAnnouncements } from '../services/announcement.service.js';

export async function getAnnouncements(_request: FastifyRequest, reply: FastifyReply) {
  const announcements = await listAnnouncements();
  return reply.send(announcements);
}
