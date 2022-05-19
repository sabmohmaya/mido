export TZ='Asia/Kolkata'

git clone https://github.com/fabianonline/telegram.sh $HOME/telegram.sh
mv .telegram.sh $HOME/.telegram.sh
sed -i s/demo1/${BOT_API_KEY}/g $HOME/.telegram.sh
sed -i s/demo2/${CHAT_ID}/g $HOME/.telegram.sh

git clone https://github.com/osm0sis/AnyKernel3 $HOME/AnyKernel3
git clone https://github.com/sabmohmaya/mido -b gcc --depth 1 $HOME/aarch64

KDIR=$PWD
TG=$HOME/telegram.sh/telegram
LOG=$KDIR/buildlog*.txt
KIMG=$KDIR/out/arch/arm64/boot/Image.gz-dtb
AK3=$HOME/AnyKernel3
ZIP=$HOME/AnyKernel3/*.zip

set -e

success() {
	cp anykernel.sh $AK3
	cd $AK3
	rm -rf Image.gz-dtb
	rm -rf *.zip
	cp $KIMG $AK3
	zip -r9 mido-$(cat $KDIR/out/include/generated/uts* | cut -d '"' -f 2 | cut -d "." -f -2)-$(date +'%Y%m%d-%H%M').zip * -x .git README.md *placeholder
	$TG -f $ZIP "$(cat $KDIR/out/include/generated/uts* | cut -d '"' -f 2)"$'\n'$'\n'"$(cat $KDIR/out/include/generated/comp*h | grep LINUX_COMPILER | cut -d '"' -f 2)"
	$TG -f $LOG
}

failed() {
	$TG -f $LOG "Kernel compilation failed."
	exit 1
}

$TG "Build started $(date +'%Y%m%d %H%M %Z')"$'\n'$'\n'"Branch: $(git branch --show-current)"$'\n'$'\n'"HEAD: $(git log -n 1 --oneline)"

make mido_defconfig
PATH="$HOME/aarch64/bin:${PATH}" \
make -j$(nproc --all) CROSS_COMPILE=aarch64-linux-android- \
		      2>&1 | tee buildlog.txt

[ "$(grep Image.gz-dtb $LOG | cut -d / -f 4)" == "" ] && failed || success

exit
