-- ====================================================================
-- CONSULTA 9: Agregação com Junção (Média de Notas por Estúdio)
-- Objetivo: Comparar JOIN + GROUP BY (Set-Based) vs Subconsulta Correlacionada.
--           Cenário: Calcular a média das notas dadas aos animes de cada estúdio.
-- ====================================================================

USE `animes_db`; 

DELIMITER //

-- ==================================================================
-- VERSÃO A: JOIN com GROUP BY (Abordagem Set-Based / Otimizada)
-- O banco une todas as tabelas e calcula as médias em lote usando agrupamento.
-- ==================================================================
DROP PROCEDURE IF EXISTS TesteConsulta9_VersaoA //

CREATE PROCEDURE TesteConsulta9_VersaoA()
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
        
        -- QUERY A (GROUP BY)
        SELECT E.Nome, AVG(W.NotaDada) as Media
        FROM ESTUDIO E
        INNER JOIN ANIME A ON E.EstudioID = A.EstudioID_FK
        INNER JOIN WATCHLIST W ON A.AnimeID = W.AnimeID_FK
        GROUP BY E.Nome;
        
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
-- VERSÃO B: Subconsulta Correlacionada no SELECT (Abordagem Iterativa)
-- O banco executa o cálculo da média separadamente para CADA Estúdio listado.
-- Isso tende a ser muito custoso (Problema N+1).
-- ==================================================================
DROP PROCEDURE IF EXISTS TesteConsulta9_VersaoB //

CREATE PROCEDURE TesteConsulta9_VersaoB()
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
        
        -- QUERY B (Subconsulta por Linha)
        SELECT E.Nome,
               (SELECT AVG(W.NotaDada)
                FROM WATCHLIST W
                INNER JOIN ANIME A ON W.AnimeID_FK = A.AnimeID
                WHERE A.EstudioID_FK = E.EstudioID) as Media
        FROM ESTUDIO E;
        
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

CALL TesteConsulta9_VersaoA();
CALL TesteConsulta9_VersaoB();