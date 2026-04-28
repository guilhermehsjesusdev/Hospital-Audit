-- 1. Faturamento por Especialidade
SELECT m.especialidade, COUNT(c.id) as total, SUM(c.valor_consulta) as total_faturado
FROM consultas c JOIN medicos m ON c.medico_id = m.id
GROUP BY m.especialidade ORDER BY total_faturado DESC;

-- 2. Cirurgias Mais Longas e seus Responsáveis
SELECT p.nome as paciente, m.nome as medico, c.tipo_cirurgia, c.duracao_minutos
FROM cirurgias c 
JOIN pacientes p ON c.paciente_id = p.id
JOIN medicos m ON c.medico_id = m.id
ORDER BY c.duracao_minutos DESC LIMIT 10;

-- 3. Histórico de Auditoria
SELECT * FROM logs_auditoria ORDER BY data_alteracao DESC;