-- ====================================================================
-- CONSULTA 3: Junção de 2 Relações (Anime + Estúdio)
-- Objetivo: Comparar JOIN (Set-Based) vs Subconsulta Correlacionada (Iterativa).
--           Cenário: Listar títulos de animes e seus respectivos estúdios.
-- ====================================================================

USE `animes_db`;

DELIMITER //

-- ==================================================================
-- VERSÃO A: INNER JOIN Explícito (Otimizada / Set-Based)
-- O banco cruza os dados em lote, usando a estratégia mais eficiente.
-- ==================================================================
DROP PROCEDURE IF EXISTS TesteConsulta3_VersaoA //

CREATE PROCEDURE TesteConsulta3_VersaoA()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE start_time DATETIME(6);
    DECLARE end_time DATETIME(6);
    DECLARE exec_time DECIMAL(20,6);
    DECLARE media_final DECIMAL(20,6);

    DROP TEMPORARY TABLE IF EXISTS TempTimesA;
    CREATE TEMPORARY TABLE TempTimesA (
        Execucao VARCHAR(50),
        Tempo_Segundos DECIMAL(20,6)
    );
    
    WHILE i < 5 DO
        SET start_time = NOW(6);
        
        -- QUERY A (JOIN Padrão)
        SELECT A.Titulo, E.Nome 
        FROM ANIME A 
        INNER JOIN ESTUDIO E ON A.EstudioID_FK = E.EstudioID;
        
        SET end_time = NOW(6);
        
        SET exec_time = (TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000000);
        INSERT INTO TempTimesA VALUES (CONCAT('Tentativa ', i+1), exec_time);
        
        SET i = i + 1;
    END WHILE;

    SELECT AVG(Tempo_Segundos) INTO media_final FROM TempTimesA;

    SELECT Execucao, Tempo_Segundos FROM TempTimesA
    UNION ALL
    SELECT '--- MÉDIA FINAL (Versão A) ---', media_final;
    
    DROP TEMPORARY TABLE TempTimesA;
END //


-- ==================================================================
-- VERSÃO B: Subconsulta Correlacionada no SELECT (Lenta / Row-by-Row)
-- O banco executa o SELECT interno uma vez para CADA Anime encontrado.
-- ==================================================================
DROP PROCEDURE IF EXISTS TesteConsulta3_VersaoB //

CREATE PROCEDURE TesteConsulta3_VersaoB()
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
        
        -- QUERY B (Subconsulta Correlacionada)
        SELECT 
            A.Titulo,
            (SELECT E.Nome 
             FROM ESTUDIO E 
             WHERE E.EstudioID = A.EstudioID_FK) AS Nome_Estudio
        FROM ANIME A;
        
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

CALL TesteConsulta3_VersaoA();
CALL TesteConsulta3_VersaoB();