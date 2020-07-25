# [BME280-ESP8266](https://github.com/Laurent-Andrieu/BME280-ESP8266#bme280-esp8266)
Administration web de données mesurées par le BME280 connecté à un ESP8266 sur MicroPython sur Rapsberry pi.
![Dashboard](/images/SC.png)
![Historique](/images/SC2.png)

---

## Logiciels & Dépendances
Le projet est basé sur un Rapsberri pi 4 avec Php, MariaDB, PhpmyAdmin, apache2...
Pour faire fonctionner le système de manière locale il vous faudra simplement:
### Matériel:
* Wi-fi AcessPoint
* ESP8266
* BME280
* Serveur ou Raspberry Pi
### Logiciel:
* ![Thony (IDE)](https://thonny.org/) / [MobaXterm](https://mobaxterm.mobatek.net/download.html)_(optionel)_
* ![Python](https://www.python.org/)
  * ![pip](https://pypi.org/project/pip/)
  * ![mpy-cross](https://pypi.org/project/mpy-cross/): `pip install mpy-cross`
  * ![esptools](https://github.com/espressif/esptool/)
* ![Node-red](https://nodered.org/docs/getting-started/local)
* ![LAMP server](https://pimylifeup.com/raspberry-pi-phpmyadmin/)
* ![Git](https://git-scm.com/)
### Code et packages:
Une fois le serveur mis en place, téléchargez le code source en téléchargeant [ce repository](https://github.com/Laurent-Andrieu/BME280-ESP8266) ainsi que le [package node-red](https://github.com/Laurent-Andrieu/BME280-ESP8266/packages/329039).
Téléchargez le [firmware micropython](https://docs.micropython.org/en/latest/esp8266/tutorial/intro.html#getting-the-firmware).
### Cloner le repository:
Après l'installation de Git: `git clone https://github.com/Laurent-Andrieu/BME280-ESP8266/` pour cloner le repo.
Vous pouvez modifier le code comme bon vous semble.

---

## Modification du code:
Vous devez impérativement modifier les fichiers ![boot.py](https://github.com/Laurent-Andrieu/BME280-ESP8266/blob/master/boot.py):
* SSID:   ssid Wi-Fi
* PASS:   clé wpa2
* mqtt_broker:    adresse ipv4
Ainsi que le fichier ![main.py](https://github.com/Laurent-Andrieu/BME280-ESP8266/blob/master/main.py)
* mqtt_broker:    adresse_ipv4
* _éventuellement les topics dans lesquels vous souhaitez écrite ansi que les données à envoyer_

## Compilation du code:
La compilation permet d'économiser la mémoire RAM, le code sera alors retenu dans la mémoire flash allant jusqu'a 1Mb selon les modèles.

Une fois terminé, il faut le compiler à l'aide de **mpy-cross**:`python -m mpy_cross "/Laurent-Andrieu/BME280-ESP8266/BME280.py"`.

Faites ça pour tous les fichiers excepté `boot.py`.

## Implémentation du code:
À l'aide des IDE comme Thony ou de quelconque logiciel de communication UART, flashez le firmware précedement téléchargé: ![Deploying the firmware](https://docs.micropython.org/en/latest/esp8266/tutorial/intro.html#deploying-the-firmware).

Une fois connecté en UART au REPL du module ESP8266, faites: `import webrepl_setup`. Suivez les instructions du `help()` afin de mettre un mot de passe WebREPL et d'établir la première connexion Wi-fi.
Puis démarrez le ![WebREPL](http://micropython.org/webrepl/#192.168.1.99:8266/), changez l'adresse avec celle du module. À présent vous pouvez vous y connecter et lui envoyer les fichiers _boot.py_, _main.mpy_, _BME8200.mpy_, _umqttsimple.mpy_.

## Raccordement du BME280:
Le BME280 à la particularité de pouvoir communiquer en SPI ou en I²C. La communication se fera en I²C. Pour celà, il faut brancher les Pins de manière suivante:
* Pin D0 -> RST : permet le réveil du mode deep-sleep (D0 = ALARM0).
* Pin D1 -> SCL : Signal d'horloge.
* Pin D2 -> SDA : Bus de données.
* 3.3V -> VCC,CSB : Alimentation et Mode I²C.
* GND -> GND, SDO: Alimentation et 8ème bit d'adresse (0x76).

---

# Fonctionnement du programme:
### boot.py
Le programme étant géré par le firmware µPython, il va chercher à lire premièrement le fichier nommé explictement `boot.py`.
Le module boot connecte l'ESP8266 en Wi-Fi puis au broker MQTT du réseau local en non crypté sans identifiants. Il envoie les informations du module(mémoire, version, nom, id, configuration IP..).
### main.py
Le module est importé par le module boot.py et appelé à la fi nde son execution. Les variables et modules importés depuis le fichier boot.py sont éffacés à la fin de son execution. On rappelle alors les modules nécessaires.

Il permet der se connecter en Wi-Fi et au broker MQTT puis d'y envoyer les données sur la température, la pression atmosphérique et l'humidité demandés au BME280. Il passe alors en mode _deep-sleep_ pendant 5 minutes et reprends son cycle en redémarrant.

