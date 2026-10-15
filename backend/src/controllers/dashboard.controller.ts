import type { FastifyReply, FastifyRequest } from 'fastify';
import { getDashboardSummary } from '../services/dashboard.service.js';

export async function getDashboard(_request: FastifyRequest, reply: FastifyReply) {
  const summary = await getDashboardSummary();
  return reply.send(summary);
}
