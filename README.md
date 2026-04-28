# 🏥 Hospital Audit : Architecture & Analytics

Este repositório apresenta um ecossistema de banco de dados robusto desenvolvido em **PostgreSQL**, projetado para suportar operações críticas de um ambiente hospitalar. O projeto foca em alta integridade de dados, auditoria automatizada e geração de massa de dados realista para testes de performance.

---

## 🚀 Destaques do Projeto

* **Auditoria de Dados (Change Data Capture):** Implementação de Triggers e Functions para rastrear todas as alterações na tabela de cirurgias, armazenando o estado anterior/posterior em `JSONB`.
* **Performance & Otimização:** * Uso de **Generated Columns** para cálculos de tempo de cirurgia em tempo real.
    * Criação de índices estratégicos para otimização de consultas em tabelas com milhares de registros.
* **Massa de Dados Sintética:** Scripts procedurais (`PL/pgSQL`) que geram mais de **15.000 registros** mantendo a consistência das chaves estrangeiras.
* **Visão Analítica:** Dashboards prontos através de `Views` para monitoramento de faturamento e ocupação.

---

## 📂 Estrutura do Repositório

```plaintext
├── scripts/
│   ├── 01_schema.sql          # Definição de tabelas, índices e auditoria
│   └── 02_seed_data.sql       # Geração procedural de 15.000 registros
├── queries/
│   └── business_reports.sql   # Consultas analíticas (KPIs)
├── docs/
│   └── ERD_Diagram.png        # Diagrama Entidade-Relacionamento
└── README.md
