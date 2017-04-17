#!/usr/bin/env sh

# generate basic config
cat >"${APP_DIR}/pdnsd.conf" <<-EOF
global {
    perm_cache=10240;
    cache_dir="${APP_DIR}";
    run_as="pdnsd";
    server_ip = ${INTERFACE};   # Use eth0 here if you want to allow other
                                # machines on your network to query pdnsd.
    server_port = ${PORT};
    status_ctl = on;
#	paranoid=on;       # This option reduces the chance of cache poisoning
                       # but may make pdnsd less efficient, unfortunately.
    query_method=${QUERY_METHOD};
    # min_ttl=15m;       # Retain cached entries at least 15 minutes.
    min_ttl=1h;
    max_ttl=1d;        # One week.
    timeout=10;        # Global timeout option (10 seconds).
    udpbufsize=1024;   # Upper limit on the size of UDP messages.
    neg_ttl=1h;
    neg_rrs_pol=auth;
    neg_domain_pol=auth;
    par_queries=1;
#	query_port_start=3000;
#	query_port_end=3000;
}

EOF

# add static upstream servers
if [ -n "$SERVERS" ]; then
    for server in "$SERVERS"; do
        echo "server {" >>"$APP_DIR/pdnsd.conf"
        IFS=';' read -ra pairs <<< "$server"
        for pair in "${pairs[@]}"; do
            echo "  ${pair};" >>"$APP_DIR/pdnsd.conf"
        done
        echo "}" >>"${APP_DIR}/pdnsd.conf"
    done
fi

exec /usr/sbin/pdnsd -c "${APP_DIR}/pdnsd.conf"
