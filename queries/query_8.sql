-- ====================================================================
-- CONSULTA 8: Junção de 3+ Relações (Usuários de Shounen)
-- Objetivo: Comparar JOIN + DISTINCT (Deduplicação) vs EXISTS (Semi-Join).
--           Cenário: Identificar usuários que completaram pelo menos um anime 'Shounen'.
-- ====================================================================

USE `animes_db`; 

DELIMITER //

-- ==================================================================
-- VERSÃO A: JOIN com DISTINCT (Custo de Deduplicação)
-- O banco gera linhas duplicadas (uma para cada anime visto) e depois gasta
-- recursos para ordenar/agrupar e remover as duplicatas.
-- ==================================================================
DROP PROCEDURE IF EXISTS TesteConsulta8_VersaoA //

CREATE PROCEDURE TesteConsulta8_VersaoA()
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
        
        -- QUERY A (Gera duplicatas e limpa com DISTINCT)
        SELECT DISTINCT U.Username
        FROM USUARIO U
        INNER JOIN WATCHLIST W ON U.UsuarioID = W.UsuarioID_FK
        INNER JOIN ANIME_GENERO G ON W.AnimeID_FK = G.AnimeID_FK
        WHERE W.Status = 'Completo' AND G.Genero = 'Shounen';
        
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
-- VERSÃO B: EXISTS / Semi-Join (Short-Circuit)
-- O banco para de procurar na lista do usuário assim que encontra
-- o PRIMEIRO anime que satisfaz a condição.
-- ==================================================================
DROP PROCEDURE IF EXISTS TesteConsulta8_VersaoB //

CREATE PROCEDURE TesteConsulta8_VersaoB()
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
        
        -- QUERY B (Verificação de Existência)
        SELECT U.Username
        FROM USUARIO U
        WHERE EXISTS (
            SELECT 1
            FROM WATCHLIST W
            INNER JOIN ANIME_GENERO G ON W.AnimeID_FK = G.AnimeID_FK
            WHERE W.UsuarioID_FK = U.UsuarioID
            AND W.Status = 'Completo'
            AND G.Genero = 'Shounen'
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

CALL TesteConsulta8_VersaoA();
CALL TesteConsulta8_VersaoB();