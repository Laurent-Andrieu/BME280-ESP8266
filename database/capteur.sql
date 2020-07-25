-- phpMyAdmin SQL Dump
-- version 4.6.6deb5
-- https://www.phpmyadmin.net/
--
-- Client :  localhost:3306
-- Généré le :  Sam 25 Juillet 2020 à 17:13
-- Version du serveur :  10.3.22-MariaDB-0+deb10u1
-- Version de PHP :  7.3.19-1~deb10u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `capteur`
--

-- --------------------------------------------------------

--
-- Structure de la table `donnees`
--

CREATE TABLE `donnees` (
  `id_data` int(11) NOT NULL COMMENT '[int(11)]',
  `id_capteur` int(11) NOT NULL COMMENT '[int(11)]',
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '[Timestamp]',
  `rssi` tinyint(4) NOT NULL COMMENT '[Tinyint]',
  `temperature` float NOT NULL COMMENT '[float(3)]',
  `humidite` float NOT NULL COMMENT '[float(3)]',
  `pression` float NOT NULL COMMENT '[float(4)]'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `liste`
--

CREATE TABLE `liste` (
  `id_capteur` int(11) NOT NULL COMMENT '[int(11)]',
  `nom` varchar(8) NOT NULL COMMENT '[varchar(8)]',
  `enregistrement` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '[Timestamp]',
  `last_seen` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '[Timestamp]',
  `counter` int(11) NOT NULL COMMENT '[int(11)]'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Contenu de la table `liste`
--

INSERT INTO `liste` (`id_capteur`, `nom`, `enregistrement`, `last_seen`, `counter`) VALUES
(0, 'ac863200', '2020-07-23 18:22:29', '2020-07-25 15:13:01', 0);

-- --------------------------------------------------------

--
-- Structure de la table `params`
--

CREATE TABLE `params` (
  `id_params` int(11) NOT NULL COMMENT '[int(11)]',
  `id_capteur` int(11) NOT NULL COMMENT '[int(11)]',
  `py_version` varchar(16) NOT NULL COMMENT '[varchar(16)]',
  `firmware` varchar(16) NOT NULL COMMENT '[varchar(16)]',
  `firmware_version` varchar(16) NOT NULL COMMENT '[varchar(16)]',
  `memoire` int(4) NOT NULL COMMENT '[int(4)]',
  `rssi` tinyint(4) NOT NULL COMMENT '[tinyint]',
  `ip_add` varchar(12) NOT NULL COMMENT '[varchar(12)]',
  `mac_add` varchar(17) NOT NULL COMMENT '[varchar(17)]',
  `gw_add` varchar(16) NOT NULL COMMENT '[varchar(16)]',
  `dns_add` varchar(16) NOT NULL COMMENT '[varchar(16)]',
  `net_mask` varchar(16) NOT NULL COMMENT '[varchar(16)]',
  `date_connection` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '[Timestamp]'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;

--
-- Index pour les tables exportées
--

--
-- Index pour la table `donnees`
--
ALTER TABLE `donnees`
  ADD PRIMARY KEY (`id_data`),
  ADD KEY `Index` (`id_capteur`);

--
-- Index pour la table `liste`
--
ALTER TABLE `liste`
  ADD PRIMARY KEY (`id_capteur`);

--
-- Index pour la table `params`
--
ALTER TABLE `params`
  ADD PRIMARY KEY (`id_params`),
  ADD KEY `id_capteur` (`id_capteur`);

--
-- AUTO_INCREMENT pour les tables exportées
--

--
-- AUTO_INCREMENT pour la table `donnees`
--
ALTER TABLE `donnees`
  MODIFY `id_data` int(11) NOT NULL AUTO_INCREMENT COMMENT '[int(11)]';
--
-- AUTO_INCREMENT pour la table `liste`
--
ALTER TABLE `liste`
  MODIFY `id_capteur` int(11) NOT NULL AUTO_INCREMENT COMMENT '[int(11)]', AUTO_INCREMENT=15;
--
-- AUTO_INCREMENT pour la table `params`
--
ALTER TABLE `params`
  MODIFY `id_params` int(11) NOT NULL AUTO_INCREMENT COMMENT '[int(11)]';
--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `donnees`
--
ALTER TABLE `donnees`
  ADD CONSTRAINT `donnees_ibfk_1` FOREIGN KEY (`id_capteur`) REFERENCES `liste` (`id_capteur`);

--
-- Contraintes pour la table `params`
--
ALTER TABLE `params`
  ADD CONSTRAINT `params_ibfk_1` FOREIGN KEY (`id_capteur`) REFERENCES `liste` (`id_capteur`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
