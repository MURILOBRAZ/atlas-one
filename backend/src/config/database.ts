import { Pool } from '@neondatabase/serverless';
import { env } from './env.js';

// Pool de conexões com o PostgreSQL hospedado no Neon.
// Todas as consultas da API passam por aqui.
export const db = new Pool({ connectionString: env.databaseUrl });

db.on('error', (error: Error) => {
  console.error('Erro inesperado na conexão com o banco:', error.message);
});

/**
 * Retorna apenas o host do banco, para exibir em logs
 * sem expor usuário e senha da connection string.
 */
export function getDatabaseHost(): string {
  try {
    return new URL(env.databaseUrl).host;
  } catch {
    return 'host inválido';
  }
}

export async function checkDatabaseConnection(): Promise<boolean> {
  try {
    await db.query('SELECT 1');
    return true;
  } catch {
    return false;
  }
}
