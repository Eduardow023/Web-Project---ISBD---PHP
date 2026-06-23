-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Pessoa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Pessoa` (
  `CPF` CHAR(11) NOT NULL,
  `nome` VARCHAR(80) NOT NULL,
  `logradouro` VARCHAR(40) NOT NULL,
  `numero` INT(5) NOT NULL,
  `complemento` VARCHAR(30) NULL,
  `bairro` VARCHAR(30) NOT NULL,
  `cidade` VARCHAR(30) NOT NULL,
  `estado` CHAR(2) NOT NULL,
  `cep` VARCHAR(8) NOT NULL,
  `tipo_Pessoa` CHAR(1) NOT NULL,
  PRIMARY KEY (`CPF`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Jornalista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Jornalista` (
  `CPF` CHAR(11) NOT NULL,
  `cargo` VARCHAR(30) NOT NULL,
  `especialidade` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`CPF`),
  CONSTRAINT `fk_Jornalista_Pessoa1`
    FOREIGN KEY (`CPF`)
    REFERENCES `mydb`.`Pessoa` (`CPF`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Modelo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Modelo` (
  `CPF` CHAR(11) NOT NULL,
  `agencia` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`CPF`),
  CONSTRAINT `fk_Modelo_Pessoa1`
    FOREIGN KEY (`CPF`)
    REFERENCES `mydb`.`Pessoa` (`CPF`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Cliente` (
  `CPF` CHAR(11) NOT NULL,
  `tipo_assinatura` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`CPF`),
  INDEX `fk_Cliente_Pessoa1_idx` (`CPF` ASC) VISIBLE,
  CONSTRAINT `fk_Cliente_Pessoa1`
    FOREIGN KEY (`CPF`)
    REFERENCES `mydb`.`Pessoa` (`CPF`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Revista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Revista` (
  `codigo_revista` INT(2) NOT NULL,
  `nome` VARCHAR(40) NOT NULL,
  `tipo` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`codigo_revista`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Edição`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Edição` (
  `numero_edição` INT(4) NOT NULL,
  `codigo_revista` INT(2) NOT NULL,
  `datapublicação` DATE NOT NULL,
  `numVendas` INT(9) NOT NULL,
  PRIMARY KEY (`numero_edição`, `codigo_revista`),
  INDEX `fk_Edição_Revista1_idx` (`codigo_revista` ASC) VISIBLE,
  CONSTRAINT `fk_Edição_Revista1`
    FOREIGN KEY (`codigo_revista`)
    REFERENCES `mydb`.`Revista` (`codigo_revista`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Materia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Materia` (
  `idMateria` INT(6) NOT NULL,
  `titulo` TEXT(100) NOT NULL,
  `descrição` TEXT(500) NOT NULL,
  `categoria` VARCHAR(30) NOT NULL,
  `numero_edição` INT(4) NOT NULL,
  `codigo_revista` INT(2) NOT NULL,
  PRIMARY KEY (`idMateria`),
  INDEX `fk_Materia_Edição1_idx` (`numero_edição` ASC, `codigo_revista` ASC) VISIBLE,
  CONSTRAINT `fk_Materia_Edição1`
    FOREIGN KEY (`numero_edição` , `codigo_revista`)
    REFERENCES `mydb`.`Edição` (`numero_edição` , `codigo_revista`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Empresa_Anunciante`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Empresa_Anunciante` (
  `CNPJ` CHAR(14) NOT NULL,
  `nome_fantasia` VARCHAR(80) NOT NULL,
  `razao_social` VARCHAR(80) NOT NULL,
  `logradouro` VARCHAR(40) NOT NULL,
  `numero` INT(5) NOT NULL,
  `complemento` VARCHAR(30) NULL default 'Não fornecido',
  `bairro` VARCHAR(30) NOT NULL,
  `cidade` VARCHAR(30) NOT NULL,
  `estado` CHAR(2) NOT NULL,
  `cep` CHAR(8) NOT NULL,
  PRIMARY KEY (`CNPJ`),
  UNIQUE INDEX `nome_fantasia_UNIQUE` (`nome_fantasia` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Telefone_Empresa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Telefone_Empresa` (
  `Telefone` CHAR(11) NOT NULL,
  `CNPJ` CHAR(14) NOT NULL,
  PRIMARY KEY (`Telefone`, `CNPJ`),
  INDEX `fk_Telefone_Empresa_Empresa Anunciante1_idx` (`CNPJ` ASC) VISIBLE,
  CONSTRAINT `fk_Telefone_Empresa_Empresa Anunciante1`
    FOREIGN KEY (`CNPJ`)
    REFERENCES `mydb`.`Empresa_Anunciante` (`CNPJ`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Produto` (
  `id_produto` INT(4) NOT NULL,
  `preço` DECIMAL(8,2) NOT NULL,
  `nome` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`id_produto`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Anuncio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Anuncio` (
  `id_anuncio` INT(4) NOT NULL,
  `Valor` DECIMAL(8,2) NOT NULL,
  `descrição` TEXT(120) NOT NULL,
  `id_produto` INT(4) NOT NULL,
  PRIMARY KEY (`id_anuncio`),
  INDEX `fk_Anuncio_Produto1_idx` (`id_produto` ASC) VISIBLE,
  CONSTRAINT `fk_Anuncio_Produto1`
    FOREIGN KEY (`id_produto`)
    REFERENCES `mydb`.`Produto` (`id_produto`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`contrata_para`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`contrata_para` (
  `id_anuncio` INT(4) NOT NULL,
  `CPF` CHAR(11) NOT NULL,
  `CNPJ` CHAR(14) NOT NULL,
  PRIMARY KEY (`id_anuncio`, `CPF`, `CNPJ`),
  INDEX `fk_contrata_para_Anuncio1_idx` (`id_anuncio` ASC) VISIBLE,
  INDEX `fk_contrata_para_Modelo1_idx` (`CPF` ASC) VISIBLE,
  INDEX `fk_contrata_para_Empresa Anunciante1_idx` (`CNPJ` ASC) VISIBLE,
  CONSTRAINT `fk_contrata_para_Anuncio1`
    FOREIGN KEY (`id_anuncio`)
    REFERENCES `mydb`.`Anuncio` (`id_anuncio`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_contrata_para_Modelo1`
    FOREIGN KEY (`CPF`)
    REFERENCES `mydb`.`Modelo` (`CPF`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_contrata_para_Empresa Anunciante1`
    FOREIGN KEY (`CNPJ`)
    REFERENCES `mydb`.`Empresa_Anunciante` (`CNPJ`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`escreve`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`escreve` (
  `idMateria` INT(6) NOT NULL,
  `CPF` CHAR(11) NOT NULL,
  PRIMARY KEY (`idMateria`, `CPF`),
  INDEX `fk_Materia_has_Jornalista_Jornalista1_idx` (`CPF` ASC) VISIBLE,
  INDEX `fk_Materia_has_Jornalista_Materia1_idx` (`idMateria` ASC) VISIBLE,
  CONSTRAINT `fk_Materia_has_Jornalista_Materia1`
    FOREIGN KEY (`idMateria`)
    REFERENCES `mydb`.`Materia` (`idMateria`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Materia_has_Jornalista_Jornalista1`
    FOREIGN KEY (`CPF`)
    REFERENCES `mydb`.`Jornalista` (`CPF`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Telefone_Pessoa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Telefone_Pessoa` (
  `CPF` CHAR(11) NOT NULL,
  `telefone` CHAR(11) NOT NULL,
  PRIMARY KEY (`CPF`, `telefone`),
  INDEX `fk_Telefone_Pessoa_Pessoa1_idx` (`CPF` ASC) VISIBLE,
  CONSTRAINT `fk_Telefone_Pessoa_Pessoa1`
    FOREIGN KEY (`CPF`)
    REFERENCES `mydb`.`Pessoa` (`CPF`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`e_assinada_por`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`e_assinada_por` (
  `codigo_revista` INT(2) NOT NULL,
  `CPF` CHAR(11) NOT NULL,
  `data_da_compra` DATE NOT NULL,
  PRIMARY KEY (`codigo_revista`, `CPF`),
  INDEX `fk_Revista_has_Cliente_Cliente1_idx` (`CPF` ASC) VISIBLE,
  INDEX `fk_Revista_has_Cliente_Revista1_idx` (`codigo_revista` ASC) VISIBLE,
  CONSTRAINT `fk_Revista_has_Cliente_Revista1`
    FOREIGN KEY (`codigo_revista`)
    REFERENCES `mydb`.`Revista` (`codigo_revista`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Revista_has_Cliente_Cliente1`
    FOREIGN KEY (`CPF`)
    REFERENCES `mydb`.`Cliente` (`CPF`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`aparece_em`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`aparece_em` (
  `id_anuncio` INT(4) NOT NULL,
  `numero_edição` INT(4) NOT NULL,
  `codigo_revista` INT(2) NOT NULL,
  PRIMARY KEY (`id_anuncio`, `numero_edição`, `codigo_revista`),
  INDEX `fk_Anuncio_has_Edição_Edição1_idx` (`numero_edição` ASC, `codigo_revista` ASC) VISIBLE,
  INDEX `fk_Anuncio_has_Edição_Anuncio1_idx` (`id_anuncio` ASC) VISIBLE,
  CONSTRAINT `fk_Anuncio_has_Edição_Anuncio1`
    FOREIGN KEY (`id_anuncio`)
    REFERENCES `mydb`.`Anuncio` (`id_anuncio`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Anuncio_has_Edição_Edição1`
    FOREIGN KEY (`numero_edição` , `codigo_revista`)
    REFERENCES `mydb`.`Edição` (`numero_edição` , `codigo_revista`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



INSERT INTO Pessoa VALUES
('11111111111','João Silva','Rua A',100,NULL,'Centro','Lavras','MG','37200000','J'),
('22222222222','Maria Souza','Rua B',200,'Ap 1','Centro','Lavras','MG','37200001','J'),
('33333333333','Pedro Santos','Rua C',300,NULL,'Jardim America','Lavras','MG','37200002','J'),
('44444444444','Ana Lima','Rua D',400,NULL,'Jardim America','Lavras','MG','37200003','J'),
('55555555555','Carlos Oliveira','Rua E',500,NULL,'Centro','Lavras','MG','37200004','J'),
('66666666666','Roberto Machado','Rua D',70,NULL,'Centro','Lavras','MG','37098287','M'),
('77777777777','Amanda Almeida','Rua Poligono',2,NULL,'Centro','Lavras','MG','38098265','M'),
('88888888888','Pablo Freitas','Rua Oliva',219,NULL,'Alpino','Varginha','MG','32873890','M'),
('99999999999','Leonardo Paixão','Rua Carambola',309,NULL,'Centro','Ijaci','MG','37218000','M'),
('12345678910','Lua Moreira','Rua Ameixeira',238,NULL,'Americanas','São Paulo','SP','37291000','M'),
('12233344556','Paula Saldanha','Rua Firmamento',23,'Ap 102','Centro','Lavras','MG','37219000','C'),
('12093874655','João Augusto','Rua Almeida',123,NULL,'Vila Industrial','Perdões','MG','38112999','C'),
('38747468280','Aparecida Lima','Rua Marques',109,NULL,'Vila Maria','Manaus','AM','31928098','C'),
('93964862701','Junior Andrada','Rua Sucesso',128,NULL,'Centro','Itutinga','MG','37293000','C'),
('98237292301','Augusta Maria','Rua Sol',109,NULL,'Centro','Ijaci','MG','37218000','C');


INSERT INTO Jornalista VALUES
('11111111111','Editor','Esportes'),
('22222222222','Editor','Tecnologia'),
('33333333333','Repórter','Negócios'),
('44444444444','Fotógrafa','Cultura'),
('55555555555','Repórter','Moda'),
('29376101838','Colunista','Tecnologia');

INSERT INTO Modelo VALUES
('66666666666','Elite Models'),
('77777777777','Ford Models'),
('88888888888','Mega Model Brasil'),
('99999999999','Way Model'),
('12345678910','Joy Model Management');

INSERT INTO Cliente VALUES 
('12233344556','Mensal'), 
('12093874655','Anual'), 
('38747468280','Mensal'), 
('93964862701','Trimestral'), 
('98237292301','Anual'),
('12345678910','Anual'),
('66666666666','semanal'),
('55555555555','Trimestral');


INSERT INTO Revista VALUES
(1,'Esporte Total','Esportes'),
(2,'Inovação Digital','Tecnologia'),
(3,'Mercado em Foco','Negócios'),
(4,'Expressão Cultural','Cultura'),
(5,'Moda Atual','Moda'),
(6,'Ciência Todo Dia','Ciência'),
(7,'Jovem Geek','Entretenimento'),
(8,'BD Magazine','Tecnologia'),
(9,'Redes Inteligentes','Tecnologia'),
(10,'IA em Foco','Tecnologia'),
(11,'Web Trends','Entretenimento'),
(12,'Tendencias Verão Inverno','Moda'),
(13,'Jeans Nostalgia','Moda'),
(14,'Alta Costura Brazil','Moda');

INSERT INTO Edição VALUES
(1001,1,'2026-01-15',12000),
(1002,2,'2026-02-10',18500),
(1003,3,'2026-03-05',9800),
(1004,4,'2026-04-20',7500),
(1005,5,'2026-05-12',14200),
(1021,1,'2026-01-15',52050),
(1023,2,'2025-02-10',48090),
(1043,3,'2024-03-05',4300),
(1044,4,'2025-04-20',12700),
(2001,5,'2026-05-12',3900),
(1051,6,'2025-06-01',3500),
(1052,10,'2024-06-18',7100),
(1053,11,'2025-07-03',250),
(1060,7,'2025-07-15',4000),
(1066,11,'2024-08-08',3700),
(1101,2,'2023-08-22',1200),
(1102,1,'2022-09-10',100),
(1103,9,'2026-09-28',17100),
(1110,8,'2026-10-14',3600),
(1125,7,'2025-11-05',69200),
(1231,14,'2024-12-09',23000);


INSERT INTO Materia VALUES
(1,'Expectativas para Futebol Brasileiro em 2026','Análise das principais mudanças táticas e dos destaques da temporada.','Esportes',1001,1),

(2,'IA no Mercado','Como as empresas estão utilizando a IA para gerarem um maior percentual de lucro e potencializar suas vendas.','Tecnologia',1002,2),

(3,'Pequenas Empresas em Crescimento','Estudo sobre estratégias de expansão para negócios de médio porte.','Negócios',1003,3),

(4,'Semana da Arte Popular em São Paulo','Acompanhe os principais eventos culturais realizados durante o festival de Arte popular.','Cultura',1004,4),

(5,'Tendências da Moda para o inverno em 2026','As principais novidades apresentadas pelas grandes marcas.','Moda',1005,5),

(6,'Dicas para uso de Roupas de inverno no Brasil','Principais dicas para caprichar no look.','Moda',1231,14);

INSERT INTO Empresa_Anunciante VALUES
('23456789000102','SportMax','SportMax Comércio LTDA','Av. dos Atletas',250,NULL,'Jardim América','Belo Horizonte','MG','30110000'),

('12345678000101','Tech Solutions','Tech Solutions LTDA','Rua da Inovação',100,NULL,'Centro','São Paulo','SP','01001000'),

('56789012000105','Mercado Forte','Mercado Forte Publicidade LTDA','Rua dos Negócios',150,NULL,'Centro','Campinas','SP','13010000'),

('45678901000104','Cultura Viva','Cultura Viva Produções LTDA','Av. Cultural',300,NULL,'Centro','Curitiba','PR','80010000'),

('34567890000103','Elegance Fashion','Elegance Fashion LTDA','Rua das Flores',75,'Sala 2','Centro','Rio de Janeiro','RJ','20040000');

/*Exeplo default caso complemento nao seja declarado*/
INSERT INTO Empresa_Anunciante
(CNPJ, nome_fantasia, razao_social, logradouro, numero, bairro, cidade, estado, cep)
VALUES
('12345678000199', 'Tech Ads', 'Tech Ads LTDA', 'Rua A', 100, 'Centro', 'Lavras', 'MG', '37200000');

INSERT INTO Telefone_Empresa VALUES
('35992426345','12345678000101'),
('35987654322','23456789000102'),
('21987654323','34567890000103'),
('41987654324','45678901000104'),
('19987654325','56789012000105');


INSERT INTO Produto VALUES
(1,5999.90,'Notebook TechPro'),
(2,249.90,'Tênis Runner Max'),
(3,129.90,'Jaqueta Fashion'),
(4,89.90,'Livro Arte Brasileira'),
(5,399.90,'Curso Gestão Empresarial'),
(6,100.90,'Livro para Fianaças');

INSERT INTO Anuncio VALUES
(4821,15000.00,'Campanha de lançamento do Notebook TechPro',1),
(7354,8000.00,'Promoção da nova linha de tênis esportivos',2),
(1967,6000.00,'Divulgação da coleção primavera-verão',3),
(8412,3500.00,'Anúncio do lançamento do livro Arte Brasileira',4),
(5279,10000.00,'Campanha de matrículas para o curso de gestão',5),
(2937,1114.00,'Curso de ADM Financeiro',6);

INSERT INTO contrata_para VALUES
(4821,'66666666666','12345678000101'),
(7354,'77777777777','23456789000102'),
(1967,'88888888888','34567890000103'),
(8412,'99999999999','45678901000104'),
(5279,'12345678910','56789012000105'),
(2937,'66666666666','34567890000103');

INSERT INTO escreve VALUES
(1,'11111111111'),
(2,'22222222222'),
(3,'33333333333'),
(4,'44444444444'),
(5,'55555555555'),
(6,'55555555555');

INSERT INTO Telefone_Pessoa VALUES
('11111111111','35999123456'),
('22222222222','35999234567'),
('66666666666','35999345678'),
('77777777777','35999456789'),
('12233344556','35999567890');

INSERT INTO e_assinada_por VALUES
(1,'12233344556','2026-01-10'),
(2,'12093874655','2026-02-15'),
(3,'38747468280','2026-03-20'),
(4,'93964862701','2026-04-05'),
(5,'98237292301','2026-05-12'),
(12,'12093874655','2023-05-11'),
(13,'38747468280','2021-11-12'),
(14,'93964862701','2024-12-12'),
(14,'12345678910','2024-09-19'),
(1,'44444444444', '2025-09-06'),
(1,'55555555555','2024-11-09');


INSERT INTO aparece_em VALUES
(4821,1002,2),
(7354,1001,1),
(1967,1005,5),
(8412,1004,4),
(5279,1003,3);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
