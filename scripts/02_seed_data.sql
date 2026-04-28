DO $$
DECLARE
    i INT;
BEGIN
    -- Gerar Médicos
    INSERT INTO medicos (crm, nome, especialidade)
    SELECT 'CRM/' || floor(random() * 900000 + 100000)::text,
           'Dr(a). ' || (ARRAY['Silva', 'Souza', 'Costa', 'Oliveira', 'Pereira'])[floor(random()*5+1)] || ' ' || s,
           (ARRAY['Cardiologia', 'Pediatria', 'Ortopedia', 'Geral', 'Neurologia'])[floor(random()*5+1)]
    FROM generate_series(1, 200) s;

    -- Gerar Pacientes
    INSERT INTO pacientes (cpf, nome, data_nascimento, cidade)
    SELECT lpad(s::text, 11, '0'), 'Paciente ' || s,
           CURRENT_DATE - (floor(random() * 25000 + 365))::int,
           (ARRAY['Goiânia', 'São Paulo', 'Rio de Janeiro', 'Curitiba'])[floor(random() * 4 + 1)]
    FROM generate_series(1, 3000) s;

    -- Gerar Medicamentos
    INSERT INTO medicamentos (nome, unidade_medida) VALUES 
    ('Dipirona', 'mg'), ('Amoxicilina', 'mg'), ('Omeprazol', 'mg'), 
    ('Insulina', 'UI'), ('Losartana', 'mg'), ('Ibuprofeno', 'mg');

    -- Gerar Consultas (10k)
    INSERT INTO consultas (paciente_id, medico_id, data_consulta, valor_consulta)
    SELECT floor(random() * 2999 + 1), floor(random() * 199 + 1),
           now() - (random() * interval '2 years'), round((random() * 400 + 150)::numeric, 2)
    FROM generate_series(1, 10000) s;

    -- Gerar Cirurgias (2k)
    INSERT INTO cirurgias (paciente_id, medico_id, tipo_cirurgia, data_inicio, data_fim, sala_cirurgia)
    SELECT floor(random() * 2999 + 1), floor(random() * 199 + 1),
           (ARRAY['Apendicectomia', 'Angioplastia', 'Catarata'])[floor(random() * 3 + 1)],
           now() - (random() * interval '60 days'),
           now() - (random() * interval '60 days') + (random() * interval '5 hours' + interval '30 minutes'),
           'SALA ' || floor(random() * 10 + 1)
    FROM generate_series(1, 2000);

    -- Gerar Prescrições
    INSERT INTO prescricoes (consulta_id, medicamento_id, dosagem, frequencia)
    SELECT s, floor(random() * 5 + 1), '500mg', '8/8h'
    FROM generate_series(1, 10000) s WHERE random() > 0.2;
END $$;