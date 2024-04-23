
USE projet_final_8TRD151;

DROP PROCEDURE IF EXISTS CreerEtudiant;
DROP TRIGGER IF EXISTS AfficherInformationsEtudiant;
DROP PROCEDURE IF EXISTS MettreAJourInformationsEtudiant;
DROP TRIGGER IF EXISTS SupprimerEtudiant;




DELIMITER $

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
    -- Vérification de la validité des données
    IF nom_etudiant = '' OR prenom_etudiant = '' OR code_permanent = '' OR numero_plaque = '' OR courriel_etudiant = '' OR telephone_etudiant = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tous les champs sont obligatoires.';
END IF;

    -- Valider le format du courriel et du numéro de téléphone avec des expressions régulières si nécessaire

    -- Générer l'identifiant unique de l'étudiant
    DECLARE nouvel_id_etudiant VARCHAR(10);
    SET nouvel_id_etudiant = GENERER_ID_ETUDIANT();

    -- Insérer l'étudiant dans la base de données
INSERT INTO etudiant (id_etudiant, nom_etudiant, prenom_etudiant, code_permanent, numero_plaque, courriel_etudiant, telephone_etudiant, id_universite)
VALUES (nouvel_id_etudiant, nom_etudiant, prenom_etudiant, code_permanent, numero_plaque, courriel_etudiant, telephone_etudiant, id_universite);
END //

DELIMITER ;
DELIMITER $

CREATE PROCEDURE AfficherInformationsEtudiant(
    IN id_etudiant_param VARCHAR(10)
)
BEGIN
    -- Vérifier si l'étudiant existe
    IF NOT EXISTS (SELECT * FROM etudiant WHERE id_etudiant = id_etudiant_param) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'L''étudiant spécifié n''existe pas.';
END IF;

    -- Récupérer les informations de l'étudiant
SELECT * FROM etudiant WHERE id_etudiant = id_etudiant_param;
END //

DELIMITER ;
DELIMITER $

CREATE PROCEDURE MettreAJourInformationsEtudiant(
    IN id_etudiant_param VARCHAR(10),
    IN nouveau_nom_etudiant VARCHAR(45),
    IN nouveau_prenom_etudiant VARCHAR(60),
    -- Ajoutez d'autres paramètres pour les informations à mettre à jour
)
BEGIN
    -- Vérifier si l'étudiant existe
    IF NOT EXISTS (SELECT * FROM etudiant WHERE id_etudiant = id_etudiant_param) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'L''étudiant spécifié n''existe pas.';
END IF;

    -- Enregistrer l'historique des modifications
    -- Vous devez créer une table historique_etudiant avec les colonnes appropriées

    -- Mettre à jour les informations de l'étudiant
UPDATE etudiant
SET nom_etudiant = nouveau_nom_etudiant,
    prenom_etudiant = nouveau_prenom_etudiant
WHERE id_etudiant = id_etudiant_param;
END //

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
END //

DELIMITER ;
