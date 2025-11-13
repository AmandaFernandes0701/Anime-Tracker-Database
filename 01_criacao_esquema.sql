-- ====================================================================
-- Arquivo: 01_criacao_esquema.sql
-- Projeto: TP2 - Plataforma de Lista de Animes (IBD)
--
-- Objetivo: Criar o esquema, tabelas e relacionamentos do banco.
-- ====================================================================

-- 1. CRIAÇÃO DO ESQUEMA (BANCO DE DADOS)
-- Cria o banco de dados (o "terreno") se ele não existir.
CREATE SCHEMA IF NOT EXISTS `animes_db` DEFAULT CHARACTER SET utf8mb4;

-- Informa ao MySQL para usar este banco em todos os comandos seguintes.
USE `animes_db`;

-- --------------------------------------------------------------------
-- 2. REMOÇÃO DE TABELAS (para re-execução limpa)
-- Remove as tabelas na ORDEM INVERSA da criação para evitar
-- erros de chave estrangeira.
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `LISTA_USUARIO`;
DROP TABLE IF EXISTS `ANIME_GENERO`;
DROP TABLE IF EXISTS `REVIEW`;
DROP TABLE IF EXISTS `ANIME`;
DROP TABLE IF EXISTS `ESTUDIO`;
DROP TABLE IF EXISTS `USUARIO`;


-- --------------------------------------------------------------------
-- 3. CRIAÇÃO DAS TABELAS (DDL)
-- Cria as tabelas na ORDEM CORRETA de dependência
-- (Tabelas "pai" primeiro, tabelas "filho" depois).
-- --------------------------------------------------------------------

-- Tabela 1: ESTUDIO (Entidade, "pai")
-- Armazena os estúdios de animação.
CREATE TABLE IF NOT EXISTS `ESTUDIO` (
  `EstudioID` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(100) NOT NULL,
  `AnoFundacao` INT NULL,
  PRIMARY KEY (`EstudioID`),
  UNIQUE INDEX `Nome_UNIQUE` (`Nome` ASC) -- Garante que não há estúdios com mesmo nome
);

-- Tabela 2: USUARIO (Entidade, "pai")
-- Armazena os usuários da plataforma.
CREATE TABLE IF NOT EXISTS `USUARIO` (
  `UsuarioID` INT NOT NULL AUTO_INCREMENT,
  `Username` VARCHAR(50) NOT NULL,
  `Email` VARCHAR(100) NOT NULL,
  `DataCadastro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`UsuarioID`),
  UNIQUE INDEX `Username_UNIQUE` (`Username` ASC),
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC)
);

-- Tabela 3: ANIME (Entidade, "filho" de ESTUDIO)
-- Armazena o catálogo de animes.
CREATE TABLE IF NOT EXISTS `ANIME` (
  `AnimeID` INT NOT NULL AUTO_INCREMENT,
  `Titulo` VARCHAR(255) NOT NULL,
  `Sinopse` TEXT NULL,
  `DataLancamento` DATE NULL,
  `EstudioID_FK` INT NULL, -- "NULL" permite animes sem estúdio cadastrado
  PRIMARY KEY (`AnimeID`),
  INDEX `fk_ANIME_ESTUDIO_idx` (`EstudioID_FK` ASC),
  CONSTRAINT `fk_ANIME_ESTUDIO`
    FOREIGN KEY (`EstudioID_FK`)
    REFERENCES `ESTUDIO` (`EstudioID`)
    ON DELETE SET NULL -- Se um estúdio for deletado, o anime não é deletado,
                        -- apenas perde a referência (fica "NULL").
    ON UPDATE CASCADE -- Se o ID do estúdio mudar, atualiza aqui também.
);

-- Tabela 4: REVIEW (Entidade, "filho" de USUARIO e ANIME)
-- Armazena as reviews (críticas) que os usuários fazem.
CREATE TABLE IF NOT EXISTS `REVIEW` (
  `ReviewID` INT NOT NULL AUTO_INCREMENT,
  `TextoReview` TEXT NOT NULL,
  `DataReview` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UsuarioID_FK` INT NOT NULL,
  `AnimeID_FK` INT NOT NULL,
  PRIMARY KEY (`ReviewID`),
  INDEX `fk_REVIEW_USUARIO_idx` (`UsuarioID_FK` ASC),
  INDEX `fk_REVIEW_ANIME_idx` (`AnimeID_FK` ASC),
  -- Garante que um usuário só pode fazer UMA review por anime
  UNIQUE INDEX `idx_Usuario_Anime_Unico` (`UsuarioID_FK` ASC, `AnimeID_FK` ASC),
  CONSTRAINT `fk_REVIEW_USUARIO`
    FOREIGN KEY (`UsuarioID_FK`)
    REFERENCES `USUARIO` (`UsuarioID`)
    ON DELETE CASCADE, -- Se o usuário for deletado, sua review também é.
  CONSTRAINT `fk_REVIEW_ANIME`
    FOREIGN KEY (`AnimeID_FK`)
    REFERENCES `ANIME` (`AnimeID`)
    ON DELETE CASCADE -- Se o anime for deletado, a review dele também é.
);

-- --------------------------------------------------------------------
-- 4. CRIAÇÃO DAS TABELAS DE MAPEAMENTO (Requisitos do TP)
-- --------------------------------------------------------------------

-- Tabela 5: ANIME_GENERO (Mapeamento de Atributo Multivalorado)
-- Mapeia o atributo multivalorado "Gêneros" da entidade ANIME.
-- Garante a 1ª Forma Normal (1FN).
CREATE TABLE IF NOT EXISTS `ANIME_GENERO` (
  `AnimeID_FK` INT NOT NULL,
  `Genero` VARCHAR(50) NOT NULL,
  -- Chave primária composta: um anime só pode ter um gênero "Shounen" uma vez.
  PRIMARY KEY (`AnimeID_FK`, `Genero`),
  INDEX `fk_ANIME_GENERO_ANIME_idx` (`AnimeID_FK` ASC),
  CONSTRAINT `fk_ANIME_GENERO_ANIME`
    FOREIGN KEY (`AnimeID_FK`)
    REFERENCES `ANIME` (`AnimeID`)
    ON DELETE CASCADE -- Se o anime for deletado, seus gêneros também são.
);

-- Tabela 6: LISTA_USUARIO (Mapeamento de Relacionamento M:N com Atributos)
-- Mapeia o relacionamento M:N "Usuário-Assiste-Anime".
-- Contém os atributos do relacionamento (Status, Nota, etc.).
CREATE TABLE IF NOT EXISTS `LISTA_USUARIO` (
  `UsuarioID_FK` INT NOT NULL,
  `AnimeID_FK` INT NOT NULL,
  `Status` ENUM('Assistindo', 'Completo', 'Planejando', 'Desistiu') NOT NULL,
  `NotaDada` INT NULL,
  `EpisodioAtual` INT NULL DEFAULT 0,
  -- Chave primária composta: um usuário só pode ter um anime na lista uma vez.
  PRIMARY KEY (`UsuarioID_FK`, `AnimeID_FK`),
  INDEX `fk_LISTA_USUARIO_ANIME_idx` (`AnimeID_FK` ASC),
  INDEX `fk_LISTA_USUARIO_USUARIO_idx` (`UsuarioID_FK` ASC),
  -- Restrição para garantir que a nota seja válida (0 a 10)
  CONSTRAINT `check_NotaDada_Range` CHECK ((`NotaDada` >= 0) AND (`NotaDada` <= 10)),
  CONSTRAINT `fk_LISTA_USUARIO_USUARIO`
    FOREIGN KEY (`UsuarioID_FK`)
    REFERENCES `USUARIO` (`UsuarioID`)
    ON DELETE CASCADE, -- Se o usuário for deletado, sua lista morre com ele.
  CONSTRAINT `fk_LISTA_USUARIO_ANIME`
    FOREIGN KEY (`AnimeID_FK`)
    REFERENCES `ANIME` (`AnimeID`)
    ON DELETE CASCADE -- Se o anime for deletado, ele some da lista de todos.
);

-- --------------------------------------------------------------------
-- FIM DO SCRIPT
-- --------------------------------------------------------------------