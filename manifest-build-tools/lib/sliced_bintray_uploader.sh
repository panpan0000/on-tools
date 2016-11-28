#!/bin/bash

#!/bin/bash
set -e
set -x
############################################
# Required ENV Variable
#############################################
#
#RACKHD_VER=0.4.2
#SUBJECT=rackhd-mirror
#REPO=binary
#PACKAGE=RackHD-Vagrant
#UPLOAD_PATH=vagrant_${RACKHD_VER}
#LOCAL_FILE_PATH=~/RackHD/packer/7z/
#TARGE_FILE=~/RackHD/packer/rackhd-ubuntu-16.04.ova
#BINTRAY_USER=p*****0
#BINTRAY_API_KEY=35477********************************4
#SLICE_SIZE=200m  # 200MB for each slice, which is Bintray OSS Plan Max per Upload size
###########################################

sliced_bintray_upload()
{
    # ENV PARAM CHECK: T.B.D #FIXME
    # ...



    if [[ $(which 7z) == "" ]]
    then
        echo "[Error] please install 7z first...Aborting"
        exit 1
    fi

    rm -r ${LOCAL_FILE_PATH}

    ## Split the Target file into small pieces (200MB , meet Bintray OSS Plan's max size limitation)
    7z a -v${SLICE_SIZE} -mx0   ${LOCAL_FILE_PATH}/${PACKAGE}${RACKHD_VER}       ${TARGE_FILE}


    for i in $(ls ${LOCAL_FILE_PATH});  do
       echo $i
       ../pushToBintray.sh  --user $BINTRAY_USER   --api_key $BINTRAY_API_KEY --subject ${SUBJECT}  --repo  $REPO  --package  $PACKAGE --version ${RACKHD_VER}    --file_path $LOCAL_FILE_PATH/${i}  --target_folder   vagrant_${RACKHD_VER}
       if [[ ! $? -eq 0 ]]; then
          echo "[Error] Push To Bintray Failed. Aborting"
           exit 2
       fi
    done
}

#####
sliced_bintray_upload
