USE projet_final_8TRD151;
DROP PROCEDURE IF EXISTS RapportStatistiqueAiresStationnement;
DELIMITER $

CREATE PROCEDURE RapportStatistiqueAiresStationnement()
BEGIN
    -- Déclaration des variables pour stocker les statistiques
    DECLARE name_universite VARCHAR(45);
    DECLARE nb_etudiants INT;
    DECLARE nb_espaces_stationnement INT;
    DECLARE nb_agents_surveillance INT;
    DECLARE nb_allees INT;
    DECLARE nb_places INT;
    DECLARE nb_places_handicapes INT;
    DECLARE nb_places_disponibles INT;
    DECLARE nb_places_reservees INT;
    DECLARE moyenne_reservations_2023 FLOAT;
    DECLARE date_plus_reservation DATETIME;
    DECLARE date_moins_reservation DATETIME;

    -- Déclaration du curseur pour parcourir les universités
    DECLARE cur_universites CURSOR FOR
SELECT nom_universite, COUNT(DISTINCT id_etudiant) AS nb_etudiants
FROM universite u
         LEFT JOIN etudiant e ON u.id_universite = e.id_universite
GROUP BY nom_universite;

-- Ouverture du curseur
OPEN cur_universites;

-- Initialisation des variables de statistiques
SET nb_espaces_stationnement = 0;
    SET nb_agents_surveillance = 0;
    SET nb_allees = 0;
    SET nb_places = 0;
    SET nb_places_handicapes = 0;
    SET nb_places_disponibles = 0;
    SET nb_places_reservees = 0;
    SET moyenne_reservations_2023 = 0;
    SET date_plus_reservation = NULL;
    SET date_moins_reservation = NULL;

    -- Boucle pour parcourir les universités
    universite_loop: LOOP
        FETCH cur_universites INTO name_universite, nb_etudiants;

        -- Quitter la boucle s'il n'y a plus de lignes
        IF (name_universite IS NULL) THEN
            LEAVE universite_loop;
END IF;

        -- Calculer le nombre d'espaces de stationnement pour cette université
SELECT COUNT(*) INTO nb_espaces_stationnement
FROM espace_stationnement
WHERE id_universite = (SELECT id_universite FROM universite WHERE nom_universite = name_universite);

-- Calculer le nombre d'agents de surveillance pour cette université
SELECT COUNT(*) INTO nb_agents_surveillance
FROM espace_surveille es
         INNER JOIN agent a ON es.id_agent = a.id_agent
         INNER JOIN espace_stationnement es2 ON es.id_espace_stationnement = es2.id_espace_stationnement
WHERE es2.id_universite = (SELECT id_universite FROM universite WHERE nom_universite = name_universite);

-- Calculer le nombre d'allées pour cette université
SELECT COUNT(*) INTO nb_allees
FROM allee a
         INNER JOIN espace_stationnement es ON a.id_espace_stationnement = es.id_espace_stationnement
WHERE es.id_universite = (SELECT id_universite FROM universite WHERE nom_universite = name_universite);

-- Calculer le nombre total de places pour cette université
SELECT COUNT(*) INTO nb_places
FROM place p
         INNER JOIN allee a ON p.id_allee = a.id_allee
         INNER JOIN espace_stationnement es ON a.id_espace_stationnement = es.id_espace_stationnement
WHERE es.id_universite = (SELECT id_universite FROM universite WHERE nom_universite = name_universite);

-- Calculer le nombre de places pour handicapés pour cette université
SELECT COUNT(*) INTO nb_places_handicapes
FROM place p
         INNER JOIN allee a ON p.id_allee = a.id_allee
         INNER JOIN espace_stationnement es ON a.id_espace_stationnement = es.id_espace_stationnement
WHERE es.id_universite = (SELECT id_universite FROM universite WHERE nom_universite = name_universite)
  AND p.type_de_place = 'personnes à mobilité réduite';

-- Calculer le nombre de places disponibles pour cette université
SELECT COUNT(*) INTO nb_places_disponibles
FROM place
WHERE disponibilite = 'Oui'
  AND id_allee IN (SELECT id_allee FROM allee WHERE id_espace_stationnement IN
(SELECT id_espace_stationnement FROM espace_stationnement WHERE id_universite =
(SELECT id_universite FROM universite WHERE nom_universite = name_universite)));

-- Calculer le nombre de places réservées pour cette université
SELECT COUNT(*) INTO nb_places_reservees
FROM place_reservee pr
         INNER JOIN place p ON pr.id_place = p.id_place
         INNER JOIN allee a ON p.id_allee = a.id_allee
         INNER JOIN espace_stationnement es ON a.id_espace_stationnement = es.id_espace_stationnement
WHERE es.id_universite = (SELECT id_universite FROM universite WHERE nom_universite = name_universite);

-- Calculer la moyenne de réservation en 2023 pour cette université (exemple de calcul)
SELECT AVG(nb_reservations) INTO moyenne_reservations_2023
FROM (
         SELECT COUNT(*) AS nb_reservations
         FROM place_reservee pr
         WHERE YEAR(pr.date_heure_debut) = 2023
         GROUP BY pr.id_place
     ) AS subquery;

-- Calculer la date ayant eu le plus de réservations pour cette université
SELECT date_heure_debut INTO date_plus_reservation
FROM (
         SELECT pr.date_heure_debut, COUNT(*) AS nb_reservations
         FROM place_reservee pr
                  INNER JOIN place p ON pr.id_place = p.id_place
                  INNER JOIN allee a ON p.id_allee = a.id_allee
                  INNER JOIN espace_stationnement es ON a.id_espace_stationnement = es.id_espace_stationnement
         WHERE es.id_universite = (SELECT id_universite FROM universite WHERE nom_universite = name_universite)
         GROUP BY pr.date_heure_debut
         ORDER BY nb_reservations DESC
             LIMIT 1
     ) AS subquery;

-- Calculer la date ayant eu le moins de réservations pour cette université
SELECT date_heure_debut INTO date_moins_reservation
FROM (
         SELECT pr.date_heure_debut, COUNT(*) AS nb_reservations
         FROM place_reservee pr
                  INNER JOIN place p ON pr.id_place = p.id_place
                  INNER JOIN allee a ON p.id_allee = a.id_allee
                  INNER JOIN espace_stationnement es ON a.id_espace_stationnement = es.id_espace_stationnement
         WHERE es.id_universite = (SELECT id_universite FROM universite WHERE nom_universite = name_universite)
         GROUP BY pr.date_heure_debut
         ORDER BY nb_reservations ASC
             LIMIT 1
     ) AS subquery;

-- Affichage des statistiques pour cette université
SELECT name_universite, nb_etudiants, nb_espaces_stationnement, nb_agents_surveillance, nb_allees, nb_places, nb_places_handicapes,
       nb_places_disponibles, nb_places_reservees, moyenne_reservations_2023, date_plus_reservation, date_moins_reservation;

END LOOP universite_loop;

    -- Fermeture du curseur
CLOSE cur_universites;
END $

DELIMITER ;
