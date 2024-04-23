-- Suppression des fonctions, vues et événements existants pour éviter les erreurs de duplicata
DROP FUNCTION IF EXISTS GenererIDEtudiant;
DROP VIEW IF EXISTS InformationsAiresStationnement;
DROP EVENT IF EXISTS MettreAJourPlacesReservees;

-- Définition de la fonction pour générer un identifiant unique pour les étudiants
DELIMITER $
CREATE FUNCTION GenererIDEtudiant() RETURNS VARCHAR(10)
BEGIN
    DECLARE nouvel_id VARCHAR(10);
    DECLARE dernier_numero INT;

    -- Récupérer le dernier numéro d'étudiant
    SELECT MAX(SUBSTRING(id_etudiant, 5)) INTO dernier_numero FROM etudiant;

    -- Vérifier si la table est vide
    IF dernier_numero IS NULL THEN
        SET dernier_numero := 0;
    END IF;

    -- Incrémenter le dernier numéro
    SET dernier_numero := dernier_numero + 1;

    -- Formater le nouvel ID avec le préfixe et le numéro incrémenté
    SET nouvel_id := CONCAT('ETU-', LPAD(dernier_numero, 6, '0'));

    RETURN nouvel_id;
END $
DELIMITER ;

-- Définition de la vue pour retourner des informations sur les aires de stationnement configurées
CREATE VIEW InformationsAiresStationnement AS
SELECT u.nom_universite, es.designation_espace_stationnement, a.designation_allee,
       a.nombre_places_dispo, COUNT(pr.id_place) AS nombre_places_reservees
FROM universite u
JOIN espace_stationnement es ON u.id_universite = es.id_universite
JOIN allee a ON es.id_espace_stationnement = a.id_espace_stationnement
LEFT JOIN place_reservee pr ON a.id_allee = pr.id_place
GROUP BY u.nom_universite, es.designation_espace_stationnement, a.designation_allee, a.nombre_places_dispo;

-- Définition de l'événement pour supprimer les places réservées dépassées
CREATE EVENT MettreAJourPlacesReservees
ON SCHEDULE EVERY 5 MINUTE
DO
BEGIN
    -- Supprimer les réservations dépassées
    DELETE FROM place_reservee
    WHERE date_heure_fin < NOW();
END;