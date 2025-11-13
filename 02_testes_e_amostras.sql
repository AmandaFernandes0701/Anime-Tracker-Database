-- ====================================================================
-- Arquivo: 02_testes_e_amostras.sql
-- Projeto: TP2 - Plataforma de Lista de Animes (IBD)
--
-- Objetivo: Inserir dados de amostra (amostras pequenas) para 
--           verificar a integridade do esquema, chaves estrangeiras 
--           e restrições ANTES de ir para o Colab.
-- ====================================================================

-- Informa ao MySQL para usar o banco de dados correto.
USE `animes_db`;

-- --------------------------------------------------------------------
-- 1. LIMPEZA DE DADOS DE TESTE (Opcional, mas recomendado)
-- --------------------------------------------------------------------
-- Como estamos testando, é bom apagar os dados anteriores para 
-- não gerar duplicatas. A ordem de DELETE é o oposto do INSERT.
-- NOTA: Desabilitamos a checagem de FK para facilitar o DELETE de tudo.
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE `ESTUDIO`;
TRUNCATE TABLE `USUARIO`;
TRUNCATE TABLE `ANIME`;
TRUNCATE TABLE `REVIEW`;
TRUNCATE TABLE `ANIME_GENERO`;
TRUNCATE TABLE `LISTA_USUARIO`;
SET FOREIGN_KEY_CHECKS = 1;


-- --------------------------------------------------------------------
-- 2. INSERÇÃO DE DADOS DE AMOSTRA (DML - INSERT)
-- Inserimos nas tabelas "pai" primeiro (sem FKs).
-- --------------------------------------------------------------------

-- Inserindo 3 Estúdios (Tabela "pai")
INSERT INTO `ESTUDIO` (`Nome`, `AnoFundacao`) VALUES
('MAPPA', 2011),
('Wit Studio', 2012),
('Ufotable', 2000);

-- Inserindo 2 Usuários (Tabela "pai")
INSERT INTO `USUARIO` (`Username`, `Email`, `DataCadastro`) VALUES
('amanda_f', 'amanda@email.com', '2025-11-01 10:00:00'),
('joao_silva', 'joao@email.com', '2025-11-02 14:30:00');


-- Agora inserimos nas tabelas "filho" (com FKs)
-- Note que usamos os IDs gerados acima (MAPPA=1, Wit=2, Ufotable=3)

-- Inserindo 3 Animes (depende de ESTUDIO)
INSERT INTO `ANIME` (`Titulo`, `Sinopse`, `DataLancamento`, `EstudioID_FK`) VALUES
('Jujutsu Kaisen', 'Um jovem luta com maldições...', '2020-10-03', 1), -- FK para MAPPA (ID: 1)
('Attack on Titan (S1)', 'Humanidade luta contra titãs...', '2013-04-07', 2), -- FK para Wit Studio (ID: 2)
('Demon Slayer', 'Um jovem caçador de demônios...', '2019-04-06', 3); -- FK para Ufotable (ID: 3)


-- Agora inserimos nas tabelas de mapeamento

-- Inserindo Gêneros (atributo multivalorado de ANIME)
-- Vamos adicionar gêneros para "Jujutsu Kaisen" (ID: 1)
INSERT INTO `ANIME_GENERO` (`AnimeID_FK`, `Genero`) VALUES
(1, 'Ação'),
(1, 'Sobrenatural'),
(1, 'Shounen');

-- Vamos adicionar gêneros para "Attack on Titan" (ID: 2)
INSERT INTO `ANIME_GENERO` (`AnimeID_FK`, `Genero`) VALUES
(2, 'Ação'),
(2, 'Drama'),
(2, 'Fantasia Sombria');


-- Inserindo na Lista de Usuários (relacionamento M:N)
-- A 'amanda_f' (ID: 1) vai adicionar 2 animes
INSERT INTO `LISTA_USUARIO` (`UsuarioID_FK`, `AnimeID_FK`, `Status`, `NotaDada`, `EpisodioAtual`) VALUES
(1, 1, 'Assistindo', 10, 12),     -- Amanda assistindo Jujutsu (ID: 1)
(1, 2, 'Completo', 9, 25);     -- Amanda completou AoT (ID: 2)

-- O 'joao_silva' (ID: 2) vai adicionar 1 anime
INSERT INTO `LISTA_USUARIO` (`UsuarioID_FK`, `AnimeID_FK`, `Status`, `NotaDada`, `EpisodioAtual`) VALUES
(2, 3, 'Planejando', NULL, 0); -- João planejando Demon Slayer (ID: 3)


-- Inserindo 1 Review (depende de USUARIO e ANIME)
-- A 'amanda_f' (ID: 1) vai fazer uma review de "Attack on Titan" (ID: 2)
INSERT INTO `REVIEW` (`TextoReview`, `UsuarioID_FK`, `AnimeID_FK`) VALUES
('Uma obra-prima de animação e história. O impacto da primeira temporada é inesquecível!', 1, 2);


-- --------------------------------------------------------------------
-- 3. VERIFICAÇÃO DOS DADOS (SELECT)
-- Usamos SELECT * para verificar visualmente se tudo foi inserido 
-- e conectado corretamente.
-- --------------------------------------------------------------------

-- Verificando as tabelas "pai"
SELECT * FROM `ESTUDIO`;
SELECT * FROM `USUARIO`;

-- Verificando a tabela "filho"
SELECT * FROM `ANIME`;

-- Verificando o atributo multivalorado (Gêneros de Jujutsu Kaisen)
SELECT * FROM `ANIME_GENERO` WHERE `AnimeID_FK` = 1;

-- Verificando o relacionamento M:N (Lista da Amanda)
SELECT * FROM `LISTA_USUARIO` WHERE `UsuarioID_FK` = 1;

-- Verificando a review da Amanda
SELECT * FROM `REVIEW` WHERE `UsuarioID_FK` = 1;


-- Teste final: Um JOIN para ver tudo conectado
-- "Mostrar o nome do usuário, o título do anime e a nota que ele deu"
SELECT 
    u.Username,
    a.Titulo,
    l.NotaDada,
    l.Status,
    l.EpisodioAtual
FROM 
    `LISTA_USUARIO` AS l
JOIN 
    `USUARIO` AS u ON l.UsuarioID_FK = u.UsuarioID
JOIN 
    `ANIME` AS a ON l.AnimeID_FK = a.AnimeID;

-- --------------------------------------------------------------------
-- FIM DO SCRIPT DE TESTE
-- --------------------------------------------------------------------