import { existsSync } from 'node:fs';

// Carrega as variáveis do arquivo .env (recurso nativo do Node.js 22+).
// Em produção, as variáveis normalmente são definidas pelo servidor.
if (existsSync('.env')) {
  process.loadEnvFile('.env');
}

function requireEnv(name: string): string {
  const value = process.env[name];

  if (!value) {
    throw new Error(
      `A variável de ambiente ${name} não foi definida. ` +
        'Crie o arquivo backend/.env a partir de backend/.env.example.',
    );
  }

  return value;
}

export const env = {
  databaseUrl: requireEnv('DATABASE_URL'),
  port: Number(process.env.PORT ?? 3333),
  currentEmployeeRegistration: process.env.CURRENT_EMPLOYEE_REGISTRATION ?? 'ATL-2847',
};
