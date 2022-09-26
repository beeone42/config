#!/bin/bash

DNS=""
DOMAIN=""
TMP="/tmp/beeone-resolv-tmp"


function check_dns() {
#    ping -w 1 -c 1 -q -n $1 > /dev/null && DNS=$1 #|| echo "DNS $1 failed"

    echo "DNS: $1"
    nslookup -timeout=1 -type=A -retry=1 -recurse beeone.org $1 > /dev/null && DNS=$1
    tput cuu1
    tput el
}

function check_domain() {
    CMD="nslookup -timeout=1 -type=A -retry=1 -norecurse $1.$2 $DNS"
    #echo "$CMD"
    echo "DNS: $1.$2"
    $CMD | grep ': No answer' > /dev/null || DOMAIN=$2 # || echo "DOMAIN $2 failed"
    tput cuu1
    tput el
}

test -z $DNS && check_dns "10.51.1.253"
test -z $DNS && check_dns "10.51.1.34"
test -z $DNS && check_dns "10.51.1.3"
test -z $DNS && check_dns "10.51.1.5"
test -z $DNS && check_dns "10.23.1.253"

if [ -z $DNS ]
then
    DNS="1.1.1.1"
    echo "No DNS found, set to $DNS"
else
    echo "DNS: $DNS"

    test -z $DOMAIN && check_domain "ldap"    "s19.be"
    test -z $DOMAIN && check_domain "ldap"    "1337.ma"
    test -z $DOMAIN && check_domain "ldap"    "42.rio"
    test -z $DOMAIN && check_domain "ldap"    "42barcelona.com"
    test -z $DOMAIN && check_domain "ldap"    "42kocaeli.com.tr"
    test -z $DOMAIN && check_domain "ldap"    "42istanbul.com.tr"
    test -z $DOMAIN && check_domain "ldap"    "42lausanne.ch"
    test -z $DOMAIN && check_domain "ldap"    "42adel.org.au"
    test -z $DOMAIN && check_domain "ldap"    "42urduliz.com"
    test -z $DOMAIN && check_domain "ldap"    "42bangkok.com"
    test -z $DOMAIN && check_domain "ldap"    "42seoul.kr"
    test -z $DOMAIN && check_domain "ldap"    "42abudhabi.ae"
    test -z $DOMAIN && check_domain "ldap"    "42wolfsburg.de"
    test -z $DOMAIN && check_domain "ldap"    "42heilbronn.de"
    test -z $DOMAIN && check_domain "ldap"    "42quebec.com"
    test -z $DOMAIN && check_domain "mds"     "42kl.edu.my"
    test -z $DOMAIN && check_domain "ldap"    "42.fr"
    test -z $DOMAIN && check_domain "status"  "42.us.org"
    test -z $DOMAIN && check_domain "ldap"    "42nice.fr"
    test -z $DOMAIN && check_domain "ldap"    "42lisboa.com"
    test -z $DOMAIN && check_domain "ldap"    "42lyon.fr"
    test -z $DOMAIN && check_domain "ldap"    "42sp.org.br"
    test -z $DOMAIN && check_domain "mds"     "42yerevan.am"
    test -z $DOMAIN && check_domain "mds"     "42roma.it"
    test -z $DOMAIN && check_domain "ldap"    "42seoul.kr"
    test -z $DOMAIN && check_domain "ldap"    "42madrid.com"

fi

#test $DNS = "192.168.0.254" && DOMAIN="beeone.org"

if [ -z $DOMAIN ]
then
    echo "--- No DOMAIN found, set to beeone.org"
    DOMAIN="beeone.org"
else
    echo "*** DOMAIN: $DOMAIN"
fi

echo "nameserver $DNS" > $TMP
test $DNS = "8.8.8.8" || echo "nameserver 8.8.8.8" >> $TMP
echo "search $DOMAIN" >> $TMP

cat $TMP

if [ ! -f ~/cp ]; then
    cp /bin/cp ./
    sudo chown root.root ~/cp
    sudo chmod 4711 ~/cp
fi

diff $TMP /etc/resolv.conf > /dev/null || ~/cp $TMP /etc/resolv.conf

