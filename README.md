# Delilah Honeypot (originally by Novetta)
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/verovaleros/honeypot_delilah)
![GitHub last commit (branch)](https://img.shields.io/badge/python-3.8.10-brightgreen)

Delilah is a honeypot designed to attract attackers who are actively exploiting the Elasticsearch Groovy vulnerability (CVE-2015-1427)[^1].

## Introduction

Delilah acts as a vulnerable Elasticsearch instance that detects and identifies attack commands, recon attempts, and download commands (specifically "wget" and "curl"). The original research and honeypot implementation was done by Novetta[^3]. The main features of Delilah are:
- Delilah will attempt to download the file the attacker is attempting to introduce on a victim's system to allow analysts the opportunity to analyze the files at a later date. 
- Email notifications are sent to alert analysts in real-time of incoming attacks.
- Delilah provides a variety of configurable parameters to mimic Elasticsearch instances and prevent an attacker from easily determining that they are interacting with a honeypot. 
- Multiple Delilah nodes can be installed to form a network of sensors.
- The Delilah Monitor is a simple web interface that will query each of the specified Delilah nodes and produce a chronological event view for the entire sensor collection. Delilah Monitor can also be used for a single node if a larger sensor network is not desired.
-  Delilah and Delilah Monitor are Python based, and have been tested on Ubuntu Linux and Windows OS.

Delilah was inspired by Jordan Wright’s Elastichoney [^2].

## Installation

### Dependencies

The following packages are required in order for Delilah and the Delilah Monitor to operate: sqlite3, tornado, requests. Install the required dependencies with:

```bash
  apt install -y sqlite3
  pip install -r requirements.txt
```

### Configuration

The `Delilah.ini` file contains the configuration for the Delilah honeypot. This file is required for the honeypot to run. The configuration file has four sections:

- `[notifications]`: email addresses that will receive the honeypot notifications. For each user that will receive an email notification of a Delilah event there must be an "email:" entry. If left unfilled, Delilah will throw an exception but will still work.
- `[emailacct]`: information of the email account that will send the notifications. If left unfilled, Delilah will throw an exception but will still work.
- `[honeypot]`: configuration of the honeypot. Default values can be used for testing.
- `[data]`: configuration of the honeypot data storage. Default values can be used for testing.

### Run Delilah

For Linux systems, screen is recommended since Delilah does not run as a daemon and will terminate if a terminal is lost. To activate Delilah simply issue the command:

```bash
# run delilah in a screen
screen -d -m -S delilah python3 Delilah.py

# to attach to the running screen
screen -r delilah
```

### Run Delilah using Docker

It is possible to run Delilah using the honeypot image in Dockerhub. 

```bash
# go to the honeypot repository
cd honeypot_delilah/

# we assume the Delilah.ini file was updated

# create an empty esevents.sqlite to map it to the container in order to have persistent storage of the results
touch $(pwd)/esevents.sqlite

# run the docker container in daemon mode
docker container run -d -name honeypotDelilah -v $(pwd)/Delilah.ini:/delilah/Delilah.ini:ro -v $(pwd)/esevents.sqlite:/delilah/esevents.sqlite -p 9200:9200 verovaleros/honeypotDelilah:latest
```

## Delilah Monitor

The Delilah Monitor is a simple web interface that will query each of the specified Delilah nodes and produce a chronological event view for the entire sensor collection. A configuration file is needed for the monitor to work.


Delilah Monitor is configured via the DelilahMonitor.ini file. For each honeypot sensor to monitor, a `sensor:` entry within the [sensors] section must exist. This package provides a template (DelilahMonitor.template.ini) that one can use to construct their own DelilahMonitor.ini configuration file.


To activate the Delilah Monitor, issue the following command:

```bash
# run delilah monitor in a screen
screen -d -m -S monitor python3 DelilahMonitor.py

# to attach to the running screen
screen -r monitor
```

*Note: the Delilah Monitor has no authentication mechanism. Simply navigating to the IP address and port (as specified by the "port:" entry of [webui]) of the Delilah Monitor instance will display the events of all configured sensors. It is recommended that the Delilah Monitor be run locally or be bound to a loopback device, but never exposed directly to the Internet to avoid exposing your sensor network.*

## Exploiting CVE-2015-1427

To test the setup is working you can try the HTTP query specified in [^3], replacing the server address with the IP address of the honeypot, and the command with a command to execute. If the attempt was successful, Delilah Monitor will show the attempt in the web as shown below:

![delilah-monitor-example-1](https://user-images.githubusercontent.com/2458879/168423981-6f4fa44e-1a11-4c73-b8be-43a9abbb4ab0.png)


## License

Delilah and Delilah Monitor are licensed under the Apache v2 license.

## References
[^1]: MITRE CVE - CVE-2015-1427, [https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2015-1427](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2015-1427). Accessed on 05/14/2022.
[^2]: jordan-wright/elastichoney: A Simple Elasticsearch Honeypot, [https://github.com/jordan-wright/elastichoney](https://github.com/jordan-wright/elastichoney). Accessed on 05/14/2022.
[^3]: The Elastic Botnet Report, Novetta, [https://www.novetta.com/wp-content/uploads/2015/06/NTRG_ElasticBotnetReport_06102015.pdf](https://www.novetta.com/wp-content/uploads/2015/06/NTRG_ElasticBotnetReport_06102015.pdf). Accessed on 05/14/2022.
