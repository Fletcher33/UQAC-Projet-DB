USE projet_final_8TRD151;
DROP TABLE IF EXISTS log_aire_stationnement;
CREATE TABLE log_aire_stationnement (
                                        id_log INT AUTO_INCREMENT PRIMARY KEY,
                                        nom_universite VARCHAR(255),
                                        sigle_universite VARCHAR(10),
                                        date_heure_tentative DATETIME
);

DROP PROCEDURE IF EXISTS CreerAireStationnement;

CREATE PROCEDURE CreerAireStationnement(
    IN nom_universite VARCHAR(255),
    IN sigle_universite VARCHAR(10),
    IN numero_civique_universite INT,
    IN rue_universite VARCHAR(255),
    IN ville_universite VARCHAR(255),
    IN province_universite ENUM('Alberta','Colombie-Britannique','Île-du-Prince-Édouard','Manitoba','Nouveau-Brunswick','Nouvelle-Écosse','Ontario','Québec','Saskatchewan','Terre-Neuve-et-Labrador','Territoires du Nord-Ouest','Nunavut','Yukon'),
    IN code_postal_universite VARCHAR(7)
)
BEGIN
    DECLARE nouvel_id_universite INT;
    DECLARE nouvel_id_espace_stationnement INT;
    DECLARE nouvel_id_allee INT;
    DECLARE i INT DEFAULT 1;
    DECLARE j INT DEFAULT 1;
    DECLARE sens_circulation ENUM('Entrée', 'Sortie', 'Bidirectionnel');

    -- Vérification de la validité des données
    IF nom_universite = '' OR sigle_universite = '' OR rue_universite = '' OR ville_universite = '' OR code_postal_universite = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tous les champs sont obligatoires.';
        -- Validation du nom de l'université
    ELSEIF NOT nom_universite REGEXP '^[a-zA-ZÀ-ÿ\\-\\\'\\s]+$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nom d''université invalide. Il doit être composé uniquement de lettres.';
        -- Validation du sigle de l'université
    ELSEIF NOT BINARY sigle_universite REGEXP '^[A-Z]+$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sigle d''université invalide. Il doit être composé uniquement de majuscules.';
        -- Validation du numéro civique
    ELSEIF numero_civique_universite <= 0 THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Numéro civique invalide.';
        -- Validation du code postal
    ELSEIF NOT code_postal_universite REGEXP '^[A-Za-z][0-9][A-Za-z] [0-9][A-Za-z][0-9]$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Code postal invalide.';
    ELSE
        -- Vérifie si l'université existe déjà
        SELECT id_universite INTO nouvel_id_universite
        FROM universite u
        WHERE u.nom_universite = nom_universite
          AND u.sigle = sigle_universite;

        -- Si l'université n'existe pas, alors procéder à la création
        IF nouvel_id_universite IS NULL THEN
            -- Crée une nouvelle université
            INSERT INTO universite (nom_universite, sigle, numero_civique, nom_rue, ville, province, code_postal)
            VALUES (nom_universite, sigle_universite, numero_civique_universite, rue_universite, ville_universite, province_universite, code_postal_universite);

            SET nouvel_id_universite = LAST_INSERT_ID();

            -- Crée un nouvel espace de stationnement attaché à l'université nouvellement créée
            INSERT INTO espace_stationnement (id_universite, designation_espace_stationnement)
            VALUES (nouvel_id_universite, CONCAT(sigle_universite, ' parking'));


            SET nouvel_id_espace_stationnement = LAST_INSERT_ID();

            -- Crée trois (3) allées attachées au nouvel espace de stationnement
            WHILE i <= 3 DO
                    IF i = 1 THEN
                        SET sens_circulation = 'Entrée';
                    ELSEIF i = 2 THEN
                        SET sens_circulation = 'Sortie';
                    ELSE
                        SET sens_circulation = 'Bidirectionnel';
                    END IF;

                    INSERT INTO allee (sens_circulation, nombre_places_dispo, tarif_horaire, id_espace_stationnement, designation_allee)
                    VALUES (sens_circulation, 10, 4.5, nouvel_id_espace_stationnement, CONCAT('allée ', i));

                    SET nouvel_id_allee = LAST_INSERT_ID();

                    -- Crée dix (10) places dans chaque allée nouvellement créée, dont deux sont réservées aux personnes à mobilité réduite
                    SET j = 1;
                    WHILE j <= 10 DO
                            INSERT INTO place (disponibilite, id_allee, type_de_place)
                            VALUES ('Oui', nouvel_id_allee, IF(j <= 2, 'personnes à mobilité réduite', 'standard'));
                            SET j = j + 1;
                        END WHILE;

                    SET i = i + 1;
                END WHILE;
        ELSE
            -- Si l'université existe déjà, signaler une erreur
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'L''université existe déjà.';
        END IF;
    END IF;
END;

DROP TRIGGER IF EXISTS log_tentative_creation;

CREATE TRIGGER log_tentative_creation
    AFTER INSERT ON espace_stationnement
    FOR EACH ROW
BEGIN
    DECLARE name_universite VARCHAR(255);
    DECLARE sigle_universite VARCHAR(10);

    -- Récupération du nom et du sigle de l'université
    SELECT nom_universite, sigle INTO name_universite, sigle_universite
    FROM universite
    WHERE id_universite = NEW.id_universite;

    -- Insertion des informations dans la table log_aire_stationnement
    INSERT INTO log_aire_stationnement (nom_universite, sigle_universite, date_heure_tentative)
    VALUES (name_universite, sigle_universite, NOW());
END;

