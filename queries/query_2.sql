-- ====================================================================
-- CONSULTA 2: Seleção e Projeção (Busca Textual / Autocomplete)
-- Objetivo: Comparar manipulação de string (LEFT) vs Busca por Prefixo (LIKE).
--           Cenário: Listar usuários cujo nome começa com "ana".
--           NOTA: A coluna 'Username' já possui índice UNIQUE nativo.
-- ====================================================================

USE `animes_db`;

DELIMITER //

-- ==================================================================
-- VERSÃO A: Função LEFT() (Não Otimizada / Non-SARGable)
-- ==================================================================
DROP PROCEDURE IF EXISTS TesteConsulta2_VersaoA //

CREATE PROCEDURE TesteConsulta2_VersaoA()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE start_time DATETIME(6);
    DECLARE end_time DATETIME(6);
    DECLARE exec_time DECIMAL(20,6);
    -- Variável para guardar a média separadamente
    DECLARE media_final DECIMAL(20,6); 

    DROP TEMPORARY TABLE IF EXISTS TempTimesA;
    CREATE TEMPORARY TABLE TempTimesA (
        Execucao VARCHAR(50),
        Tempo_Segundos DECIMAL(20,6)
    );
    
    WHILE i < 5 DO
        SET start_time = NOW(6);
        
        -- QUERY A (Lenta - LEFT)
        SELECT Username, Email 
        FROM USUARIO 
        WHERE LEFT(Username, 3) = 'ana';
        
        SET end_time = NOW(6);
        
        SET exec_time = (TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000000);
        INSERT INTO TempTimesA VALUES (CONCAT('Tentativa ', i+1), exec_time);
        
        SET i = i + 1;
    END WHILE;

    -- Calculamos a média primeiro e guardamos na variável
    SELECT AVG(Tempo_Segundos) INTO media_final FROM TempTimesA;

    -- Exibimos a tabela usando a variável (sem reabrir a tabela temporária)
    SELECT Execucao, Tempo_Segundos FROM TempTimesA
    UNION ALL
    SELECT '--- MÉDIA FINAL (Versão A) ---', media_final;
    
    DROP TEMPORARY TABLE TempTimesA;
END //


-- ==================================================================
-- VERSÃO B: Operador LIKE (Otimizada / SARGable)
-- ==================================================================
DROP PROCEDURE IF EXISTS TesteConsulta2_VersaoB //

CREATE PROCEDURE TesteConsulta2_VersaoB()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE start_time DATETIME(6);
    DECLARE end_time DATETIME(6);
    DECLARE exec_time DECIMAL(20,6);
    DECLARE media_final DECIMAL(20,6);

    DROP TEMPORARY TABLE IF EXISTS TempTimesB;
    CREATE TEMPORARY TABLE TempTimesB (
        Execucao VARCHAR(50),
        Tempo_Segundos DECIMAL(20,6)
    );
    
    WHILE i < 5 DO
        SET start_time = NOW(6);
        
        -- QUERY B (Rápida - LIKE)
        SELECT Username, Email 
        FROM USUARIO 
        WHERE Username LIKE 'ana%';
        
        SET end_time = NOW(6);
        
        SET exec_time = (TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000000);
        INSERT INTO TempTimesB VALUES (CONCAT('Tentativa ', i+1), exec_time);
        
        SET i = i + 1;
    END WHILE;

    SELECT AVG(Tempo_Segundos) INTO media_final FROM TempTimesB;

    SELECT Execucao, Tempo_Segundos FROM TempTimesB
    UNION ALL
    SELECT '--- MÉDIA FINAL (Versão B) ---', media_final;
    
    DROP TEMPORARY TABLE TempTimesB;
END //

DELIMITER ;


-- =================================================================
-- EXECUÇÃO DOS TESTES
-- =================================================================

-- Apenas rodamos (O índice UNIQUE já existe na tabela USUARIO)
CALL TesteConsulta2_VersaoA();
CALL TesteConsulta2_VersaoB();