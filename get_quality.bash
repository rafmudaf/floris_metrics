#!/usr/bin/bash

set -e

githashes=(
    # "df25a9cfacd3d652361d2bd37f568af00acb2631"   # These two commits use a different init API for Floris()
    # "b797390a43298a815f3ff57955cfdc71ecf3e866"   # These two commits use a different init API for Floris()
    "01a02d5f91b2f4a863eebe88a618974b0749d1c4"
    "dd847210082035d43b0273ae63a76a53cb8d2e12"
    "33779269e98cc882a5f066c462d8ec1eadf37a1a"
    "12890e029a7155b074b9b325d320d1798338e287"
    "66dafc08bd620d96deda7d526b0e4bfc3b086650"
    "a325819b3b03b84bd76ad455e3f9b4600744ba14"
    "8a2c1a610295c007f0222ce737723c341189811d"
    "c6bc79b0cfbc8ce5d6da0d33b68028157d2e93c0"
    "03e1f461c152e4f221fe92c834f2787680cf5772"
    "9e96d6c412b64fe76a57e7de8af3b00c21d18348"
    "2a98428f9c6fb9bb4302ae09809441bf3e7162b0"
    "9b4e85cf1b41ba7001aaba1a830b93e176f3dd43"   # v3.0
    "d18f4d263ecabf502242592f9d60815a07c7b89c"   # v3.0.1
    "a23241bb9e45078e36a4662d48c9d3fe0c3316e4"   # v3.1
    "c2006b0011a5df036c306c15e75763ec492dafda"   # v3.1.1
    "0c2adf3e702b6427da946a6ba9dbedbea22738be"   # v3.2
    "39c466000b1874e06a6f58da9c30bb877fc8d4d2"   # v3.2.1
    "8436fd78b002e5792f5d0dd1409332d171036d49"   # v3.2.2
    "16628a0ba45a675df762245694e0a7666a3478f8"   # v3.3
)

# base_dir=`pwd`
base_dir="/home/rafael/Development/"

# conda activate floris

for hash in "${githashes[@]}"; do
    cd $base_dir/floris
    git checkout $hash 1> /dev/null 2> /dev/null   # redirect stdout and stderr to dev null - stderr prints things that arent errors
    pip install -e . 1> /dev/null   # redirect stdout to dev null
    git rev-parse --short HEAD
    cd $base_dir
    python $base_dir/floris_quality_metrics/quality_metrics.py
done
