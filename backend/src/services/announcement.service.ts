import type { Announcement } from '../models/announcement.js';
import { findAllAnnouncements } from '../repositories/announcement.repository.js';

export async function listAnnouncements(): Promise<Announcement[]> {
  return findAllAnnouncements();
}
