-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: projet_final
-- ------------------------------------------------------
-- Server version	5.7.11

DROP DATABASE IF EXISTS projet_final_8TRD151;
CREATE DATABASE IF NOT EXISTS projet_final_8TRD151;
USE projet_final_8TRD151;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `agent`
--

DROP TABLE IF EXISTS `agent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agent` (
  `id_agent` int(11) NOT NULL AUTO_INCREMENT,
  `nom_agent` varchar(45) NOT NULL,
  `prenom_agent` varchar(60) NOT NULL,
  PRIMARY KEY (`id_agent`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agent`
--

LOCK TABLES `agent` WRITE;
/*!40000 ALTER TABLE `agent` DISABLE KEYS */;
/*!40000 ALTER TABLE `agent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `allee`
--

DROP TABLE IF EXISTS `allee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `allee` (
  `id_allee` int(11) NOT NULL AUTO_INCREMENT,
  `id_espace_stationnement` int(11) NOT NULL,
  `designation_allee` varchar(45) NOT NULL,
  `sens_circulation` enum('Entrée','Sortie','Bidirectionnel') NOT NULL,
  `nombre_places_dispo` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `tarif_horaire` float NOT NULL DEFAULT '4.5',
  PRIMARY KEY (`id_allee`),
  UNIQUE KEY `nom_allee_espace` (`designation_allee`,`id_espace_stationnement`),
  KEY `allee_ibfk_1` (`id_espace_stationnement`),
  CONSTRAINT `allee_ibfk_1` FOREIGN KEY (`id_espace_stationnement`) REFERENCES `espace_stationnement` (`id_espace_stationnement`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `allee`
--

LOCK TABLES `allee` WRITE;
/*!40000 ALTER TABLE `allee` DISABLE KEYS */;
/*!40000 ALTER TABLE `allee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cours`
--

DROP TABLE IF EXISTS `cours`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cours` (
  `id_cours` int(11) NOT NULL AUTO_INCREMENT,
  `nom_du_cours` varchar(65) NOT NULL,
  `nombre_heures` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`id_cours`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cours`
--

LOCK TABLES `cours` WRITE;
/*!40000 ALTER TABLE `cours` DISABLE KEYS */;
/*!40000 ALTER TABLE `cours` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cours_suivi`
--

DROP TABLE IF EXISTS `cours_suivi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cours_suivi` (
  `id_cours` int(11) NOT NULL,
  `id_etudiant` varchar(10) NOT NULL,
  `session` varchar(50) NOT NULL,
  `local` varchar(45) NOT NULL,
  `heure_debut` time NOT NULL,
  `heure_fin` time NOT NULL,
  PRIMARY KEY (`id_cours`,`id_etudiant`,`session`),
  KEY `cours_suivi_ibfk_2_idx` (`id_etudiant`),
  CONSTRAINT `cours_suivi_ibfk_1` FOREIGN KEY (`id_cours`) REFERENCES `cours` (`id_cours`),
  CONSTRAINT `cours_suivi_ibfk_2` FOREIGN KEY (`id_etudiant`) REFERENCES `etudiant` (`id_etudiant`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cours_suivi`
--

LOCK TABLES `cours_suivi` WRITE;
/*!40000 ALTER TABLE `cours_suivi` DISABLE KEYS */;
/*!40000 ALTER TABLE `cours_suivi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `espace_stationnement`
--

DROP TABLE IF EXISTS `espace_stationnement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `espace_stationnement` (
  `id_espace_stationnement` int(11) NOT NULL AUTO_INCREMENT,
  `designation_espace_stationnement` varchar(45) NOT NULL,
  `id_universite` int(11) NOT NULL,
  PRIMARY KEY (`id_espace_stationnement`),
  UNIQUE KEY `designation_par_uni` (`designation_espace_stationnement`,`id_universite`),
  KEY `espace_stationnement_ibfk_1` (`id_universite`),
  CONSTRAINT `espace_stationnement_ibfk_1` FOREIGN KEY (`id_universite`) REFERENCES `universite` (`id_universite`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `espace_stationnement`
--

LOCK TABLES `espace_stationnement` WRITE;
/*!40000 ALTER TABLE `espace_stationnement` DISABLE KEYS */;
/*!40000 ALTER TABLE `espace_stationnement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `espace_surveille`
--

DROP TABLE IF EXISTS `espace_surveille`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `espace_surveille` (
  `id_agent` int(11) NOT NULL,
  `id_espace_stationnement` int(11) NOT NULL,
  `date_heure_debut_surveillance` datetime NOT NULL,
  `date_heure_fin_surveillance` datetime NOT NULL,
  PRIMARY KEY (`id_agent`,`id_espace_stationnement`,`date_heure_debut_surveillance`),
  KEY `id_espace_stationnement` (`id_espace_stationnement`),
  CONSTRAINT `espace_surveille_ibfk_1` FOREIGN KEY (`id_agent`) REFERENCES `agent` (`id_agent`),
  CONSTRAINT `espace_surveille_ibfk_2` FOREIGN KEY (`id_espace_stationnement`) REFERENCES `espace_stationnement` (`id_espace_stationnement`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `espace_surveille`
--

LOCK TABLES `espace_surveille` WRITE;
/*!40000 ALTER TABLE `espace_surveille` DISABLE KEYS */;
/*!40000 ALTER TABLE `espace_surveille` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `etudiant`
--

DROP TABLE IF EXISTS `etudiant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `etudiant` (
  `id_etudiant` varchar(10) NOT NULL,
  `nom_etudiant` varchar(45) NOT NULL,
  `prenom_etudiant` varchar(60) NOT NULL,
  `code_permanent` varchar(15) NOT NULL COMMENT 'CONE31128105',
  `numero_plaque` varchar(10) NOT NULL,
  `courriel_etudiant` varchar(55) NOT NULL,
  `telephone_etudiant` varchar(10) NOT NULL,
  `supprime` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `id_universite` int(11) NOT NULL,
  PRIMARY KEY (`id_etudiant`),
  UNIQUE KEY `courriel_etudiant_UNIQUE` (`courriel_etudiant`),
  UNIQUE KEY `telephone_etudiant_UNIQUE` (`telephone_etudiant`),
  UNIQUE KEY `code_permanent_UNIQUE` (`code_permanent`),
  KEY `universite_fk_idx` (`id_universite`),
  CONSTRAINT `universite_fk` FOREIGN KEY (`id_universite`) REFERENCES `universite` (`id_universite`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `etudiant`
--

LOCK TABLES `etudiant` WRITE;
/*!40000 ALTER TABLE `etudiant` DISABLE KEYS */;
/*!40000 ALTER TABLE `etudiant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `place`
--

DROP TABLE IF EXISTS `place`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `place` (
  `id_place` int(11) NOT NULL AUTO_INCREMENT,
  `type_de_place` enum('standard','personnes à mobilité réduite','véhicules électriques') NOT NULL,
  `id_allee` int(11) NOT NULL,
  `disponibilite` enum('Oui','Non') NOT NULL,
  PRIMARY KEY (`id_place`),
  KEY `place_ibfk_1` (`id_allee`),
  CONSTRAINT `place_ibfk_1` FOREIGN KEY (`id_allee`) REFERENCES `allee` (`id_allee`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `place`
--

LOCK TABLES `place` WRITE;
/*!40000 ALTER TABLE `place` DISABLE KEYS */;
/*!40000 ALTER TABLE `place` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `place_reservee`
--

DROP TABLE IF EXISTS `place_reservee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `place_reservee` (
  `id_place` int(11) NOT NULL AUTO_INCREMENT,
  `id_etudiant` varchar(10) NOT NULL,
  `date_heure_debut` datetime NOT NULL,
  `date_heure_fin` datetime NOT NULL,
  PRIMARY KEY (`id_place`,`id_etudiant`,`date_heure_debut`),
  KEY `place_reservee_ibfk_2_idx` (`id_etudiant`),
  CONSTRAINT `place_reservee_ibfk_1` FOREIGN KEY (`id_place`) REFERENCES `place` (`id_place`),
  CONSTRAINT `place_reservee_ibfk_2` FOREIGN KEY (`id_etudiant`) REFERENCES `etudiant` (`id_etudiant`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `place_reservee`
--

LOCK TABLES `place_reservee` WRITE;
/*!40000 ALTER TABLE `place_reservee` DISABLE KEYS */;
/*!40000 ALTER TABLE `place_reservee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `universite`
--

DROP TABLE IF EXISTS `universite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `universite` (
  `id_universite` int(11) NOT NULL AUTO_INCREMENT,
  `nom_universite` varchar(45) NOT NULL,
  `sigle` varchar(10) NOT NULL,
  `numero_civique` varchar(5) NOT NULL,
  `nom_rue` varchar(15) NOT NULL,
  `ville` varchar(45) NOT NULL,
  `province` enum('Alberta','Colombie-Britannique','Île-du-Prince-Édouard','Manitoba','Nouveau-Brunswick','Nouvelle-Écosse','Ontario','Québec','Saskatchewan','Terre-Neuve-et-Labrador','Territoires du Nord-Ouest','Nunavut','Yukon') NOT NULL DEFAULT 'Québec',
  `code_postal` varchar(7) NOT NULL,
  PRIMARY KEY (`id_universite`),
  UNIQUE KEY `nom_universite_UNIQUE` (`nom_universite`),
  UNIQUE KEY `sigle_UNIQUE` (`sigle`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `universite`
--

LOCK TABLES `universite` WRITE;
/*!40000 ALTER TABLE `universite` DISABLE KEYS */;
/*!40000 ALTER TABLE `universite` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-06 17:03:30
