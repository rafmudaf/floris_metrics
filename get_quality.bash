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
    "07a45b66c5facfea06c40bd82e34040c97560640"
    "1d84538c334a502c6ad7df48b8cc2309d6a6436d"
    "4d528a3d6456621a382d409b5145a877b5414b88"
    "8c637b36b66069b216cb94ae87d4c0a91e9b211e"
    "4d23fa6dd78d0497deb4fd62783f0b3ee4204579"
    "015f6874c320efee2c0d1ae76eea4a5b043d69d6"
    "26f06d449da208ce64724b1463b07ad20746cbdc"
    "6b9d6bb8bec6e3ea548f5858e2a8ea5986264fc8"
    "b796bd0fd92ba6b91d590f6cb60bb7ab3bca9932"
    "780aef7c7b4b9cafea3e323d536a34a4af5818b4"
    "9f93ad9bf85e4a0e6baf5b62ea4b3ef143729861"
    "16628a0ba45a675df762245694e0a7666a3478f8"   # v3.3
    "01684c8559604344bd09791268131819a09770a8"
    "e9231fb893c765b723fa4c1e087a58761b6aa471"
    "219889e243ffc69c71b6f7747f5af751d5694de1"
    "6124d2a82a7a823722210bc2e8516d355ba19eb3"
    "f6e4287f712cc866893e71b1ea7a7546e4567bf9"
    "f2797fef396f2f19b02abb1f9555b678dac614f1"
    "b4e538f530048fec58eaca5170be82c67dbdcceb"
    "68820b715ed6b2c981aa11d29c0102e879280d79"
    "03deffeda91fa8d8ab188d57b9fa302a7be008e0"
    "0d2bfecc271d561f67050659684b4797af8ee740"
    "1d03a465593f56c99a64a576d185d4ed17b659f2"
    "78a953b7ef9a36b62e5b446c80ed68abfddbfb74"
    "6c4f70ffbf3d4d2922d41d0032ae1b93d8a23c99"
    "ab03282623d0262b20b8c132efcdcace2dace766"
    "d2f7a45af27a6b40027d6f6a0f4f0be0c6dee5d9"
    "98b23f3d517481b127f190f5f8b7ebfae7f8b6b2"
    "452425de723cc1640d999022389672caf9bffbd0"
    "85dadb1a566c9fa8dc84cb9837b98bd5d23b8d58"
    "432ee7f96c1f6cccd05a0034c86c720cdb63a3e6"
    "ebd70ecaef14c0e239337eb6e36506303378a31a"
    "77fa7155d55bdf3fd43e29f58fe57feffcb107cf"
    "d5d4b1346bd6acba9ba41b4bf546640de162a9d6"
    "d5d4b1346bd6acba9ba41b4bf546640de162a9d6"
    "7c879f1ce18b52d9b0a8eecf877d03e66afc975b"
    "2aa9f2a55686f2ee5dc407e8e0223eb25176d906"
    "5e5bb7f4e653621e7a81ff4bcaa27dbc1f759de7"  # v3.4
)

# base_dir=`pwd`
base_dir="/home/rmudafor/Development/floris_timing/"

# conda activate floris

for hash in "${githashes[@]}"; do
    cd $base_dir/floris
    git checkout $hash 1> /dev/null 2> /dev/null   # redirect stdout and stderr to dev null - stderr prints things that arent errors
    # pip install -e . 1> /dev/null   # redirect stdout to dev null
    git rev-parse --short HEAD
    cd $base_dir
    python $base_dir/floris_metrics/quality_metrics.py $hash
done
