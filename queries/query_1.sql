-- ====================================================================
-- Arquivo: 03_consulta_1.sql
-- Objetivo: Comparar filtro por Função (DATE) vs Range (SARGable).
--           Cenário: Busca de alta seletividade (Um dia específico).
-- ====================================================================

USE `animes_db`; 

DELIMITER //

-- ---------------------------------------------------------
-- VERSÃO A: Função DATE() (Não Otimizada)
-- O banco precisa converter cada DataCadastro para DATE antes de comparar.
-- Isso impede o uso do índice.
-- ---------------------------------------------------------
DROP PROCEDURE IF EXISTS TesteConsulta1_VersaoA //

CREATE PROCEDURE TesteConsulta1_VersaoA()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE start_time DATETIME(6);
    DECLARE end_time DATETIME(6);
    DECLARE total_duration DECIMAL(20,6) DEFAULT 0;
    
    WHILE i < 5 DO
        SET start_time = NOW(6);
        
        -- QUERY "RUIM": Aplica função na coluna
        SELECT Username, Email 
        FROM USUARIO 
        WHERE DATE(DataCadastro) = '2024-05-15';
        
        SET end_time = NOW(6);
        SET total_duration = total_duration + (TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000000);
        SET i = i + 1;
    END WHILE;

    SELECT 'Consulta 1 - Versão A (Função DATE)' AS 'Teste', 
           (total_duration / 5) AS 'Tempo Médio (s)';
END //


-- ---------------------------------------------------------
-- VERSÃO B: Intervalo Exato (Otimizada / SARGable)
-- O banco usa o índice para pular direto para o dia 15/05.
-- ---------------------------------------------------------
DROP PROCEDURE IF EXISTS TesteConsulta1_VersaoB //

CREATE PROCEDURE TesteConsulta1_VersaoB()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE start_time DATETIME(6);
    DECLARE end_time DATETIME(6);
    DECLARE total_duration DECIMAL(20,6) DEFAULT 0;
    
    WHILE i < 5 DO
        SET start_time = NOW(6);
        
        -- QUERY "BOA": Compara range puro
        SELECT Username, Email 
        FROM USUARIO 
        WHERE DataCadastro >= '2024-05-15 00:00:00' 
          AND DataCadastro <= '2024-05-15 23:59:59';
        
        SET end_time = NOW(6);
        SET total_duration = total_duration + (TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000000);
        SET i = i + 1;
    END WHILE;

    SELECT 'Consulta 1 - Versão B (Range Dia)' AS 'Teste', 
           (total_duration / 5) AS 'Tempo Médio (s)';
END //

DELIMITER ;


-- =================================================================
-- EXECUÇÃO COM ÍNDICE (O Pulo do Gato)
-- =================================================================

-- 1. Cria o Índice
CREATE INDEX idx_data_cadastro ON USUARIO(DataCadastro);

-- 2. Roda os Testes
-- A Versão A deve fazer Full Scan (lento, ~0.00xxx)
-- A Versão B deve fazer Index Seek (muito rápido, ~0.000xx)
CALL TesteConsulta1_VersaoA();
CALL TesteConsulta1_VersaoB();

-- 3. Limpeza
DROP INDEX idx_data_cadastro ON USUARIO;