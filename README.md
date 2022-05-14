# Delilah Honeypot (originally by Novetta)

Delilah is a honeypot designed to attract attackers who are actively exploiting the Elasticsearch Groovy vulnerability (CVE-2015-1427)[^1].

## Introduction

Delilah acts as a vulnerable Elasticsearch instance that detects and identifies attack commands, recon attempts, and download commands (specifically "wget" and "curl"). The main features of Delilah are:
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

- [notifications]: email addresses that will receive the honeypot notifications. Required. For each user that will receive an email notification of a Delilah event there must be an "email:" entry.
- [emailacct]: information of the email account that will send the notifications. Required.
- [honeypot]: configuration of the honeypot. Default values can be used for testing.
- [data]: configuration of the honeypot data storage. Default values can be used for testing.

### Run Delilah

For Linux systems, screen is recommended since Delilah does not run as a daemon and will terminate if a terminal is lost. To activate Delilah simply issue the command:

```bash
screen -d -m -S delilah python3 Delilah.py

# to attach to the running screen
screen -r delilah
```

### Delilah Monitor

The Delilah Monitor is a simple web interface that will query each of the specified Delilah nodes and produce a chronological event view for the entire sensor collection. A configuration file is needed for the monitor to work.


Delilah Monitor is configured via the DelilahMonitor.ini file. For each honeypot sensor to monitor, a `sensor:` entry within the [sensors] section must exist. This package provides a template (DelilahMonitor.template.ini) that one can use to construct their own DelilahMonitor.ini configuration file.


To activate the Delilah Monitor, issue the following command:

```
python DelilahMonitor.py
```

Note that Delilah Monitor has no authentication mechanism. Simply navigating to the IP address and port (as specified by the "port:" entry of [webui]) of the Delilah Monitor instance will display the events of all configured sensors. It is recommended that the Delilah Monitor be run locally or be bound to a loopback device, but never exposed directly to the Internet to avoid exposing your sensor network.

## License

Delilah and Delilah Monitor are licensed under the Apache v2 license.

## References
[^1]: MITRE CVE - CVE-2015-1427, [https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2015-1427](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2015-1427). Accessed on 05/14/2022.
[^2]: jordan-wright/elastichoney: A Simple Elasticsearch Honeypot, [https://github.com/jordan-wright/elastichoney](https://github.com/jordan-wright/elastichoney). Accessed on 05/14/2022.
