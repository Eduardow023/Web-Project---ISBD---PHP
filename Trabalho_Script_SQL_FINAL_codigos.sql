


/*Altera a tabela Produto adicionando a coluna tamanho_dm*/

ALTER TABLE PRODUTO ADD COLUMN tamanho_cm DECIMAL(8,2) NULL;

/*Altera a tabela excluindo a tabela complemento*/

ALTER TABLE pessoa DROP COLUMN complemento CASCADE; 

/*Altera a tabela Cliente, onde a coluna tipo assinatura se não declarada e atribuído o tipo 'semanal'*/

ALTER TABLE Cliente  ALTER COLUMN tipo_assinatura SET 
DEFAULT 'semanal';



/*Cria uma tabela teste */

CREATE TABLE TABELA_teste (
idtest         INT         NOT NULL,
nometeste   VARCHAR(30)    NOT NULL,
CONSTRAINT pk_dep PRIMARY KEY (idDepto)
);

/*Exclui a tabela teste*/

DROP TABLE TABELA_teste;




/*UPDATE
Modifica o valor do anuncio quando o id_produto for 3*/

UPDATE Anuncio 
SET valor = valor*1.1
WHERE id_produto= 3;

/*Alterar o cargo do jornalista para repórter, quando a especialidade for Tecnologia */

UPDATE Jornalista
SET cargo = 'Repórter'
WHERE especialidade='Tecnologia';


/*Alterar a categoria da matéria para Fashion, quando a categoria for Moda*/

UPDATE Materia
SET categoria = 'Fashion'
WHERE categoria = 'Moda';


/*Alterar o nome da revista, quando o tipo for Esportes*/

UPDATE Revista
SET nome = 'Point Sports'
WHERE tipo ='Esportes';

/*UPDATE ANINHADO
Alterar valor do anuncio, onde o preço dos produtos é maior que 300*/

UPDATE Anuncio
SET valor = valor*2.2
WHERE id_produto IN(
      SELECT id_produto
      FROM Produto
      WHERE preço > 300);

/*Deleta uma Pessoa com CPF '44444444444'*/

DELETE FROM Pessoa
WHERE CPF = '44444444444';

/*Deletar empresa com CNPJ '12345678000199'*/

DELETE FROM Empresa_Anunciante
WHERE CNPJ = '12345678000199';

/*Deletar o produto com id_produto = 3*/
DELETE FROM Produto
WHERE id_produto = 3;

/*Deletar os clientes com assinatura "semanal"*/
DELETE FROM Cliente 
WHERE assinatura='semanal';

/*DELETE ANINHADO
Deletar o telefone de uma empresa anunciante, quando o seu CNPJ 56789012000105*/
DELETE FROM Telefone_Empresa
WHERE CNPJ IN (SELECT CNPJ
               FROM `Empresa Anunciante`
               WHERE CNPJ = '56789012000105');            



/*CONSULTAS*/

/*F1
Mostra os dados de Revistas e suas Edições respectivamente*/

SELECT *
FROM Revista R INNER JOIN Edição E
WHERE R.codigo_revista=E.codigo_revista;

/*F2
Exibe o nome e o cpf das pessoas e se as mesma forem jornalistas ou modelos ou clientes ele exibe seus atributos se não forem ele exibe null*/

SELECT P.CPF, P.nome, J.cargo, M.agencia, C.tipo_assinatura
FROM Pessoa P
LEFT JOIN Jornalista J
    ON P.CPF = J.CPF
LEFT JOIN Modelo m
    ON P.CPF = M.CPF
LEFT JOIN Cliente c
    ON P.CPF = C.CPF;

/*F3
Ordena as data da compra  de uma revista de uma determinado tipo */

SELECT data_da_compra, nome
FROM Revista R JOIN e_assinada_por a ON R.codigo_revista=a.codigo_revista
WHERE tipo = 'Moda' 
ORDER BY data_da_compra ASC, nome DESC;

/*F4
Faz a media do valor gasto com base no preço dos anúncios de Empresas que contrataram anúncios*/

SELECT nome_fantasia, AVG(Valor) AS media_preço
FROM Empresa_Anunciante E JOIN contrata_para c ON E.CNPJ=c.CNPJ JOIN Anuncio A ON A.id_anuncio=c.id_anuncio
GROUP BY E.CNPJ, E.nome_fantasia;


/*F5
Faz a media do valor gasto com base no preço dos anúncios de Empresas que contrataram anúncios 
porem mostra somente os valores onde a media e maior que  6000 */

SELECT nome_fantasia, AVG(valor) AS media_preco
FROM Empresa_Anunciante E
JOIN contrata_para c ON E.CNPJ = c.CNPJ
JOIN Anuncio A ON A.id_anuncio = c.id_anuncio
GROUP BY E.CNPJ, E.nome_fantasia
HAVING AVG(valor) > 6000;


/*F6
Recupere o nome de revistas que possuem assinaturas em datas >= que 01/01/2025 ou que tiveram Edição numero de vendas > que 10000*/
Select nome
From Revista R JOIN e_assinada_por e ON R.codigo_revista=e.codigo_revista
WHERE data_da_compra >= '2025-01-01'
UNION
Select nome 
FROM Revista R JOIN Edição E ON R.codigo_revista = E.codigo_revista
WHERE numVendas > 10000;


/*F7
Recupera o nome e o tipo de pessoa(Que Aparece na Tabela Pessoas)de Clientes que assinaram revistas do tipo 'Moda' ou que assinaram Revistas com edições contendo matérias escritas por Jornalista de CPF='11111111111'*/

SELECT DISTINCT P.nome, P.tipo_Pessoa
FROM Pessoa P JOIN Cliente C ON P.CPF = C.CPF JOIN e_assinada_por A ON C.CPF = A.CPF JOIN Revista R ON a.codigo_revista = r.codigo_revista
WHERE R.tipo = 'Moda' OR r.codigo_revista IN (
        SELECT e.codigo_revista
        FROM Edição E JOIN Materia M ON E.numero_edição = M.numero_edição AND E.codigo_revista = M.codigo_revista
        JOIN escreve ES ON M.idMateria =ES.idMateria
        WHERE ES.CPF = '11111111111'
   );




/*F8 - Recupera o código da Revista e seu nome, quando o tipo da Revista e seu nome possuem termos relacionadas a computação e tecnologia.*/


SELECT codigo_revista, nome
FROM Revista
WHERE tipo = 'Tecnologia'
    AND (
        nome LIKE '%Tecnologia%'
        OR nome LIKE '%Computação%'
        OR nome LIKE '%Programação%'
        OR nome LIKE '%Software%'
        OR nome LIKE '%Hardware%'
        OR nome LIKE '%IA%'
        OR nome LIKE '%Dados%'
        OR nome LIKE '%Digital%'
        OR nome LIKE '%Inovação%'
    );

/*F9 
Retornará dados das pessoas que não possuem complemento no endereço */

SELECT CPF, nome, logradouro, numero
FROM Pessoa
WHERE complemento IS NULL;

/*F10
Encontra os produtos cujo preço seja maior que o preço de pelo menos um outro produto(ser maior que o menor valor da relação).*/

SELECT id_produto, nome, preço
FROM Produto
WHERE preço > ANY (
    SELECT preço
    FROM Produto
);


/*F11
Encontra o produto mais caro.*/

SELECT id_produto, nome, preço
FROM Produto
WHERE preço >= ALL (
    SELECT preço
    FROM Produto
);


/*F12
Lista o nome e o cargo dos Jornalistas  que escreveram pelo menos uma matéria*/

SELECT p.nome, j.cargo
FROM Pessoa p
JOIN Jornalista j ON p.CPF = j.CPF
WHERE EXISTS (
    SELECT *
    FROM escreve e
    WHERE e.CPF = j.CPF
);



/*g)
Criação das Views e exemplificação de como usar*/

CREATE VIEW MateriaVer AS -- Faz a junção numa view da tabela Materia com suas devidas relações.
SELECT 
    R.nome AS nome_revista,
    R.codigo_revista,
    R.tipo AS tipo_revista,
    P.nome AS nome_jornalista,
    J.cargo, 
    J.especialidade
    FROM Revista R          
    JOIN Edição E ON R.codigo_revista = E.codigo_revista
    JOIN Materia M ON E.numero_edição = M.numero_edição AND E.codigo_revista = M.codigo_revista
    JOIN escreve W ON M.idMateria = W.idMateria
    JOIN Jornalista J ON W.CPF = J.CPF
    JOIN Pessoa P ON J.CPF = P.CPF;

/*Pode-se notar na junção das tabelas uma escolha por condição de junção (ou join condition),
usando do sinal de (=) ao contrário de usar-se o NATURAL JOIN que é disponibilizado pelo sql e faz
isso implicitamente, foi uma escolha no sentido de evitar erros e deixar mais claro como as
tabelas estão se comunicando.
*/

SELECT * FROM MateriaVer WHERE tipo_revista = 'Tecnologia';

/*Consulta a visão que acabamos de criar como se fosse uma tabela real, 
aplicando um filtro WHERE para exibir as relações apenas de revistas focadas em tecnologia.*/




CREATE VIEW MateriasPorJornalista AS -- Fará a contagem (agregação) de matérias por autor.
SELECT
    nome_jornalista,
    cargo, 
    COUNT(*) AS total_materias
FROM MateriaVer 
GROUP BY nome_jornalista, cargo;

SELECT nome_jornalista, total_materias
FROM MateriasPorJornalista
WHERE total_materias = (SELECT MAX(total_materias) FROM MateriasPorJornalista);

/*Realiza uma consulta na visão utilizando uma subconsulta (consulta aninhada) na parte do WHERE. 
A subconsulta encontra o maior valor numérico de matérias publicadas usando MAX, e a consulta externa
traz os dados do(s) jornalista(s) que alcançaram exatamente esse número, ou seja o(s) jornalista(s) que
mais publicaram matérias até o presente momento da cosulta! */




CREATE VIEW AnunciosEmpresa AS
SELECT
    EA.nome_fantasia,
    EA.CNPJ,
    A.id_anuncio,
    A.Valor AS valor_anuncio,
    A.descrição
FROM Empresa_Anunciante EA
JOIN contrata_para C ON EA.CNPJ = C.CNPJ
JOIN Anuncio A ON C.id_anuncio = A.id_anuncio;

/*Cria uma visão consolidando os dados dos anunciantes. 
Faz junções sucessivas entre a tabela da empresa, a tabela relacional contrata_para e a tabela de Anuncio.*/

SELECT nome_fantasia, SUM(valor_anuncio) AS investimento_total
FROM AnunciosEmpresa
GROUP BY nome_fantasia
ORDER BY investimento_total DESC;

/* Consulta a visão para somar todo o capital investido por cada anunciante. A função SUM consolida os valores, 
agrupados por empresa pelo GROUP BY, e o comando ORDER BY... DESC garante que o resultado apareça 
ordenado da empresa que mais gastou para a que menos gastou. */






/*h)
Criação e Exclusão de Usuários */

CREATE USER 'Rian'@'%' IDENTIFIED BY '1123581321';
CREATE USER 'Davi'@'localhost' IDENTIFIED BY '120120';
CREATE USER 'Tharlon'@'localhost' IDENTIFIED BY 'abcd';


DROP USER 'Rian'@'%';
DROP USER 'Davi'@'localhost';
DROP USER 'Tharlon'@'localhost';



-- Concede ao usuário Rian, privilégios de administrador do banco de dados (GRANT).
GRANT ALL PRIVILEGES ON *.* TO 'Rian'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;


-- Concede ao usuário Davi, todos os privilégios às tabelas Pessoa e Cliente (GRANT).
GRANT ALL ON mydb.Pessoa TO 'Davi'@'localhost';
GRANT ALL ON mydb.Cliente TO 'Davi'@'localhost';

/* Concede ao usuário Wesley, direito de alterar a coluna 'cargo' e 'especialidade' na tabela Jornalista.
Como também a coluna 'agencia' na tabela Modelo. */
GRANT UPDATE (cargo, especialidade) ON mydb.Jornalista TO 'Davi'@'localhost';
GRANT UPDATE (agencia) ON mydb.Modelo TO 'Davi'@'localhost';
FLUSH PRIVILEGES;


/* Concede ao usuário Tharlon, direito de executar funções SELECT, INSERT, DELETE e UPDATE
nas tabelas Empresa_Anunciante, Telefone_Empresa, Anuncio e Produto. (GRANT)*/

GRANT SELECT, INSERT, DELETE, UPDATE ON mydb.Empresa_Anunciante TO 'Tharlon'@'localhost';
GRANT SELECT, INSERT, DELETE, UPDATE ON mydb.Telefone_Empresa TO 'Tharlon'@'localhost';
GRANT SELECT, INSERT, DELETE, UPDATE ON mydb.Anuncio TO 'Tharlon'@'localhost';
GRANT SELECT, INSERT, DELETE, UPDATE ON mydb.Produto TO 'Tharlon'@'localhost';


-- Mostra as permissões dos usuários.
SHOW GRANTS FOR 'Rian'@'%';
SHOW GRANTS FOR 'Davi'@'localhost';




/* Revogação de permissão */

-- Revoga, do usuário Davi, todos os privilégios sobre tabela Cliente.
REVOKE ALL ON mydb.Cliente FROM 'Davi'@'localhost';


-- Revoga, do usuário Wesley, direito de alterar a coluna 'especialidade' na tabela Jornalista.


REVOKE UPDATE (especialidade) ON mydb.Jornalista FROM 'Davi'@'localhost';

/*i)
    1º*/

/* Procedimento: verifica se uma edição teve boas vendas */

DELIMITER $$

CREATE PROCEDURE VerificarVendas(
    IN p_numEdicao INT
)
BEGIN
    DECLARE v_vendas INT;

    SELECT numVendas
    INTO v_vendas
    FROM Edição
    WHERE numero_edição = p_numEdicao;

    IF v_vendas >= 10000 THEN
        SELECT 'Grande sucesso de vendas' AS Resultado;
    ELSE
        SELECT 'Vendas abaixo da meta' AS Resultado;
    END IF;

END $$

DELIMITER ;

/* TESTE */
CALL VerificarVendas(1002);



/*2º*/

/* Classifica o tipo de assinatura de um cliente. */

DELIMITER $$

CREATE PROCEDURE ClassificaTipoAssinatura(IN p_cpf CHAR(11))
BEGIN

    DECLARE v_tipo VARCHAR(20);

    SELECT tipo_assinatura
    INTO v_tipo
    FROM Cliente
    WHERE CPF = p_cpf;

    IF v_tipo = 'Mensal' THEN
        SELECT 'Plano Básico' AS Classificacao;

    ELSEIF v_tipo = 'Trimestral' THEN
        SELECT 'Plano Intermediário' AS Classificacao;

    ELSEIF v_tipo = 'Anual' THEN
        SELECT 'Plano Premium' AS Classificacao;

    ELSE
        SELECT 'Cliente ou plano não encontrado' AS Classificacao;
    END IF;

END $$

DELIMITER ;

/* TESTE */
CALL ClassificaTipoAssinatura('12093874655');


/*3º
Listar todas as revistas de um determinado tipo*/

DELIMITER $$

CREATE PROCEDURE ListarRevistasPorTipo(IN p_tipo VARCHAR(20))
BEGIN

    SELECT
        codigo_revista,
        UPPER(nome) AS nome_revista,
        tipo
    FROM Revista
    WHERE tipo = p_tipo
    ORDER BY nome;

END $$

DELIMITER ;

CALL ListarRevistasPorTipo('Tecnologia');




/*j)
Trigger para quando uma pessoa for add como jornalista, não ser add como modelo e vice-versa*/

/*1º
Evita modelo virar jornalista:*/

DELIMITER $$

CREATE TRIGGER trg_jornalista_disjunto
BEFORE INSERT ON Jornalista
FOR EACH ROW
BEGIN

    IF NOT EXISTS (
        SELECT 1
        FROM Pessoa
        WHERE CPF = NEW.CPF
          AND tipo_Pessoa = 'J'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pessoa nao possui tipo J';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM Modelo
        WHERE CPF = NEW.CPF
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pessoa já esta cadastrada como Modelo';
    END IF;

END$$

DELIMITER ;


/*Evita jornalista virar modelo*/

DELIMITER $$

CREATE TRIGGER trg_modelo_disjunto
BEFORE INSERT ON Modelo
FOR EACH ROW
BEGIN

    IF NOT EXISTS (
        SELECT 1
        FROM Pessoa
        WHERE CPF = NEW.CPF
          AND tipo_Pessoa = 'M'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pessoa nao possui tipo M';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM Jornalista
        WHERE CPF = NEW.CPF
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pessoa ja esta cadastrada como Jornalista';
    END IF;

END$$

DELIMITER ;

/*EXEMPLO PRA TESTAR:*/
 
INSERT INTO Pessoa
VALUES (
'66677788899',
'Beatriz Costa',
'Rua das Palmeiras',
45,
NULL,
'Centro',
'Lavras',
'MG',
'37200011',
'M'
);
Select *
From Pessoa;

INSERT INTO Jornalista
VALUES (
'66677788899',
'Repórter',
'Moda'
);

INSERT INTO Modelo
VALUES (
'66677788899',
'Elite Models'
);


/*2ºTrigger que registra em um atabela quando houver mudança no tipo de assinatura de um Cliente*/

/* Tabela que registra a mudança (a troca) do plano de assinatura de uma Revista por um Cliente. */

CREATE TABLE registroAssinatura (
    idRegistro       INT         NOT NULL auto_increment PRIMARY KEY,
    cpfCliente       CHAR(11)    NOT NULL,
    nomeCliente      VARCHAR(80) NOT NULL,
    assinaturaAntiga VARCHAR(10) NOT NULL,
    novaAssinatura   VARCHAR(10) NOT NULL,
    user             VARCHAR(20) NOT NULL,
    dataHora         datetime    NOT NULL
);

DROP TRIGGER IF EXISTS assinatura_update;

DELIMITER $$
CREATE TRIGGER assinatura_update
AFTER UPDATE ON Cliente
FOR EACH ROW
BEGIN
    DECLARE v_nomeCliente VARCHAR(80);

    IF OLD.tipo_assinatura <> NEW.tipo_assinatura THEN

        SELECT p.nome
        INTO v_nomeCliente
        FROM Pessoa p
        WHERE p.CPF = NEW.CPF;

        INSERT INTO registroAssinatura
            (cpfCliente, nomeCliente, assinaturaAntiga, novaAssinatura, `user`, dataHora)
        VALUES
            (NEW.CPF, v_nomeCliente, OLD.tipo_assinatura, NEW.tipo_assinatura, USER(), NOW());
    END IF;
END$$

DELIMITER ;

select *
from Cliente
where CPF= '66666666666';

UPDATE Cliente
SET tipo_assinatura = 'semestral'
WHERE CPF= '66666666666';

select *
from registroAssinatura;



/*3º Trigger que registra após a exclusão a quantidade de dias que a uma determinada assinatura foi mantida*/


CREATE TABLE Registro_Exclusao_Assinatura (
    idAuditoria INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    CPF CHAR(11) NOT NULL,
    codigo_revista INT NOT NULL,
    data_inicio DATE NOT NULL,
    dias_assinatura INT NOT NULL,
    data_exclusao DATETIME NOT NULL
);

DELIMITER $$

CREATE TRIGGER registra_exclusao
BEFORE DELETE ON e_assinada_por
FOR EACH ROW
BEGIN

   DECLARE v_dias INT;

   /* calcula quantos dias o cliente ficou assinado */
   SET v_dias = DATEDIFF(CURDATE(), OLD.data_da_compra);

   INSERT INTO Registro_Exclusao_Assinatura (
      CPF, codigo_revista, data_inicio, dias_assinatura, data_exclusao
   )
   VALUES (
      OLD.CPF, OLD.codigo_revista, OLD.data_da_compra, v_dias, NOW()
   );

END $$

DELIMITER ;

DELETE FROM e_assinada_por
WHERE CPF = '12233344556' AND codigo_revista = 1;

SELECT * FROM Registro_Exclusao_Assinatura;



