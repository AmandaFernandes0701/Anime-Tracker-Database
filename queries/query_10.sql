-- ====================================================================
-- CONSULTA 10: Agregação com Junção (Popularidade por Gênero)
-- Objetivo: Comparar JOIN + GROUP BY (Otimizado) vs Subconsulta no SELECT (Lento).
--           Cenário: Contar quantos animes 'Completos' existem por Gênero.
-- ====================================================================

USE `animes_db`;

DELIMITER //

-- ==================================================================
-- VERSÃO A: JOIN com GROUP BY (Abordagem Set-Based)
-- O banco une a tabela de gêneros com a watchlist de uma vez só,
-- filtra e agrupa. É extremamente eficiente.
-- ==================================================================
DROP PROCEDURE IF EXISTS TesteConsulta10_VersaoA //

CREATE PROCEDURE TesteConsulta10_VersaoA()
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
        SELECT G.Genero, COUNT(*) as TotalConcluidos
        FROM ANIME_GENERO G
        INNER JOIN WATCHLIST W ON G.AnimeID_FK = W.AnimeID_FK
        WHERE W.Status = 'Completo'
        GROUP BY G.Genero
        ORDER BY TotalConcluidos DESC;
        
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
-- Primeiro, o banco lista os gêneros distintos. Para CADA gênero, ele
-- roda uma nova consulta pesada (COUNT) na tabela WATCHLIST.
-- ==================================================================
DROP PROCEDURE IF EXISTS TesteConsulta10_VersaoB //

CREATE PROCEDURE TesteConsulta10_VersaoB()
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
        
        -- QUERY B (N+1 Queries)
        SELECT DISTINCT G.Genero,
               (SELECT COUNT(*)
                FROM WATCHLIST W
                INNER JOIN ANIME_GENERO G2 ON W.AnimeID_FK = G2.AnimeID_FK
                WHERE G2.Genero = G.Genero AND W.Status = 'Completo') as TotalConcluidos
        FROM ANIME_GENERO G
        ORDER BY TotalConcluidos DESC;
        
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

CALL TesteConsulta10_VersaoA();
CALL TesteConsulta10_VersaoB();