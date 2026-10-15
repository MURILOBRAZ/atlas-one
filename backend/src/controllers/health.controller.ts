import type { FastifyReply, FastifyRequest } from 'fastify';
import { checkDatabaseConnection } from '../config/database.js';

export async function getHealth(_request: FastifyRequest, reply: FastifyReply) {
  const databaseConnected = await checkDatabaseConnection();

  return reply.status(databaseConnected ? 200 : 503).send({
    status: databaseConnected ? 'ok' : 'degraded',
    database: databaseConnected ? 'connected' : 'unavailable',
    timestamp: new Date().toISOString(),
  });
}
