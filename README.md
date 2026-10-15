# Atlas One

Aplicativo corporativo interno da **Atlas Logistics**, usado pelos funcionários para acompanhar as operações logísticas, os centros de distribuição e os comunicados da empresa.

> **Status:** versão 1.0, em desenvolvimento ativo. Vários módulos ainda estão em construção e serão liberados em próximas versões.

---

## Sobre a Atlas Logistics

A Atlas Logistics é uma operadora logística com atuação no transporte rodoviário de cargas e na gestão de centros de distribuição (CDs) no estado de São Paulo. A empresa atende clientes empresariais de varejo, indústria e e-commerce.

O **Atlas One** é o aplicativo único de trabalho da empresa: ele reúne indicadores, operações, avisos e dados do colaborador. Com o tempo, deve substituir planilhas e sistemas legados usados por operadores, supervisores, motoristas e gerentes.

Mais detalhes sobre o negócio estão em [docs/COMPANY_CONTEXT.md](docs/COMPANY_CONTEXT.md).

---

## Arquitetura

```
┌──────────────────────┐
│   Atlas One (app)    │  Flutter · Android e Web
└──────────┬───────────┘
           │ HTTP / JSON
┌──────────▼───────────┐
│      Atlas API       │  Node.js · TypeScript · Fastify
└──────────┬───────────┘
           │ SQL
┌──────────▼───────────┐
│   Neon PostgreSQL    │  Banco oficial da aplicação
└──────────────────────┘
```

- O aplicativo **nunca** acessa o banco de dados diretamente e não conhece nenhuma credencial do PostgreSQL.
- A connection string do banco (`DATABASE_URL`) existe apenas no backend, em um arquivo `.env` que não é versionado.

---

## Tecnologias

| Camada   | Tecnologias |
|----------|-------------|
| Mobile   | Flutter 3.41+, Dart 3.11+, Material 3, pacote `http` |
| Backend  | Node.js 22+, TypeScript, Fastify 5, `@fastify/cors` |
| Banco    | PostgreSQL no [Neon](https://neon.tech), driver `@neondatabase/serverless` |

---

## Estrutura do repositório

```
atlas-one/
├── mobile/      Aplicativo Flutter (Atlas One) + vercel.json do build web
├── backend/     API REST (Atlas API)
├── database/    Scripts SQL: estrutura (schema.sql) e dados iniciais (seed.sql)
└── docs/        Documentação complementar
```

### mobile/

```
lib/
├── main.dart                 Ponto de entrada
├── app/
│   ├── app.dart              MaterialApp, temas
│   ├── home_shell.dart       Navegação inferior (NavigationBar)
│   └── theme/                Paleta de cores e ThemeData (claro e escuro)
├── core/
│   ├── config/               api_config.dart: endereço da Atlas API
│   ├── constants/            Espaçamentos, raios e constantes gerais
│   ├── utils/                Formatação de datas
│   └── widgets/              Componentes reutilizáveis (StatusBadge, MetricCard...)
├── models/                   Employee, Operation, DistributionCenter, Announcement...
├── data/
│   ├── services/             api_service.dart: comunicação HTTP
│   └── repositories/         Um repository por assunto (perfil, operações...)
└── features/
    ├── dashboard/            Tela inicial e indicadores
    ├── operations/           Módulo de operações (prévia)
    ├── announcements/        Avisos internos
    └── profile/              Perfil e edição de perfil
```

Cada feature tem `pages/` (telas) e `widgets/` (componentes usados só por aquela feature).

### backend/

```
src/
├── server.ts        Cria o servidor, registra CORS, tratamento de erros e rotas
├── config/          env.ts (variáveis de ambiente) e database.ts (conexão com o Neon)
├── routes/          Define as URLs e a validação de entrada
├── controllers/     Recebem a requisição e devolvem a resposta HTTP
├── services/        Regras de negócio
├── repositories/    Consultas SQL
├── models/          Tipos TypeScript das entidades
└── errors/          Erros HTTP conhecidos (ex.: 404)
scripts/
└── run-sql.ts       Executa os arquivos de database/ no Neon
```

Fluxo de uma requisição: **Route → Controller → Service → Repository → Banco**.

---

## Configuração do ambiente

Pré-requisitos: [Flutter](https://docs.flutter.dev/get-started/install), [Node.js 22+](https://nodejs.org) e uma conta gratuita no [Neon](https://neon.tech).
**Não é necessário instalar PostgreSQL localmente.**

### 1. Criar o projeto no Neon

1. Acesse [console.neon.tech](https://console.neon.tech) e crie um novo projeto (ex.: `atlas-one`).
2. Escolha a região mais próxima (ex.: *AWS South America (São Paulo)*, se disponível).
3. O Neon cria automaticamente um banco (`neondb`) e um usuário.

### 2. Obter a `DATABASE_URL`

No painel do projeto, clique em **Connect** e copie a *connection string*. Ela tem o formato:

```
postgresql://USUARIO:SENHA@ep-xxxx.sa-east-1.aws.neon.tech/neondb?sslmode=require
```

> Essa string contém a senha do banco. Não a compartilhe, não a envie para o Git e não a coloque no aplicativo Flutter.

### 3. Criar o arquivo `.env`

```bash
cd backend
cp .env.example .env
```

Edite `backend/.env` e cole a connection string em `DATABASE_URL`.

| Variável | Descrição | Padrão |
|----------|-----------|--------|
| `DATABASE_URL` | Connection string do Neon (obrigatória) | — |
| `PORT` | Porta da API | `3333` |
| `CURRENT_EMPLOYEE_REGISTRATION` | Matrícula do funcionário considerado "logado" (ainda não há autenticação) | `ATL-2847` |

### 4. Instalar dependências e criar as tabelas

```bash
cd backend
npm install
npm run db:migrate
```

### 5. Popular o banco com os dados iniciais

```bash
npm run db:seed
```

> O seed **apaga** os dados atuais e recria o conjunto de demonstração. Use-o também para restaurar o ambiente ao estado original.

### 6. Iniciar o backend

```bash
npm run dev
```

Verifique em [http://localhost:3333/api/health](http://localhost:3333/api/health). A resposta esperada é `{"status":"ok","database":"connected", ...}`.

### 7. Iniciar o aplicativo

Em outro terminal:

```bash
cd mobile
flutter pub get
flutter run
```

---

## Endereço da API no aplicativo

O endereço do backend é definido em um único arquivo: `mobile/lib/core/config/api_config.dart`.

| Onde o app roda | Endereço usado | Observação |
|-----------------|----------------|------------|
| Flutter Web (Chrome) | `http://localhost:3333` | O navegador roda no mesmo computador da API. |
| Emulador Android | `http://10.0.2.2:3333` | `10.0.2.2` é o endereço do computador visto de dentro do emulador. `localhost` apontaria para o próprio emulador. |
| Dispositivo físico | IP do computador na rede (ex.: `http://192.168.0.10:3333`) | Celular e computador precisam estar na mesma rede Wi-Fi. |

Para dispositivo físico, informe o endereço na execução:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.0.10:3333
```

Para descobrir o IP do computador: `ipconfig` (Windows) ou `ip addr` / `ifconfig` (Linux/macOS). Se não funcionar, verifique se o firewall permite conexões na porta 3333.

> Em builds de desenvolvimento, o Android permite HTTP sem TLS (configurado em `android/app/src/debug/AndroidManifest.xml`). Builds de release exigirão uma API publicada com HTTPS.

---

## Scripts do backend

| Comando | O que faz |
|---------|-----------|
| `npm run dev` | Inicia a API em modo desenvolvimento, reiniciando a cada alteração no código. |
| `npm run build` | Compila o TypeScript para JavaScript em `dist/`. |
| `npm start` | Executa a versão compilada (`dist/server.js`). Rode `npm run build` antes. |
| `npm run typecheck` | Verifica os tipos sem gerar arquivos. |
| `npm run db:migrate` | Executa `database/schema.sql` no Neon (cria as tabelas que ainda não existem). |
| `npm run db:seed` | Executa `database/seed.sql` no Neon (recria os dados de demonstração). |

## Comandos do aplicativo

| Comando | O que faz |
|---------|-----------|
| `flutter pub get` | Instala as dependências. |
| `flutter run` | Executa o app no dispositivo/emulador selecionado. |
| `flutter run -d chrome` | Executa no navegador. |
| `flutter analyze` | Análise estática do código. |
| `flutter test` | Executa os testes automatizados. |

---

## Publicação na Vercel

O repositório gera **dois projetos** na [Vercel](https://vercel.com) (plano gratuito), ambos importados deste mesmo repositório:

| Projeto | Root Directory | O que publica |
|---------|----------------|---------------|
| Atlas API | `backend` | A API Fastify como Vercel Function (detecção automática de `src/server.ts`). |
| Atlas One Web | `mobile` | O build web do Flutter (`build/web`), configurado em `mobile/vercel.json`. |

Publique a API primeiro, porque o app web precisa do endereço dela.

### 1. Publicar a Atlas API

1. Na Vercel, clique em **Add New → Project** e importe o repositório.
2. Em **Root Directory**, escolha `backend`. O *Framework Preset* deve ficar como **Fastify**.
3. Em **Environment Variables**, cadastre:
   - `DATABASE_URL`: a connection string do Neon (a mesma do `backend/.env`).
   - `CURRENT_EMPLOYEE_REGISTRATION`: `ATL-2847` (opcional).
4. Clique em **Deploy** e teste em `https://SEU-PROJETO.vercel.app/api/health`.

> O banco precisa ter as tabelas e os dados: rode `npm run db:migrate` e `npm run db:seed` localmente (apontando para o mesmo Neon) antes de testar.

### 2. Publicar o app web

1. Importe o mesmo repositório de novo, agora como outro projeto.
2. Em **Root Directory**, escolha `mobile`. O `vercel.json` já define a instalação do Flutter, o build e a pasta de saída.
3. Em **Environment Variables**, cadastre `API_BASE_URL` com o endereço da API publicada, **sem barra no final** (ex.: `https://atlas-api.vercel.app`).
4. Clique em **Deploy**. O primeiro build demora alguns minutos, porque a Vercel baixa o SDK do Flutter.

> O endereço da API é gravado no app **durante o build**. Se `API_BASE_URL` mudar, faça um novo deploy (**Deployments → Redeploy**).

---

## API

Todas as rotas usam o prefixo `/api` e respondem em JSON. Erros seguem o formato `{ "message": "..." }`.

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/health` | Situação da API e da conexão com o banco. |
| `GET` | `/api/dashboard` | Indicadores do dia e situação dos centros de distribuição. |
| `GET` | `/api/profile` | Dados do funcionário atual. |
| `PUT` | `/api/profile` | Atualiza `name`, `phone` e `jobTitle` do funcionário atual. |
| `GET` | `/api/operations/preview` | As 3 operações mais recentes. |
| `GET` | `/api/announcements` | Comunicados internos. |

Exemplo de `PUT /api/profile`:

```json
{
  "name": "Lucas Almeida",
  "phone": "(13) 99812-4471",
  "jobTitle": "Operador Logístico"
}
```

---

## Módulos do aplicativo

| Módulo | Situação |
|--------|----------|
| **Dashboard** | Saudação, situação da rede de CDs, indicadores do dia e resumo operacional. |
| **Operações** | Prévia das operações mais recentes. Consulta completa, detalhes e registro estão em desenvolvimento. |
| **Avisos** | Lista de comunicados internos. |
| **Perfil** | Dados do colaborador e edição de nome, telefone e cargo, gravados no banco. |

### Sobre os dados

Os dados exibidos vêm do banco Neon, populado com um **conjunto de demonstração** (`database/seed.sql`): 3 centros de distribuição, 3 funcionários, 5 operações e 4 avisos.

Alguns indicadores do Dashboard (**Ocorrências** e **Dentro do prazo**) ainda são **valores provisórios** definidos na API, pois as tabelas de ocorrências e de prazos ainda não existem.

Ainda não há autenticação: a API considera como usuário atual o funcionário definido em `CURRENT_EMPLOYEE_REGISTRATION` (por padrão, Lucas Almeida, matrícula ATL-2847).

---

## Segurança

- `DATABASE_URL` fica apenas em `backend/.env`, que está no `.gitignore`.
- O aplicativo Flutter não possui nenhuma credencial de banco.
- Os logs da API exibem apenas o host do banco, nunca usuário ou senha.
- Todas as consultas SQL são parametrizadas (`$1`, `$2`...).
- O corpo das requisições de escrita é validado pela API antes de chegar ao banco.
