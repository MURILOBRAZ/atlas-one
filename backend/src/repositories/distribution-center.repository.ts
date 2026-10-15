import { db } from '../config/database.js';
import type { DistributionCenter } from '../models/distribution-center.js';

export async function findAllDistributionCenters(): Promise<DistributionCenter[]> {
  const result = await db.query<DistributionCenter>(
    `SELECT id, code, name, city, state, status
     FROM distribution_centers
     ORDER BY name`,
  );

  return result.rows;
}
