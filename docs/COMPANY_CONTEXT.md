# Atlas Logistics: contexto da empresa

Este documento descreve o universo da Atlas Logistics. Novos chamados, histórias de usuário, bugs e requisitos do Atlas One devem permanecer coerentes com ele.

> Dados que já existem no banco de demonstração (`database/seed.sql`) estão marcados com **[seed]**. Os demais fazem parte do contexto da empresa e podem ser adicionados ao banco quando algum requisito precisar deles.

---

## 1. A empresa

A **Atlas Logistics** é uma operadora logística paulista com cerca de 1.200 funcionários. Ela atua em:

- **transporte rodoviário de cargas** (frota própria e motoristas agregados);
- **armazenagem** em centros de distribuição (CDs);
- **distribuição** para clientes empresariais (B2B) e entregas de e-commerce;
- **gestão de ocorrências** durante o transporte (avarias, atrasos, extravios);
- **gestão documental** do transporte (notas fiscais, conhecimentos de transporte e comprovantes de entrega).

A sede administrativa fica em São Paulo (SP). As operações se concentram no eixo **Porto de Santos, região metropolitana de São Paulo e interior paulista**.

**Missão interna:** "Cada carga no lugar certo, no prazo combinado, com informação confiável em cada etapa."

### Situação tecnológica

Hoje boa parte da operação ainda depende de planilhas, rádio, WhatsApp e de um sistema legado desktop (o **"SGL"**, Sistema de Gestão Logística). O **Atlas One** é a iniciativa da diretoria para concentrar essas atividades em um único aplicativo móvel e web, liberado em módulos.

---

## 2. O aplicativo Atlas One

Aplicativo corporativo **interno**, usado só por funcionários. Não é voltado para clientes.

| Perfil de usuário | Uso principal (atual ou planejado) |
|-------------------|-------------------------------------|
| Operador logístico | Acompanha operações do seu CD, registra ocorrências, confere cargas. |
| Supervisor de operações | Acompanha indicadores do CD, trata ocorrências, aprova correções. |
| Motorista | Consulta suas viagens, localiza CDs, registra entregas e avarias. |
| Funcionário administrativo | Consulta documentos, comunicados e dados cadastrais. |
| Gerente | Visualiza indicadores consolidados de vários CDs. |

Na versão 1.0 **todos os usuários veem as mesmas telas**. Controle de acesso por perfil está previsto, mas ainda não existe.

### Equipe do produto Atlas One (squad interna de TI)

| Nome | Papel | Como costuma aparecer nas demandas |
|------|-------|------------------------------------|
| Juliana Prado | Product Owner | Prioriza o backlog e escreve histórias de usuário. |
| Diego Fernandes | Tech Lead | Pede refatorações, padrões de código e melhorias de performance. |
| Thiago Ramos | UX/UI Designer | Solicita ajustes visuais, de usabilidade e acessibilidade. |
| Aline Moura | Analista de QA | Reporta bugs com passos para reproduzir. |
| Renato Queiroz | Engenheiro de Dados / DBA | Cuida do banco Neon, índices e desempenho de consultas. |

Convenções da squad:

- Chamados usam o prefixo **`ATL1-`** (ex.: `ATL1-142`).
- Sprints de duas semanas.
- Bugs têm severidade: **Crítica**, **Alta**, **Média** ou **Baixa**.
- Toda demanda é escrita em português e deve citar o módulo afetado (Dashboard, Operações, Avisos, Perfil ou novo módulo).

---

## 3. Departamentos

| Departamento | Responsabilidade | Relação com o Atlas One |
|--------------|------------------|-------------------------|
| **Operações** | Execução das operações nos CDs e no transporte. | Principal usuário. Origem da maior parte das demandas. |
| **Transportes e Frota** | Motoristas, veículos, roteirização e manutenção da frota. | Demandas para motoristas: viagens, mapas, checklists. |
| **Armazenagem** | Recebimento, estocagem, separação e expedição nos CDs. | Demandas de docas, inventário e conferência. |
| **Qualidade e Segurança (QSMS)** | Ocorrências, avarias, auditorias, segurança do trabalho. | Pede registro de ocorrências, fotos e relatórios. |
| **Atendimento Corporativo** | Contato com clientes empresariais. | Pede rastreabilidade e consulta rápida de operações. |
| **Recursos Humanos** | Cadastro de funcionários, cargos e unidades. | Dono dos dados de e-mail, matrícula e unidade. |
| **Tecnologia da Informação** | Sistemas internos, incluindo o Atlas One. | Mantém o app, a Atlas API e o banco Neon. |
| **Financeiro** | Faturamento de fretes e custos operacionais. | Demandas futuras de relatórios. |
| **Diretoria / Gerência regional** | Metas e acompanhamento dos CDs. | Pede indicadores, gráficos e visão consolidada. |

---

## 4. Centros de distribuição

| Código | Nome | Cidade | Perfil | Situação atual |
|--------|------|--------|--------|----------------|
| `CD-SAN` | Centro de Distribuição Santos **[seed]** | Santos - SP | Retaguarda do Porto de Santos: contêineres, importação e exportação. | Operação normal |
| `CD-CPS` | Centro de Distribuição Campinas **[seed]** | Campinas - SP | Hub de e-commerce e cargas do interior, próximo a Viracopos. | **Atenção**: alto volume e inventário trimestral |
| `CD-GRU` | Centro de Distribuição Guarulhos **[seed]** | Guarulhos - SP | Cargas aéreas e distribuição na Grande São Paulo. | Operação normal |
| `CD-SOR` | Centro de Distribuição Sorocaba | Sorocaba - SP | Unidade em implantação, com operação parcial. | Ainda não cadastrado no sistema |

Situações possíveis de um CD: `normal` (Operação normal), `attention` (Atenção) e `critical` (Crítico).

---

## 5. Operações logísticas

Uma **operação** é o transporte de uma carga de uma origem até um destino. Ela é identificada por um código no formato **`OP-NNNN`** (ex.: `OP-1048`).

### Tipos de operação

Os tipos ainda **não existem no banco**; são candidatos a requisitos futuros.

| Tipo | Descrição |
|------|-----------|
| Transferência | Movimentação de carga entre dois CDs da Atlas. |
| Coleta | Retirada de carga no cliente ou no porto/aeroporto. |
| Distribuição | Entrega ao cliente final (B2B ou e-commerce). |
| Cross-docking | Carga que passa pelo CD sem ser armazenada. |
| Logística reversa | Devoluções e retorno de embalagens/paletes. |

### Situações de uma operação

| Código no banco | Texto no app | Significado |
|-----------------|--------------|-------------|
| `awaiting_pickup` | Aguardando coleta | Operação criada, carga ainda não saiu da origem. |
| `in_transit` | Em trânsito | Carga em deslocamento. |
| `delayed` | Atrasada | Passou do horário previsto sem conclusão. |
| `completed` | Finalizada | Carga entregue no destino. |

Situações candidatas para o futuro: `cancelled` (Cancelada), `incident` (Com ocorrência), `returned` (Devolvida).

### Operações de demonstração [seed]

| Código | Origem → Destino | Situação | Responsável |
|--------|------------------|----------|-------------|
| OP-1048 | Santos → Campinas | Em trânsito | Lucas Almeida |
| OP-1049 | Guarulhos → Santos | Aguardando coleta | Rafael Nunes |
| OP-1050 | Campinas → Sorocaba | Finalizada | Mariana Costa |
| OP-1051 | Santos → São José dos Campos | Atrasada | Lucas Almeida |
| OP-1052 | Guarulhos → Ribeirão Preto | Em trânsito | Rafael Nunes |

---

## 6. Funcionários

| Nome | Matrícula | Cargo | Unidade | Observação |
|------|-----------|-------|---------|------------|
| **Lucas Almeida** | ATL-2847 | Operador Logístico | CD Santos | **[seed]** Usuário principal do app na versão atual. |
| Mariana Costa | ATL-1932 | Supervisora de Operações | CD Campinas | **[seed]** Costuma reportar problemas de volume e atrasos. |
| Rafael Nunes | ATL-3105 | Motorista | CD Guarulhos | **[seed]** Usa o app no celular, muitas vezes com sinal fraco. |
| Carla Menezes | ATL-0415 | Gerente Regional | Sede São Paulo | Pede indicadores consolidados e gráficos. |
| Eduardo Sato | ATL-2210 | Supervisor de Armazenagem | CD Guarulhos | Demandas de docas e inventário. |
| Bruno Carvalho | ATL-3377 | Motorista | CD Santos | Pede navegação até os CDs e registro de entrega. |
| Patrícia Lima | ATL-1588 | Analista de Qualidade (QSMS) | CD Campinas | Dona do processo de ocorrências e avarias. |
| Fernanda Rocha | ATL-0981 | Analista de RH | Sede São Paulo | Responsável pelos dados cadastrais de funcionários. |

Formatos:

- Matrícula: `ATL-NNNN`.
- E-mail: `nome.sobrenome@atlaslogistics.com`.

---

## 7. Clientes (fictícios)

| Cliente | Segmento | Particularidade |
|---------|----------|-----------------|
| Mercados Horizonte | Rede de supermercados | Janelas de entrega rígidas de madrugada. |
| NovaFarma Distribuidora | Farmacêutico | Exige controle de temperatura e rastreabilidade por lote. |
| TechNova Eletrônicos | E-commerce de eletrônicos | Alto volume de pequenas entregas e muitas devoluções. |
| Construmax Materiais | Materiais de construção | Cargas pesadas e volumosas. |
| Vale Verde Alimentos | Indústria alimentícia | Cargas perecíveis e sazonalidade no fim do ano. |
| Lumina Cosméticos | Cosméticos | Cargas de alto valor e risco de extravio. |

Clientes ainda **não existem no banco**. Uma tabela `clients` e o vínculo `operations.client_id` são candidatos naturais a requisitos futuros.

---

## 8. Glossário

| Termo | Significado |
|-------|-------------|
| **CD** | Centro de Distribuição. |
| **Operação** | Transporte de uma carga entre origem e destino, identificado por `OP-NNNN`. |
| **Ocorrência** | Qualquer evento fora do planejado: avaria, atraso, extravio, recusa do cliente, acidente. |
| **Avaria** | Dano físico à carga. |
| **Extravio** | Carga (ou parte dela) perdida. |
| **Coleta** | Retirada da carga na origem. |
| **Doca** | Área do CD onde caminhões carregam e descarregam. |
| **Janela de entrega** | Intervalo de horário em que o cliente aceita receber a carga. |
| **SLA / prazo** | Prazo acordado com o cliente. Base do indicador "Dentro do prazo". |
| **NF-e** | Nota Fiscal eletrônica da mercadoria. |
| **CT-e** | Conhecimento de Transporte eletrônico, o documento fiscal do frete. |
| **MDF-e / Manifesto** | Documento que agrupa as cargas de uma viagem. |
| **Romaneio** | Lista de volumes/cargas de um carregamento. |
| **POD** | *Proof of Delivery*, comprovante de entrega (assinatura/foto). |
| **Roteirização** | Definição da sequência de entregas de uma viagem. |
| **Agregado** | Motorista terceirizado com veículo próprio que presta serviço à Atlas. |
| **Cross-docking** | Transferência da carga direto do recebimento para a expedição, sem armazenar. |
| **Lead time** | Tempo total entre o pedido e a entrega. |
| **SGL** | Sistema de Gestão Logística, o sistema legado desktop que o Atlas One está substituindo. |

---

## 9. Comunicados de demonstração [seed]

1. **Manutenção programada**: o sistema de roteirização fica indisponível no sábado, das 22h às 2h.
2. **Novo procedimento para registro de ocorrências**: avarias devem ser registradas em até 2 horas.
3. **Atualização do aplicativo**: a versão 1.0 do Atlas One foi liberada para todos os CDs.
4. **Inventário trimestral no CD Campinas**: recebimentos reduzidos entre 8h e 14h.
