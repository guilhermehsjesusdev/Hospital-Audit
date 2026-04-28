# 🏥 Hospital Audit: Architecture & Analytics

Este repositório apresenta um ecossistema de base de dados robusto desenvolvido em **PostgreSQL**, projetado para suportar operações críticas de um ambiente hospitalar. O projeto foca em alta integridade de dados, auditoria automatizada e geração de massa de dados realista para testes de performance.

---

## 🚀 Destaques do Projeto

* **Auditoria de Dados (Change Data Capture):** Implementação de Triggers e Functions para rastrear todas as alterações na tabela de cirurgias, armazenando o estado anterior/posterior em `JSONB`.
* **Performance & Otimização:** * Uso de **Generated Columns** para cálculos de tempo de cirurgia em tempo real.
    * Criação de índices estratégicos para otimização de consultas em tabelas com milhares de registros.
* **Massa de Dados Sintética:** Scripts procedurais (`PL/pgSQL`) que geram mais de **15.000 registos** mantendo a consistência das chaves estrangeiras.
* **Visão Analítica:** Dashboards prontos através de `Views` para monitorização de faturação e ocupação.

---

## 📂 Estrutura do Repositório

```plaintext
├── scripts/
│   ├── 01_schema.sql          # Definição de tabelas, índices e auditoria
│   └── 02_seed_data.sql       # Geração procedural de 15.000 registos
├── queries/
│   └── business_reports.sql   # Consultas analíticas (KPIs)
├── docs/
│   └── ERD_Diagram.png        # Diagrama Entidade-Relacionamento
└── README.md

```
🛠️ Arquitetura da Base de Dados
Componentes Principais:
Core: Pacientes, Médicos e Consultas (Relacionamentos 1:N).

Operacional: Cirurgias com cálculo automático de duração através de colunas geradas.

Farmácia: Prescrições vinculadas a consultas e catálogo de medicamentos.

Security: Sistema de logs (Auditoria) que identifica o utilizador da base de dados e a operação realizada.

📈 Exemplo de Inteligência de Negócio (KPIs)
A base de dados está preparada para responder a perguntas complexas de gestão hospitalar:
"Qual a média de duração das cirurgias por especialidade e o impacto na faturação mensal?"
```
SELECT 
    m.especialidade,
    COUNT(c.id) as total_procedimentos,
    ROUND(AVG(c.duracao_minutos), 2) as media_minutos,
    SUM(co.valor_consulta) as receita_gerada
FROM cirurgias c
JOIN medicos m ON c.medico_id = m.id
JOIN consultas co ON co.paciente_id = c.paciente_id
GROUP BY m.especialidade;
```
⚙️ Como Executar
Para subir o ambiente localmente, siga os passos abaixo utilizando o pgAdmin 4 ou o terminal (psql).

1. Preparação do Ambiente
Crie uma base de dados vazia para o projeto:
```
CREATE DATABASE hospital_audit;
```
2. Execução via pgAdmin 4 (Interface Gráfica)
Abra o pgAdmin 4 e ligue-se ao seu servidor.

Clique com o botão direito na base de dados hospital_audit e selecione Query Tool.

Abra e execute o ficheiro scripts/01_schema.sql (pode arrastar o ficheiro ou copiar o conteúdo e premir F5).

Em seguida, abra e execute o ficheiro scripts/02_seed_data.sql.

Nota: Devido à carga de 15.000 registos, este script pode levar alguns segundos a concluir.

3. Execução via Terminal (psql)
Navegue até à pasta do projeto e execute:

```
# Criar o schema e triggers
psql -U seu_utilizador -d hospital_audit -f scripts/01_schema.sql

# Popular a base de dados com os dados sintéticos
psql -U seu_utilizador -d hospital_audit -f scripts/02_seed_data.sql
```

🛡️ Testando a Auditoria
Pode validar o funcionamento da trigger de auditoria (rastreabilidade) executando o seguinte comando:

```
-- Simule uma alteração de sala numa cirurgia existente
UPDATE cirurgias SET sala_cirurgia = 'SALA_TESTE' WHERE id = 10;

-- Verifique o registo de auditoria gerado automaticamente (quem, quando e o quê)
SELECT * FROM logs_auditoria;
```
Desenvolvido como projeto de portefólio para demonstração de competências em Engenharia de Dados e SQL Avançado.
