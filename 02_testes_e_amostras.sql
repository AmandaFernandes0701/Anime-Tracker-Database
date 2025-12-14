-- ====================================================================
-- Arquivo: 02_testes_e_amostras.sql
-- (VERSÃO AJUSTADA PARA LOCALHOST - ANIMES_DB)
-- ====================================================================

-- 1. SELEÇÃO DO BANCO
-- Se estiver rodando LOCAL (no seu PC), use 'animes_db'.
-- Se estiver rodando na NUVEM (Railway), mude para 'railway'.
USE `animes_db`; 

-- --------------------------------------------------------------------
-- 2. LIMPEZA DE DADOS (TRUNCATE)
-- --------------------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE `ESTUDIO`;
TRUNCATE TABLE `USUARIO`;
TRUNCATE TABLE `ANIME`;
TRUNCATE TABLE `REVIEW`;
TRUNCATE TABLE `ANIME_GENERO`;
TRUNCATE TABLE `WATCHLIST`; 
SET FOREIGN_KEY_CHECKS = 1;


-- --------------------------------------------------------------------
-- 3. INSERÇÃO DE DADOS DE AMOSTRA
-- --------------------------------------------------------------------

INSERT INTO `ESTUDIO` (`Nome`, `AnoFundacao`) VALUES
('MAPPA', 2011),
('Wit Studio', 2012),
('Ufotable', 2000);

INSERT INTO `USUARIO` (`Username`, `Email`, `DataCadastro`) VALUES
('amanda_f', 'amanda@email.com', '2025-11-01 10:00:00'),
('joao_silva', 'joao@email.com', '2025-11-02 14:30:00');

INSERT INTO `ANIME` (`Titulo`, `Sinopse`, `DataLancamento`, `EstudioID_FK`) VALUES
('Jujutsu Kaisen', 'Um jovem luta com maldições...', '2020-10-03', 1),
('Attack on Titan (S1)', 'Humanidade luta contra titãs...', '2013-04-07', 2),
('Demon Slayer', 'Um jovem caçador de demônios...', '2019-04-06', 3);

INSERT INTO `ANIME_GENERO` (`AnimeID_FK`, `Genero`) VALUES
(1, 'Ação'), (1, 'Sobrenatural'), (1, 'Shounen'),
(2, 'Ação'), (2, 'Drama'), (2, 'Fantasia Sombria');

-- Tabela WATCHLIST (Antiga LISTA_USUARIO)
INSERT INTO `WATCHLIST` (`UsuarioID_FK`, `AnimeID_FK`, `Status`, `NotaDada`, `EpisodioAtual`) VALUES
(1, 1, 'Assistindo', 10, 12),
(1, 2, 'Completo', 9, 25),
(2, 3, 'Planejando', NULL, 0);

-- Tabela REVIEW (Com coluna 'Texto' e sem ID)
INSERT INTO `REVIEW` (`Texto`, `UsuarioID_FK`, `AnimeID_FK`) VALUES
('Uma obra-prima de animação e história!', 1, 2);


-- --------------------------------------------------------------------
-- 4. VERIFICAÇÃO FINAL
-- --------------------------------------------------------------------
SELECT * FROM `ESTUDIO`;
SELECT * FROM `USUARIO`;
SELECT * FROM `ANIME`;
SELECT * FROM `ANIME_GENERO` WHERE `AnimeID_FK` = 1;
SELECT * FROM `WATCHLIST` WHERE `UsuarioID_FK` = 1;
SELECT * FROM `REVIEW` WHERE `UsuarioID_FK` = 1;
