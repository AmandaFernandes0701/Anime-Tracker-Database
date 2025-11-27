-- ====================================================================
-- Arquivo: 01_criacao_esquema.sql
-- (VERSÃO MODIFICADA PARA NUVEM/RAILWAY)
--
-- Objetivo: Criar as tabelas e relacionamentos conforme documentação oficial.
-- ====================================================================

-- 1. SELEÇÃO DO BANCO DE DADOS DA NUVEM
USE `railway`;

-- --------------------------------------------------------------------
-- 2. REMOÇÃO DE TABELAS (para re-execução limpa)
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS `WATCHLIST`;
DROP TABLE IF EXISTS `ANIME_GENERO`;
DROP TABLE IF EXISTS `REVIEW`;
DROP TABLE IF EXISTS `ANIME`;
DROP TABLE IF EXISTS `ESTUDIO`;
DROP TABLE IF EXISTS `USUARIO`;


-- --------------------------------------------------------------------
-- 3. CRIAÇÃO DAS TABELAS (DDL)
-- --------------------------------------------------------------------

-- Tabela 1: ESTUDIO
CREATE TABLE IF NOT EXISTS `ESTUDIO` (
  `EstudioID` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(100) NOT NULL,
  `AnoFundacao` INT NULL,
  PRIMARY KEY (`EstudioID`),
  UNIQUE INDEX `Nome_UNIQUE` (`Nome` ASC)
);

-- Tabela 2: USUARIO
CREATE TABLE IF NOT EXISTS `USUARIO` (
  `UsuarioID` INT NOT NULL AUTO_INCREMENT,
  `Username` VARCHAR(50) NOT NULL,
  `Email` VARCHAR(100) NOT NULL,
  `DataCadastro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`UsuarioID`),
  UNIQUE INDEX `Username_UNIQUE` (`Username` ASC),
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC)
);

-- Tabela 3: ANIME
-- Mantido como Estúdio Opcional (NULL) com SET NULL
CREATE TABLE IF NOT EXISTS `ANIME` (
  `AnimeID` INT NOT NULL AUTO_INCREMENT,
  `Titulo` VARCHAR(255) NOT NULL,
  `Sinopse` TEXT NULL,
  `DataLancamento` DATE NULL,
  `EstudioID_FK` INT NULL,
  PRIMARY KEY (`AnimeID`),
  INDEX `fk_ANIME_ESTUDIO_idx` (`EstudioID_FK` ASC),
  CONSTRAINT `fk_ANIME_ESTUDIO`
    FOREIGN KEY (`EstudioID_FK`)
    REFERENCES `ESTUDIO` (`EstudioID`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

-- Tabela 4: REVIEW
-- Atualizado: Sem ReviewID, Chave Primária Composta
CREATE TABLE IF NOT EXISTS `REVIEW` (
  `Texto` TEXT NOT NULL,
  `Data` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UsuarioID_FK` INT NOT NULL,
  `AnimeID_FK` INT NOT NULL,
  -- Chave Primária agora é a combinação de Usuário e Anime
  PRIMARY KEY (`UsuarioID_FK`, `AnimeID_FK`),
  INDEX `fk_REVIEW_USUARIO_idx` (`UsuarioID_FK` ASC),
  INDEX `fk_REVIEW_ANIME_idx` (`AnimeID_FK` ASC),
  CONSTRAINT `fk_REVIEW_USUARIO`
    FOREIGN KEY (`UsuarioID_FK`)
    REFERENCES `USUARIO` (`UsuarioID`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_REVIEW_ANIME`
    FOREIGN KEY (`AnimeID_FK`)
    REFERENCES `ANIME` (`AnimeID`)
    ON DELETE CASCADE
);

-- --------------------------------------------------------------------
-- 4. CRIAÇÃO DAS TABELAS DE MAPEAMENTO
-- --------------------------------------------------------------------

-- Tabela 5: ANIME_GENERO
CREATE TABLE IF NOT EXISTS `ANIME_GENERO` (
  `AnimeID_FK` INT NOT NULL,
  `Genero` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`AnimeID_FK`, `Genero`),
  INDEX `fk_ANIME_GENERO_ANIME_idx` (`AnimeID_FK` ASC),
  CONSTRAINT `fk_ANIME_GENERO_ANIME`
    FOREIGN KEY (`AnimeID_FK`)
    REFERENCES `ANIME` (`AnimeID`)
    ON DELETE CASCADE
);

-- Tabela 6: WATCHLIST
CREATE TABLE IF NOT EXISTS `WATCHLIST` (
  `UsuarioID_FK` INT NOT NULL,
  `AnimeID_FK` INT NOT NULL,
  `Status` ENUM('Assistindo', 'Completo', 'Planejando', 'Desistiu') NOT NULL,
  `NotaDada` INT NULL,
  `EpisodioAtual` INT NULL DEFAULT 0,
  PRIMARY KEY (`UsuarioID_FK`, `AnimeID_FK`),
  INDEX `fk_WATCHLIST_ANIME_idx` (`AnimeID_FK` ASC),
  INDEX `fk_WATCHLIST_USUARIO_idx` (`UsuarioID_FK` ASC),
  CONSTRAINT `check_NotaDada_Range` CHECK ((`NotaDada` >= 0) AND (`NotaDada` <= 10)),
  CONSTRAINT `fk_WATCHLIST_USUARIO`
    FOREIGN KEY (`UsuarioID_FK`)
    REFERENCES `USUARIO` (`UsuarioID`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_WATCHLIST_ANIME`
    FOREIGN KEY (`AnimeID_FK`)
    REFERENCES `ANIME` (`AnimeID`)
    ON DELETE CASCADE
);
