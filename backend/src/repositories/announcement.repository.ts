import { db } from '../config/database.js';
import type { Announcement } from '../models/announcement.js';

export async function findAllAnnouncements(): Promise<Announcement[]> {
  const result = await db.query<Announcement>(
    `SELECT
       id,
       title,
       description,
       published_at AS "publishedAt",
       is_read      AS "isRead"
     FROM announcements
     ORDER BY published_at DESC`,
  );

  return result.rows;
}
