INSERT INTO universite (nom_universite, sigle, numero_civique, nom_rue, ville, province, code_postal)
VALUES
('Université de Montréal', 'UdeM', '2900', 'Montpetit', 'Montréal', 'Québec', 'H3T 1J4'),
('McGill University', 'McGill', '845', 'Sherbrook', 'Montréal', 'Québec', 'H3A 0G4');
INSERT INTO espace_stationnement (designation_espace_stationnement, id_universite)
VALUES
('Parking Central UdeM', 1),
('Parking Principal McGill', 2);
INSERT INTO allee (id_espace_stationnement, designation_allee, sens_circulation, nombre_places_dispo, tarif_horaire)
VALUES
(1, 'Allée Nord UdeM', 'Bidirectionnel', 20, 2.5),
(1, 'Allée Sud UdeM', 'Entrée', 15, 2.0),
(2, 'Allée Est McGill', 'Sortie', 25, 3.0),
(2, 'Allée Ouest McGill', 'Bidirectionnel', 30, 3.5);
-- For simplicity, let's add 5 places per alley, with some availability
INSERT INTO place (type_de_place, id_allee, disponibilite)
VALUES
('standard', 1, 'Oui'), ('standard', 1, 'Non'), ('standard', 1, 'Oui'), ('standard', 1, 'Non'), ('standard', 1, 'Oui'),
('standard', 2, 'Oui'), ('standard', 2, 'Oui'), ('standard', 2, 'Non'), ('standard', 2, 'Oui'), ('standard', 2, 'Non'),
('standard', 3, 'Non'), ('standard', 3, 'Non'), ('standard', 3, 'Oui'), ('standard', 3, 'Non'), ('standard', 3, 'Oui'),
('standard', 4, 'Oui'), ('standard', 4, 'Oui'), ('standard', 4, 'Non'), ('standard', 4, 'Non'), ('standard', 4, 'Oui');
INSERT INTO etudiant (id_etudiant, nom_etudiant, prenom_etudiant, code_permanent, numero_plaque, courriel_etudiant, telephone_etudiant, id_universite)
VALUES
('E1001', 'Moreau', 'Luc', 'MORL10019803', 'AB123CD', 'luc.moreau@example.com', '5141234567', 1),
('E1002', 'Tremblay', 'Élise', 'TREM20039804', 'CD456EF', 'elise.tremblay@example.com', '5147654321', 2);
INSERT INTO cours_suivi (id_cours, id_etudiant, session, local, heure_debut, heure_fin)
VALUES
(1, 'E1001', 'Automne 2024', 'B101', '2024-09-01 08:00:00', '2024-09-01 10:00:00'),
(2, 'E1002', 'Automne 2024', 'C201', '2024-09-01 11:00:00', '2024-09-01 13:00:00');
