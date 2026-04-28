-- Criar tabelas principais
CREATE TABLE medicos (
    id SERIAL PRIMARY KEY,
    crm VARCHAR(20) UNIQUE NOT NULL,
    nome VARCHAR(100) NOT NULL,
    especialidade VARCHAR(50)
);

CREATE TABLE pacientes (
    id SERIAL PRIMARY KEY,
    cpf CHAR(11) UNIQUE NOT NULL,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    cidade VARCHAR(50)
);

CREATE TABLE consultas (
    id SERIAL PRIMARY KEY,
    paciente_id INT REFERENCES pacientes(id) ON DELETE CASCADE,
    medico_id INT REFERENCES medicos(id) ON DELETE CASCADE,
    data_consulta TIMESTAMP NOT NULL,
    diagnostico TEXT,
    valor_consulta DECIMAL(10,2)
);

CREATE TABLE cirurgias (
    id SERIAL PRIMARY KEY,
    paciente_id INT REFERENCES pacientes(id) ON DELETE CASCADE,
    medico_id INT REFERENCES medicos(id) ON DELETE CASCADE,
    tipo_cirurgia VARCHAR(100) NOT NULL,
    data_inicio TIMESTAMP NOT NULL,
    data_fim TIMESTAMP NOT NULL,
    sala_cirurgia VARCHAR(10),
    duracao_minutos INT GENERATED ALWAYS AS (
        EXTRACT(EPOCH FROM (data_fim - data_inicio)) / 60
    ) STORED
);

CREATE TABLE medicamentos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    unidade_medida VARCHAR(20)
);

CREATE TABLE prescricoes (
    id SERIAL PRIMARY KEY,
    consulta_id INT REFERENCES consultas(id) ON DELETE CASCADE,
    medicamento_id INT REFERENCES medicamentos(id) ON DELETE CASCADE,
    dosagem VARCHAR(50),
    frequencia VARCHAR(50)
);

-- Tabela de Auditoria
CREATE TABLE logs_auditoria (
    id SERIAL PRIMARY KEY,
    tabela_nome VARCHAR(50),
    registro_id INT,
    usuario_db VARCHAR(50) DEFAULT CURRENT_USER,
    data_alteracao TIMESTAMP DEFAULT NOW(),
    operacao VARCHAR(20),
    dados_antigos JSONB,
    dados_novos JSONB
);

-- Função e Trigger de Auditoria
CREATE OR REPLACE FUNCTION fn_audit_cirurgias()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'UPDATE') THEN
        INSERT INTO logs_auditoria (tabela_nome, registro_id, operacao, dados_antigos, dados_novos)
        VALUES ('cirurgias', OLD.id, 'UPDATE', to_jsonb(OLD), to_jsonb(NEW));
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO logs_auditoria (tabela_nome, registro_id, operacao, dados_antigos)
        VALUES ('cirurgias', OLD.id, 'DELETE', to_jsonb(OLD));
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_cirurgias
AFTER UPDATE OR DELETE ON cirurgias
FOR EACH ROW EXECUTE FUNCTION fn_audit_cirurgias();

-- Índices Estratégicos
CREATE INDEX idx_consultas_data ON consultas(data_consulta);
CREATE INDEX idx_cirurgias_paciente ON cirurgias(paciente_id);