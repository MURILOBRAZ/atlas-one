import type { Operation } from '../models/operation.js';
import { findRecentOperations } from '../repositories/operation.repository.js';

const PREVIEW_SIZE = 3;

/** Pequena amostra das operações mais recentes, exibida na aba Operações. */
export async function getOperationsPreview(): Promise<Operation[]> {
  return findRecentOperations(PREVIEW_SIZE);
}
