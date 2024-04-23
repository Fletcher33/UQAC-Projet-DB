USE projet_final_8TRD151;

-- Appels de procédures pour tester le fonctionnement

-- 2.1 CRÉER UN NOUVEL ÉTUDIANT
CALL CreerEtudiant('Dfgfosrehhffse', 'Jdsddsfdfohn', 'CONE31128105', '15DGGR', 'john.doe@exQDgdadgfmple.com', '0768444449', 1);
CALL CreerEtudiant('Kyllian','HOT','HOTK06120000','DE26D','dhdfjg@gfgf.dsgf','0768444549',1);


-- 2.2 AFFICHER LES INFORMATIONS PERSONNELLES D’UN ÉTUDIANT
CALL AfficherInformationsEtudiant('ETU-123456');

-- 2.3 METTRE À JOUR LES INFORMATIONS PERSONNELLES D’UN ÉTUDIANT
CALL MettreAJourInformationsEtudiant('ETU-123456', 'Doe', 'Jane', 'CONE31128105', 'ABC123', 'jane.doe@example.com', '+123.4567890123', 1);

-- 2.4 SUPPRIMER UN ÉTUDIANT
CALL SupprimerEtudiant('ETU-123456');