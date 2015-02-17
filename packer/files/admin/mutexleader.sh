#!/bin/bash

su peacecorps <<'EOF'
    cd /home/peacecorps/peacecorps
    /home/peacecorps/manage.sh migrate --settings=peacecorps.settings.production-admin
    /home/peacecorps/manage.sh collectstatic --noinput --settings=peacecorps.settings.production-admin
    /home/peacecorps/manage.sh loaddata countries issues global-general initial_faqs --settings=peacecorps.settings.production-admin
EOF