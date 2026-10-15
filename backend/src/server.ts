import cors from '@fastify/cors';
import Fastify, { type FastifyError } from 'fastify';
import { getDatabaseHost } from './config/database.js';
import { env } from './config/env.js';
import { HttpError } from './errors/http-error.js';
import { registerRoutes } from './routes/index.js';

const app = Fastify({ logger: true });

// Permite que o Flutter Web (rodando em outra porta) acesse a API.
await app.register(cors, {
  origin: true,
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE'],
});

// Os handlers de erro precisam ser definidos ANTES das rotas
// para valerem para todas elas.
// Todas as respostas de erro seguem o formato { "message": "..." }.
app.setErrorHandler((error: FastifyError, request, reply) => {
  if (error.validation) {
    return reply.status(400).send({ message: 'Dados inválidos.', details: error.message });
  }

  if (error instanceof HttpError) {
    return reply.status(error.statusCode).send({ message: error.message });
  }

  // Erros do cliente detectados pelo Fastify (ex.: JSON malformado).
  if (error.statusCode && error.statusCode < 500) {
    return reply.status(error.statusCode).send({ message: 'Requisição inválida.' });
  }

  request.log.error(error);
  return reply.status(500).send({ message: 'Erro interno no servidor. Tente novamente mais tarde.' });
});

app.setNotFoundHandler((_request, reply) => {
  reply.status(404).send({ message: 'Rota não encontrada.' });
});

await registerRoutes(app);

// 0.0.0.0 permite acesso pelo emulador Android e por dispositivos na mesma rede.
// Sem "await" de propósito: na Vercel o listen é interceptado e nunca conclui,
// e esperar por ele travaria o carregamento da função.
app
  .listen({ port: env.port, host: '0.0.0.0' })
  .then(() => app.log.info(`Banco de dados configurado: ${getDatabaseHost()}`))
  .catch((error) => {
    app.log.error(error);
    process.exit(1);
  });
