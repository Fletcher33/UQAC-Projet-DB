-- Partie2.sql

USE projet_final_8TRD151;

DROP PROCEDURE IF EXISTS CreerEtudiant;
DROP PROCEDURE IF EXISTS AfficherInformationsEtudiant;
DROP PROCEDURE IF EXISTS MettreAJourInformationsEtudiant;
DROP PROCEDURE IF EXISTS SupprimerEtudiant;
DROP TABLE IF EXISTS historique_etudiant;



-- 2.1 CRÉER UN NOUVEL ÉTUDIANT
DELIMITER //

CREATE PROCEDURE CreerEtudiant(
    IN nom_etudiant VARCHAR(45),
    IN prenom_etudiant VARCHAR(60),
    IN code_permanent VARCHAR(15),
    IN numero_plaque VARCHAR(10),
    IN courriel_etudiant VARCHAR(55),
    IN telephone_etudiant VARCHAR(10),
    IN id_universite INT
)
BEGIN
    DECLARE nouvel_id_etudiant VARCHAR(10); -- Déclarer la variable en haut

    -- Vérification de la validité des données
    IF nom_etudiant = '' OR prenom_etudiant = '' OR code_permanent = '' OR numero_plaque = '' OR courriel_etudiant = '' OR telephone_etudiant = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tous les champs sont obligatoires.';

    -- Validation du nom
    ELSEIF NOT nom_etudiant REGEXP '^[a-zA-ZÀ-ÿ\\-\\\'\\s]+$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nom invalide.';

    -- Validation du prénom
    ELSEIF NOT prenom_etudiant REGEXP '^[A-Z][A-Za-z\é\è\ê\-]+$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Prénom invalide.';

    -- Validation du Code permanant
    ELSEIF NOT code_permanent REGEXP '^[A-Z]+[0-9]{8}$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Code permanant invalide.';

    -- Validation du numero de plaque
    ELSEIF NOT numero_plaque REGEXP '^[A-Za-z0-9\-]+$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Numéro de plaque invalide.';

    -- Validation du courriel
    ELSEIF NOT courriel_etudiant REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Courriel invalide.';

    -- Validation du numéro de téléphone
    ELSEIF NOT telephone_etudiant REGEXP '^\+[0-9]{1,3}\.[0-9]{1,14}$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Numéro de téléphone invalide.';

    ELSE
        -- Générer un nouvel identifiant étudiant (à adapter selon votre méthode)
        -- TODO : Voir question 4
        SET nouvel_id_etudiant = UUID();

        -- Insérer l'étudiant dans la base de données
        INSERT INTO etudiant (id_etudiant, nom_etudiant, prenom_etudiant, code_permanent, numero_plaque, courriel_etudiant, telephone_etudiant, id_universite)
        VALUES (nouvel_id_etudiant, nom_etudiant, prenom_etudiant, code_permanent, numero_plaque, courriel_etudiant, telephone_etudiant, id_universite);
    END IF;
END //

DELIMITER ;

-- 2.2 AFFICHER LES INFORMATIONS PERSONNELLES D’UN ÉTUDIANT
DELIMITER $

CREATE PROCEDURE AfficherInformationsEtudiant(
    IN id_etudiant_param VARCHAR(10)
)
BEGIN
    -- Vérifier si l'étudiant existe
    IF NOT EXISTS (SELECT * FROM etudiant WHERE id_etudiant = id_etudiant_param) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'L''étudiant spécifié n''existe pas.';
    END IF;

    -- Sélectionner les informations personnelles de l'étudiant
    SELECT *
    FROM etudiant
    WHERE id_etudiant = id_etudiant_param;
END $

DELIMITER ;


-- 2.3 METTRE À JOUR LES INFORMATIONS PERSONNELLES D’UN ÉTUDIANT
CREATE TABLE historique_etudiant (
    id_historique_etudiant INT AUTO_INCREMENT PRIMARY KEY,
    ancien_id_etudiant VARCHAR(10) NOT NULL,
    ancien_nom_etudiant VARCHAR(45) NOT NULL,
    ancien_prenom_etudiant VARCHAR(60) NOT NULL,
    ancien_code_permanent VARCHAR(15) NOT NULL,
    ancien_numero_plaque VARCHAR(10) NOT NULL,
    ancien_courriel_etudiant VARCHAR(55) NOT NULL,
    ancien_telephone_etudiant VARCHAR(10) NOT NULL,
    ancien_supprime TINYINT(1) UNSIGNED NOT NULL,
    ancien_id_universite INT(11) NOT NULL,
    date_modification DATETIME,
    KEY universite_fkhisto (ancien_id_universite),
    CONSTRAINT universite_fkhisto FOREIGN KEY (ancien_id_universite) REFERENCES universite (id_universite) ON DELETE NO ACTION ON UPDATE NO ACTION
);

DELIMITER $
DELIMITER $

CREATE PROCEDURE MettreAJourInformationsEtudiant(
    IN id_etudiant_param VARCHAR(10),
    IN nouveau_nom_etudiant VARCHAR(45),
    IN nouveau_prenom_etudiant VARCHAR(60),
    IN nouveau_code_permanent VARCHAR(15),
    IN nouveau_numero_plaque VARCHAR(10),
    IN nouveau_courriel_etudiant VARCHAR(55),
    IN nouveau_telephone_etudiant VARCHAR(10),
    IN nouveau_universite INT
)
BEGIN
    -- Déclaration des variables pour les anciennes valeurs
    DECLARE ancien_nom_etudiant VARCHAR(45);
    DECLARE ancien_prenom_etudiant VARCHAR(60);
    DECLARE ancien_code_permanent VARCHAR(15);
    DECLARE ancien_numero_plaque VARCHAR(10);
    DECLARE ancien_courriel_etudiant VARCHAR(55);
    DECLARE ancien_telephone_etudiant VARCHAR(10);
    DECLARE ancien_supprime TINYINT(1) UNSIGNED;
    DECLARE ancien_universite INT;

    -- Vérifier si l'étudiant existe
    IF NOT EXISTS (SELECT * FROM etudiant WHERE id_etudiant = id_etudiant_param) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'L''étudiant spécifié n''existe pas.';
    END IF;

    -- Récupérer les anciennes valeurs
    SELECT
        nom_etudiant,
        prenom_etudiant,
        code_permanent,
        numero_plaque,
        courriel_etudiant,
        telephone_etudiant,
        supprime,
        id_universite
    INTO
        ancien_nom_etudiant,
        ancien_prenom_etudiant,
        ancien_code_permanent,
        ancien_numero_plaque,
        ancien_courriel_etudiant,
        ancien_telephone_etudiant,
        ancien_supprime,
        ancien_universite
    FROM
        etudiant
    WHERE
        id_etudiant = id_etudiant_param;

    -- Mettre à jour les informations de l'étudiant
    UPDATE etudiant
    SET
        nom_etudiant = IFNULL(nouveau_nom_etudiant, nom_etudiant),
        prenom_etudiant = IFNULL(nouveau_prenom_etudiant, prenom_etudiant),
        code_permanent = IFNULL(nouveau_code_permanent, code_permanent),
        numero_plaque = IFNULL(nouveau_numero_plaque, numero_plaque),
        courriel_etudiant = IFNULL(nouveau_courriel_etudiant, courriel_etudiant),
        telephone_etudiant = IFNULL(nouveau_telephone_etudiant, telephone_etudiant),
        id_universite = IFNULL(nouveau_universite, id_universite)
    WHERE
        id_etudiant = id_etudiant_param;

    -- Enregistrer dans l'historique
    INSERT INTO historique_etudiant (
        ancien_id_etudiant,
        ancien_nom_etudiant,
        ancien_prenom_etudiant,
        ancien_code_permanent,
        ancien_numero_plaque,
        ancien_courriel_etudiant,
        ancien_telephone_etudiant,
        ancien_supprime,
        ancien_id_universite,
        date_modification
    )
    VALUES (
        id_etudiant_param,
        ancien_nom_etudiant,
        ancien_prenom_etudiant,
        ancien_code_permanent,
        ancien_numero_plaque,
        ancien_courriel_etudiant,
        ancien_telephone_etudiant,
        ancien_supprime,
        ancien_universite,
        NOW()
    );
END $

DELIMITER ;

DELIMITER $

CREATE PROCEDURE SupprimerEtudiant(
    IN id_etudiant_param VARCHAR(10)
)
BEGIN
    -- Vérifier si l'étudiant existe
    IF NOT EXISTS (SELECT * FROM etudiant WHERE id_etudiant = id_etudiant_param) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'L''étudiant spécifié n''existe pas.';
END IF;

    -- Marquer l'étudiant comme supprimé
UPDATE etudiant
SET supprime = 1
WHERE id_etudiant = id_etudiant_param;
END$

DELIMITER ;
