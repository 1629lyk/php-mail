#!/bin/bash

# Start Postfix
service postfix start

# Start Apache
apache2ctl -D FOREGROUND

