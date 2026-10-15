import type { FastifyReply, FastifyRequest } from 'fastify';
import { getOperationsPreview } from '../services/operation.service.js';

export async function getPreview(_request: FastifyRequest, reply: FastifyReply) {
  const operations = await getOperationsPreview();
  return reply.send(operations);
}
