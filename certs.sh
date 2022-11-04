#!/usr/bin/env bash


DOMAINS="ca.local proxy.local"
NOT_AFTER=2h
CA_URL=https://ca.local:4443
MOUNT=$pwd
PUID=1000
PGID=1000
IMAGE=duhruh/step-cli
ROOT_CERT=root_ca.crt


echo "generating things"


generate_certs() {
        docker run -it --rm \
                --network host \
                -e "STEPDEBUG=1" \
                -v ${MOUNT}:/home/step \
                -v certificates:/root-certs \
                --user ${PUID}:${PGID} \
                ${IMAGE} ca certificate ${1} ${1}.crt ${1}.key  \
                --ca-url=${CA_URL} \
                --root=/root-certs/certs/root_ca.crt \
                -kty=RSA \
                -not-after=${NOT_AFTER} \
                -provisioner-password-file=/root-certs/secrets/password
        mkdir -p certs/${1}
        mv ${1}.* certs/${1}/
        cp ${ROOT_CERT} certs/${1}/

}

fingerprint() {
        docker run -it --rm \
                -v ${MOUNT}:/home/step \
                -v certificates:/root-certs \
                --user ${PUID}:${PGID} \
                ${IMAGE} certificate fingerprint /root-certs/certs/root_ca.crt

}

download_root_cert() {
        docker run -it --rm \
                --network host \
                -v ${MOUNT}:/home/step \
                --user ${PUID}:${PGID} \
                ${IMAGE} ca root ${ROOT_CERT} \
                --ca-url=${CA_URL} \
                --fingerprint=${1}
}


FINGERPRINT=$(fingerprint | tr -d '\n' | tr -d '\r')

download_root_cert ${FINGERPRINT}

for val in $DOMAINS; do
        echo "generating certs for ${val}"
        generate_certs $val
done

rm ${ROOT_CERT}