# Atlas API

Backend REST do Atlas One (Node.js + TypeScript + Fastify + Neon PostgreSQL).

A documentação completa está no [README principal](../README.md).

```bash
cp .env.example .env   # preencha DATABASE_URL com a connection string do Neon
npm install
npm run db:migrate     # cria as tabelas (database/schema.sql)
npm run db:seed        # recria os dados de demonstração (database/seed.sql)
npm run dev            # http://localhost:3333/api/health
```
