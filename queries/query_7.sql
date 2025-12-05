-- ====================================================================
-- CONSULTA 7: Junção de 3+ Relações (Reviews, Animes, Estúdios)
-- Objetivo: Testar a "Inversão da ordem das relações na cláusula FROM".
--           Cenário: Listar o texto da review, nome do anime e nome do estúdio.
-- ====================================================================

USE `animes_db`;

DELIMITER //

-- ==================================================================
-- VERSÃO A: Ordem "Top-Down" (Do Pai para o Filho)
-- Começa de ESTUDIO (menor/filtro), junta com ANIME, depois com REVIEW (maior).
-- Estratégia: ESTUDIO -> ANIME -> REVIEW
-- ==================================================================
DROP PROCEDURE IF EXISTS TesteConsulta7_VersaoA //

CREATE PROCEDURE TesteConsulta7_VersaoA()
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
        
        -- QUERY A (Ordem Otimizada Manualmente)
        SELECT R.Texto, A.Titulo, E.Nome
        FROM ESTUDIO E
        INNER JOIN ANIME A ON E.EstudioID = A.EstudioID_FK
        INNER JOIN REVIEW R ON A.AnimeID = R.AnimeID_FK
        WHERE E.Nome = 'Wit Studio'; 
        
        SET end_time = NOW(6);
        
        SET exec_time = (TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000000);
        INSERT INTO TempTimesA VALUES (CONCAT('Tentativa ', i+1), exec_time);
        
        SET i = i + 1;
    END WHILE;

    SELECT AVG(Tempo_Segundos) INTO media_final FROM TempTimesA;

    SELECT Execucao, Tempo_Segundos FROM TempTimesA
    UNION ALL
    SELECT '--- MÉDIA FINAL (Versão A - Pai->Filho) ---', media_final;
    
    DROP TEMPORARY TABLE TempTimesA;
END //


-- ==================================================================
-- VERSÃO B: Ordem "Bottom-Up" (Do Filho para o Pai)
-- Começa de REVIEW (maior tabela), junta com ANIME, depois com ESTUDIO.
-- Estratégia: REVIEW -> ANIME -> ESTUDIO
-- ==================================================================
DROP PROCEDURE IF EXISTS TesteConsulta7_VersaoB //

CREATE PROCEDURE TesteConsulta7_VersaoB()
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
        
        -- QUERY B (Ordem Invertida)
        SELECT R.Texto, A.Titulo, E.Nome
        FROM REVIEW R
        INNER JOIN ANIME A ON R.AnimeID_FK = A.AnimeID
        INNER JOIN ESTUDIO E ON A.EstudioID_FK = E.EstudioID
        WHERE E.Nome = 'Wit Studio';
        
        SET end_time = NOW(6);
        
        SET exec_time = (TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000000);
        INSERT INTO TempTimesB VALUES (CONCAT('Tentativa ', i+1), exec_time);
        
        SET i = i + 1;
    END WHILE;

    SELECT AVG(Tempo_Segundos) INTO media_final FROM TempTimesB;

    SELECT Execucao, Tempo_Segundos FROM TempTimesB
    UNION ALL
    SELECT '--- MÉDIA FINAL (Versão B - Filho->Pai) ---', media_final;
    
    DROP TEMPORARY TABLE TempTimesB;
END //

DELIMITER ;


-- =================================================================
-- EXECUÇÃO DOS TESTES
-- =================================================================

CALL TesteConsulta7_VersaoA();
CALL TesteConsulta7_VersaoB();