#!/bin/bash
rsync ./ steemdb:/var/www/com_steemdb_golos/ --rsh ssh --recursive --perms --delete --verbose --exclude=.git* --exclude=app/configs/*.php --exclude=cache --exclude=vendor/ezyang/htmlpurifier/library/HTMLPurifier/DefinitionCache/Serializer/ --exclude=app/storage/views/*.php --checksum -a
