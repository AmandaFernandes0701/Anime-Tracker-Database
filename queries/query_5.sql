-- ====================================================================
-- CONSULTA 5: Junção de 2 Relações (Filtro por Gênero)
-- Objetivo: Comparar JOIN (Padrão) vs Cláusula IN (Semijunção/Subquery).
--           Cenário: Listar títulos de animes do gênero 'Shounen'.
-- ====================================================================

USE `animes_db`;

DELIMITER //

-- ==================================================================
-- VERSÃO A: INNER JOIN (Abordagem Set-Based)
-- O banco une a tabela de animes com a de gêneros e filtra o resultado.
-- ==================================================================
DROP PROCEDURE IF EXISTS TesteConsulta5_VersaoA //

CREATE PROCEDURE TesteConsulta5_VersaoA()
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
        
        -- QUERY A (JOIN)
        SELECT A.Titulo 
        FROM ANIME A 
        INNER JOIN ANIME_GENERO G ON A.AnimeID = G.AnimeID_FK 
        WHERE G.Genero = 'Shounen';
        
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
-- VERSÃO B: Cláusula IN com Subquery (Abordagem de Semijunção)
-- O banco resolve a lista de IDs de Shounen primeiro e depois filtra os Animes.
-- ==================================================================
DROP PROCEDURE IF EXISTS TesteConsulta5_VersaoB //

CREATE PROCEDURE TesteConsulta5_VersaoB()
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
        
        -- QUERY B (IN / Subquery)
        SELECT A.Titulo 
        FROM ANIME A 
        WHERE A.AnimeID IN (
            SELECT G.AnimeID_FK 
            FROM ANIME_GENERO G 
            WHERE G.Genero = 'Shounen'
        );
        
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

CALL TesteConsulta5_VersaoA();
CALL TesteConsulta5_VersaoB();