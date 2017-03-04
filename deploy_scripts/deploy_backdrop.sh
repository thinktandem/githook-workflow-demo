#!/bin/sh

##
# Post code deploy actions
##

# Clear cache.
/usr/local/bin/drush cc all

# Eventually we will want to deploy new config.
#/usr/local/bin/drush bcim

# Run update hooks.
/usr/local/bin/drush updb -y
