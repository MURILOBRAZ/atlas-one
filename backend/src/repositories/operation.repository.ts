import { db } from '../config/database.js';
import type { Operation } from '../models/operation.js';

export async function findRecentOperations(limit: number): Promise<Operation[]> {
  const result = await db.query<Operation>(
    `SELECT
       id,
       code,
       origin,
       destination,
       status,
       scheduled_date AS "scheduledDate"
     FROM operations
     ORDER BY scheduled_date DESC
     LIMIT $1`,
    [limit],
  );

  return result.rows;
}

/** Operações que ainda não foram finalizadas. */
export async function countActiveOperations(): Promise<number> {
  const result = await db.query<{ total: number }>(
    `SELECT COUNT(*)::int AS total
     FROM operations
     WHERE status IN ('awaiting_pickup', 'in_transit', 'delayed')`,
  );

  return result.rows[0].total;
}

/** Operações finalizadas com data prevista para hoje. */
export async function countDeliveriesToday(): Promise<number> {
  const result = await db.query<{ total: number }>(
    `SELECT COUNT(*)::int AS total
     FROM operations
     WHERE status = 'completed'
       AND scheduled_date::date = CURRENT_DATE`,
  );

  return result.rows[0].total;
}
