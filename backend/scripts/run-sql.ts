/**
 * Executa um arquivo .sql no banco Neon configurado em DATABASE_URL.
 *
 * Uso:
 *   npm run db:migrate   -> executa database/schema.sql
 *   npm run db:seed      -> executa database/seed.sql
 */
import { readFileSync } from 'node:fs';
import { db, getDatabaseHost } from '../src/config/database.js';

const filePath = process.argv[2];

if (!filePath) {
  console.error('Informe o arquivo SQL. Ex.: tsx scripts/run-sql.ts ../database/schema.sql');
  process.exit(1);
}

const sqlScript = readFileSync(filePath, 'utf-8');

try {
  console.log(`Executando ${filePath} em ${getDatabaseHost()}...`);
  await db.query(sqlScript);
  console.log('Concluído com sucesso.');
} catch (error) {
  console.error('Falha ao executar o script:', (error as Error).message);
  process.exitCode = 1;
} finally {
  await db.end();
}
