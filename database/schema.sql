-- =====================================================================
-- Atlas One - Estrutura do banco de dados (PostgreSQL / Neon)
--
-- Execução: cd backend && npm run db:migrate
-- O script pode ser executado mais de uma vez (IF NOT EXISTS).
-- =====================================================================

-- Centros de distribuição (CDs) da Atlas Logistics.
CREATE TABLE IF NOT EXISTS distribution_centers (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code        VARCHAR(20)  NOT NULL UNIQUE,
  name        VARCHAR(120) NOT NULL,
  city        VARCHAR(80)  NOT NULL,
  state       CHAR(2)      NOT NULL,
  status      VARCHAR(20)  NOT NULL DEFAULT 'normal'
              CHECK (status IN ('normal', 'attention', 'critical')),
  created_at  TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- Funcionários que utilizam o Atlas One.
CREATE TABLE IF NOT EXISTS employees (
  id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name                    VARCHAR(120) NOT NULL,
  email                   VARCHAR(160) NOT NULL UNIQUE,
  phone                   VARCHAR(20),
  job_title               VARCHAR(80)  NOT NULL,
  registration            VARCHAR(20)  NOT NULL UNIQUE,
  distribution_center_id  UUID REFERENCES distribution_centers (id),
  created_at              TIMESTAMPTZ  NOT NULL DEFAULT now(),
  updated_at              TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- Operações logísticas (transporte de carga entre origem e destino).
CREATE TABLE IF NOT EXISTS operations (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code            VARCHAR(20)  NOT NULL UNIQUE,
  origin          VARCHAR(80)  NOT NULL,
  destination     VARCHAR(80)  NOT NULL,
  status          VARCHAR(20)  NOT NULL DEFAULT 'awaiting_pickup'
                  CHECK (status IN ('awaiting_pickup', 'in_transit', 'delayed', 'completed')),
  scheduled_date  TIMESTAMPTZ  NOT NULL,
  employee_id     UUID REFERENCES employees (id),
  created_at      TIMESTAMPTZ  NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- Comunicados internos exibidos na aba "Avisos".
CREATE TABLE IF NOT EXISTS announcements (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title         VARCHAR(160) NOT NULL,
  description   TEXT         NOT NULL,
  published_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
  is_read       BOOLEAN      NOT NULL DEFAULT false,
  created_at    TIMESTAMPTZ  NOT NULL DEFAULT now()
);
