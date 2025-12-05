-- ====================================================================
-- CONSULTA 4: Junção de 2 Relações (Reviews + Usuários)
-- Objetivo: Comparar JOIN (Set-Based) vs Subconsulta Correlacionada (Row-by-Row).
--           Cenário: Listar o texto de cada review e o nome do autor.
-- ====================================================================

USE `animes_db`;

DELIMITER //

-- ==================================================================
-- VERSÃO A: INNER JOIN (Otimizada / Set-Based)
-- O banco cruza as tabelas de uma vez, usando algoritmos de junção eficientes.
-- ==================================================================
DROP PROCEDURE IF EXISTS TesteConsulta4_VersaoA //

CREATE PROCEDURE TesteConsulta4_VersaoA()
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
        SELECT R.Texto, U.Username 
        FROM REVIEW R 
        INNER JOIN USUARIO U ON R.UsuarioID_FK = U.UsuarioID;
        
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
-- VERSÃO B: Subconsulta Correlacionada no SELECT (Lenta / N+1)
-- O banco é forçado a pausar e buscar o nome do usuário para CADA linha de review.
-- ==================================================================
DROP PROCEDURE IF EXISTS TesteConsulta4_VersaoB //

CREATE PROCEDURE TesteConsulta4_VersaoB()
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
        SELECT R.Texto, 
               (SELECT U.Username 
                FROM USUARIO U 
                WHERE U.UsuarioID = R.UsuarioID_FK) AS Autor
        FROM REVIEW R;
        
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

CALL TesteConsulta4_VersaoA();
CALL TesteConsulta4_VersaoB();