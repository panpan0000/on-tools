#!/bin/bash

#!/bin/bash
set -e
set -x
###########################################
# Required ENV Variable
#############################################
#SUBJECT=rackhd-mirror
#REPO=binary
#PACKAGE=RackHD-Vagrant
#RACKHD_VER=0.4.2
#UPLOAD_PATH=vagrant_${RACKHD_VER}
#BINTRAY_USER=p*****0
#BINTRAY_API_KEY=35477********************************4
###########################################

sliced_bintray_download()
{
    # ENV PARAM CHECK: T.B.D #FIXME
    # ...



    if [[ $(which 7z) == "" ]]
    then
        echo "[Error] please install 7z first...Aborting"
        exit 1
    fi


    # Download the splited files from bintray

    # Parse the Bintray Directory page, extract the sub-files, and append to the URL before wget.

    DOWNLOAD_URL_PREFIX=https://dl.bintray.com/$SUBJECT/$REPO/$UPLOAD_PATH
    TMP_FILE=flist.txt

    wget  ${DOWNLOAD_URL_PREFIX} -O ${TMP_FILE}
    # Note , Bintray added an colon ":" before file name in API endpoints. it prevents direct "wget" to download.
    # we have to escape them first.
    # so ```grep``` will search for href=":abc.7z.00x" string, then ```sed``` to replace the colon and href=" string.
    FLIST=$(cat ${TMP_FILE} |grep -o href=\"\:[A-Za-z0-9._\-]\* |sed 's/href=\"\://')

    LOCAL_DOWNLOAD_FOLDER=/tmp/my_tmp

    mkdir -p $LOCAL_DOWNLOAD_FOLDER
    rm $LOCAL_DOWNLOAD_FOLDER/* -f

    echo $FLIST
    for f in ${FLIST[@]};
    do
        # Download files
         wget ${DOWNLOAD_URL_PREFIX}/${f} -P $LOCAL_DOWNLOAD_FOLDER
    done

    # DeCompress the zip files
    7z e  ${LOCAL_DOWNLOAD_FOLDER}/${FLIST[1]}
}
