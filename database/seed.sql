-- =====================================================================
-- Atlas One - Dados iniciais de demonstração
--
-- Execução: cd backend && npm run db:seed
-- ATENÇÃO: este script APAGA os dados atuais das tabelas e recria o
-- conjunto de demonstração. Use-o para restaurar o ambiente original.
-- =====================================================================

TRUNCATE TABLE operations, announcements, employees, distribution_centers CASCADE;

-- ---------------------------------------------------------------------
-- Centros de distribuição
-- ---------------------------------------------------------------------
INSERT INTO distribution_centers (code, name, city, state, status) VALUES
  ('CD-SAN', 'Centro de Distribuição Santos',    'Santos',    'SP', 'normal'),
  ('CD-CPS', 'Centro de Distribuição Campinas',  'Campinas',  'SP', 'attention'),
  ('CD-GRU', 'Centro de Distribuição Guarulhos', 'Guarulhos', 'SP', 'normal');

-- ---------------------------------------------------------------------
-- Funcionários
-- Lucas Almeida (ATL-2847) é o usuário principal do aplicativo.
-- ---------------------------------------------------------------------
INSERT INTO employees (name, email, phone, job_title, registration, distribution_center_id)
SELECT 'Lucas Almeida', 'lucas.almeida@atlaslogistics.com', '(13) 99812-4471',
       'Operador Logístico', 'ATL-2847', id
FROM distribution_centers WHERE code = 'CD-SAN';

INSERT INTO employees (name, email, phone, job_title, registration, distribution_center_id)
SELECT 'Mariana Costa', 'mariana.costa@atlaslogistics.com', '(19) 99745-2210',
       'Supervisora de Operações', 'ATL-1932', id
FROM distribution_centers WHERE code = 'CD-CPS';

INSERT INTO employees (name, email, phone, job_title, registration, distribution_center_id)
SELECT 'Rafael Nunes', 'rafael.nunes@atlaslogistics.com', '(11) 98631-0587',
       'Motorista', 'ATL-3105', id
FROM distribution_centers WHERE code = 'CD-GRU';

-- ---------------------------------------------------------------------
-- Operações
-- As datas são relativas ao momento do seed para o ambiente parecer "vivo".
-- ---------------------------------------------------------------------
INSERT INTO operations (code, origin, destination, status, scheduled_date, employee_id)
SELECT 'OP-1048', 'Santos', 'Campinas', 'in_transit', now() - interval '2 hours', id
FROM employees WHERE registration = 'ATL-2847';

INSERT INTO operations (code, origin, destination, status, scheduled_date, employee_id)
SELECT 'OP-1049', 'Guarulhos', 'Santos', 'awaiting_pickup', now() + interval '3 hours', id
FROM employees WHERE registration = 'ATL-3105';

INSERT INTO operations (code, origin, destination, status, scheduled_date, employee_id)
SELECT 'OP-1050', 'Campinas', 'Sorocaba', 'completed', now() - interval '1 hour', id
FROM employees WHERE registration = 'ATL-1932';

INSERT INTO operations (code, origin, destination, status, scheduled_date, employee_id)
SELECT 'OP-1051', 'Santos', 'São José dos Campos', 'delayed', now() - interval '1 day', id
FROM employees WHERE registration = 'ATL-2847';

INSERT INTO operations (code, origin, destination, status, scheduled_date, employee_id)
SELECT 'OP-1052', 'Guarulhos', 'Ribeirão Preto', 'in_transit', now() - interval '6 hours', id
FROM employees WHERE registration = 'ATL-3105';

-- ---------------------------------------------------------------------
-- Avisos
-- ---------------------------------------------------------------------
INSERT INTO announcements (title, description, published_at, is_read) VALUES
  ('Manutenção programada',
   'O sistema de roteirização ficará indisponível no sábado, das 22h às 2h, para manutenção preventiva. Planeje as expedições com antecedência.',
   now() - interval '3 hours', false),
  ('Novo procedimento para registro de ocorrências',
   'A partir da próxima semana, toda avaria de carga deverá ser registrada em até 2 horas após a identificação, com a descrição completa do ocorrido.',
   now() - interval '1 day', false),
  ('Atualização do aplicativo',
   'A versão 1.0 do Atlas One já está disponível para todos os centros de distribuição. Novos módulos serão liberados nas próximas semanas.',
   now() - interval '3 days', true),
  ('Inventário trimestral no CD Campinas',
   'O inventário trimestral do CD Campinas acontece na próxima sexta-feira. Recebimentos serão reduzidos entre 8h e 14h.',
   now() - interval '5 days', true);
