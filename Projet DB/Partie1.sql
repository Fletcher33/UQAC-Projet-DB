USE projet_final_8TRD151;

DROP PROCEDURE IF EXISTS ConfigurerNouvelleAireStationnement;
DROP TABLE IF EXISTS log_aire_stationnement;
DROP TRIGGER IF EXISTS LogCreationAireStationnement;


DELIMITER $

CREATE PROCEDURE ConfigurerNouvelleAireStationnement(
    IN nom_universite VARCHAR(45),
    IN sigle_universite VARCHAR(10),
    IN numero_civique VARCHAR(5),
    IN nom_rue VARCHAR(15),
    IN ville VARCHAR(45),
    IN province ENUM('Alberta','Colombie-Britannique','Île-du-Prince-Édouard','Manitoba','Nouveau-Brunswick','Nouvelle-Écosse','Ontario','Québec','Saskatchewan','Terre-Neuve-et-Labrador','Territoires du Nord-Ouest','Nunavut','Yukon'),
    IN code_postal VARCHAR(7),
    IN designation_espace_stationnement VARCHAR(45)
)
BEGIN
    DECLARE universite_count INT;
    DECLARE i INT DEFAULT 1;

    -- Validation des données d'entrée
    IF nom_universite IS NULL OR sigle_universite IS NULL OR numero_civique IS NULL OR nom_rue IS NULL OR ville IS NULL OR province IS NULL OR code_postal IS NULL OR designation_espace_stationnement IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tous les champs sont obligatoires.';
    END IF;

    -- Vérification de l'existence de l'université

    SELECT COUNT(*) INTO universite_count FROM universite WHERE nom_universite = nom_universite AND sigle = sigle_universite;
    IF universite_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'L''université existe déjà.';
    END IF;

    -- Ajout de l'université
    INSERT INTO universite (nom_universite, sigle, numero_civique, nom_rue, ville, province, code_postal)
    VALUES (nom_universite, sigle_universite, numero_civique, nom_rue, ville, province, code_postal);

    -- Récupération de l'ID de l'université nouvellement créée
    SET @id_universite := LAST_INSERT_ID();

    -- Ajout de l'espace de stationnement
    INSERT INTO espace_stationnement (designation_espace_stationnement, id_universite)
    VALUES (designation_espace_stationnement, @id_universite);

    -- Récupération de l'ID de l'espace de stationnement nouvellement créé
    SET @id_espace_stationnement := LAST_INSERT_ID();

    -- Ajout des allées

    WHILE i <= 3 DO
        INSERT INTO allee (id_espace_stationnement, designation_allee, sens_circulation, nombre_places_dispo, tarif_horaire)
        VALUES (@id_espace_stationnement,
                CONCAT('Allee ', i),
                CASE i WHEN 1 THEN 'Entrée' WHEN 2 THEN 'Sortie' ELSE 'Bidirectionnel' END,
                10,
                4.5);
        SET i := i + 1;
    END WHILE;
END $

DELIMITER ;





CREATE TABLE IF NOT EXISTS log_aire_stationnement (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    nom_universite VARCHAR(45),
    sigle_universite VARCHAR(10),
    date_heure_tentative DATETIME
);

-- Configuration du déclencheur pour archiver les tentatives de création d'espace de stationnement :

DELIMITER $

CREATE TRIGGER LogCreationAireStationnement
AFTER INSERT ON espace_stationnement
FOR EACH ROW
BEGIN
    DECLARE univ_nom VARCHAR(45);
    DECLARE univ_sigle VARCHAR(10);

    -- Récupération des données de l'université associée à l'espace de stationnement
    SELECT nom_universite, sigle INTO univ_nom, univ_sigle
    FROM universite
    WHERE id_universite = NEW.id_universite;

    -- Insertion des données dans la table de log
    INSERT INTO log_aire_stationnement (nom_universite, sigle_universite, date_heure_tentative)
    VALUES (univ_nom, univ_sigle, NOW());
END $

DELIMITER ;