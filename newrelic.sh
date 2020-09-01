#! /bin/bash

if [ -z "$NEWRELIC_KEY" ]; then
    echo >&2 'error: missing NEWRELIC_KEY environment variable'
    return
fi
if [ -z "$GROUP_NAME" ]; then
    echo >&2 'error: missing GROUP_NAME environment variable'
    return
fi

sed -e "s^@LICENCE_KEY@^${NEWRELIC_KEY}^" \
    -e "s^@GROUP_NAME@^${GROUP_NAME}^" \
    -e "s^@APP_NAME@^${APP_NAME}^" /var/lib/newrelic.yml.template > /var/lib/newrelic.yml

cp /var/lib/newrelic.yml /usr/app/newrelic/

