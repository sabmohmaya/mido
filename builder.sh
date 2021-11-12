#bin/#!/bin/bash

git clone https://github.com/fabianonline/telegram.sh $HOME/telegram.sh
mv .telegram.sh $HOME/.telegram.sh
sed -i s/demo1/${BOT_API_KEY}/g $HOME/.telegram.sh
sed -i s/demo2/${CHAT_ID}/g $HOME/.telegram.sh
export TZ='Asia/Kolkata'

git clone https://github.com/osm0sis/AnyKernel3 $HOME/AnyKernel3
git clone https://github.com/sabmohmaya/mido -b gcc --depth 1 $HOME/aarch64

bash k*sh

exit
