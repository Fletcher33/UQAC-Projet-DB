USE projet_final_8TRD151;

DROP PROCEDURE IF EXISTS ReserverPlaceStationnement;
DROP TRIGGER IF EXISTS ActualiserPlacesDisponibles;
DROP TABLE  IF EXISTS violation_stationnement;

-- Création de la table violation_stationnement
CREATE TABLE IF NOT EXISTS violation_stationnement (
    id_violation INT AUTO_INCREMENT PRIMARY KEY,
    code_permanent VARCHAR(15),
    nom_etudiant VARCHAR(45),
    prenom_etudiant VARCHAR(60),
    numero_plaque VARCHAR(10),
    date_heure_tentative DATETIME
);

DELIMITER $

CREATE PROCEDURE ReserverPlaceStationnement(
    IN id_etudiant_param VARCHAR(10),
    IN date_arrivee DATETIME,
    IN date_depart DATETIME
)

BEGIN
    DECLARE id_place_dispo INT;
    -- Vérification des données fournies en paramètres
    IF id_etudiant_param = '' OR date_arrivee IS NULL OR date_depart IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tous les champs sont obligatoires.';
    END IF;

    -- Vérifier si l'étudiant est inscrit à un cours pendant la période de stationnement
    IF NOT EXISTS (
        SELECT *
        FROM etudiant et
        INNER JOIN cours_suivi cs ON et.id_etudiant = cs.id_etudiant
        WHERE cs.id_etudiant = id_etudiant_param
        AND (date_arrivee BETWEEN cs.heure_debut AND cs.heure_fin OR date_depart BETWEEN cs.heure_debut AND cs.heure_fin)
    ) THEN
        -- Enregistrer la violation de stationnement dans la table d'audit
        INSERT INTO violation_stationnement (code_permanent, nom_etudiant, prenom_etudiant, numero_plaque, date_heure_tentative)
        SELECT code_permanent, nom_etudiant, prenom_etudiant, numero_plaque, NOW()
        FROM etudiant
        WHERE id_etudiant = id_etudiant_param;


    END IF;

    -- Trouver une place disponible dans l'université de l'étudiant


    SELECT p.id_place INTO id_place_dispo
    FROM place p
             INNER JOIN allee a ON p.id_allee = a.id_allee
             INNER JOIN espace_stationnement es ON a.id_espace_stationnement = es.id_espace_stationnement
    WHERE es.id_universite = (SELECT id_universite FROM etudiant WHERE id_etudiant = id_etudiant_param)
      AND p.disponibilite = 'Oui'
    LIMIT 1;

    IF id_place_dispo IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Aucune place disponible.';
    ELSE
        -- Mettre à jour la disponibilité de la place
        UPDATE place SET disponibilite = 'Non' WHERE id_place = id_place_dispo;

        -- Afficher les détails de la réservation
        SELECT es.designation_espace_stationnement, a.designation_allee, a.sens_circulation, p.id_place, p.type_de_place, a.tarif_horaire,
               date_arrivee AS date_heure_arrivee, date_depart AS date_heure_depart
        FROM espace_stationnement es
                 INNER JOIN allee a ON es.id_espace_stationnement = a.id_espace_stationnement
                 INNER JOIN place p ON a.id_allee = p.id_allee
        WHERE p.id_place = id_place_dispo;
    END IF;

    INSERT INTO place_reservee (id_place, id_etudiant, date_heure_debut, date_heure_fin)
    VALUES
    (id_place_dispo, id_etudiant_param, date_arrivee, date_depart);

END $

DELIMITER ;

DELIMITER $

CREATE TRIGGER ActualiserPlacesDisponibles
    AFTER INSERT ON place_reservee
    FOR EACH ROW
BEGIN
    UPDATE allee a
        INNER JOIN place p ON a.id_allee = p.id_allee
        SET a.nombre_places_dispo = a.nombre_places_dispo - 1
    WHERE p.id_place = NEW.id_place;
END $

DELIMITER ;