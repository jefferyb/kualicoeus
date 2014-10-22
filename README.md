# kualicoeus

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup - The basics of getting started with kualicoeus](#setup)
    * [What kualicoeus affects](#what-kualicoeus-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with kualicoeus](#beginning-with-kualicoeus)
4. [Usage](#usage)
5. [Reference](#reference)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

The kualicoeus module enables you to install Kuali Coeus Bundle with MySQL Server.

## Module Description

The kualicoeus module gives you a way to install Kuali Coeus Bundle with MySQL Server, with very minimum settings in the kc-config.xml file.
For now, I just converted the "install_kuali_coeus_bundle" script, https://github.com/jefferyb/install_kuali_coeus_bundle, to a puppet version 
and will be adding features on it.

For now, it just installs a fresh vanilla version of Kuali Coeus.

## Setup

### What kualicoeus affects

This module will affect:

* Firewall: It will be turned off, for now...
* MySQL: It will add some setting to your my.cnf
* Tomcat: It will install a version 6 of tomcat from source to /opt/apache-tomcat/tomcat (default)
* Java: Make sure that java is installed 

### Setup Requirements

pluginsync needs to be enabled on Ubuntu 12.04 LTS


### Beginning with kualicoeus

The simplest way to get Kuali Coeus up and running with the kualicoeus module is to add:

node default {
  include kualicoeus
}

in your manifests/site.pp file
 

## Usage

COMING SOON

## Reference

COMING SOON

## Limitations

So far, I've tested it on Ubuntu 12.04, 14.04 and a CentOS release 6.5 

## Development

The modules are open projects, and community contributions are essential for keeping them great. So please, if you would like to contribute and make it a whole lot better, please don't hesitate :)

