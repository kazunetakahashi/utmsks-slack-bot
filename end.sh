kill -KILL `ps awux | grep -v grep | grep 'slappy start' | awk '{print $2}'`
