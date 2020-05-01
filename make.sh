URL=$1
apt-get -y install p7zip-full
apt-get -y install python
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
if [[ "$URL" == "http"* ]]; then
ZIP_NAME=$(echo ${URL##*/})
REAL_ZIP_NAME=$(echo ${ZIP_NAME%.*})
wget $URL
echo $ZIP_NAME已下载完毕
echo 正在解压$ZIP_NAME
7za x $ZIP_NAME -r -o./$REAL_ZIP_NAME
echo 解压完毕
chmod -R 777 $REAL_ZIP_NAME
cd $REAL_ZIP_NAME
br=$(ls *.br)
for i in $br
do
HEAD_BR_NAME=$(echo ${i%%.*})
chmod 777 $PROJECT_DIR/tools/brotli
chmod 777 $PROJECT_DIR/tools/sdat2img.py
echo 正在将br转换为dat
$PROJECT_DIR/tools/brotli -d $HEAD_BR_NAME.new.dat.br
echo 正在将dat转化为img
$PROJECT_DIR/tools/sdat2img.py $HEAD_BR_NAME.transfer.list $HEAD_BR_NAME.new.dat $HEAD_BR_NAME.img
rm -rf $HEAD_BR_NAME.new.dat.br
rm -rf $HEAD_BR_NAME.new.dat
rm -rf $HEAD_BR_NAME.patch.dat
rm -rf $HEAD_BR_NAME.transfer.list
done
mkdir -p $PROJECT_DIR/tmp/system
mount -t ext4 system.img $PROJECT_DIR/tmp/system
cp -r $PROJECT_DIR/tmp/system $PROJECT_DIR/$REAL_ZIP_NAME
umount -l $PROJECT_DIR/tmp/system
mkdir -p $PROJECT_DIR/tmp/vendor
mount -t ext4 vendor.img $PROJECT_DIR/tmp/vendor
cp -r $PROJECT_DIR/tmp/vendor $PROJECT_DIR/$REAL_ZIP_NAME
umount -l $PROJECT_DIR/tmp/vendor
rm -rf $PROJECT_DIR/tmp
elif [[ "$URL" == *".zip" ]]
then
rm -rf $PROJECT_DIR/tmp
EXITS_ZIP_NAME=$(echo ${URL%.*})
echo 正在解压$EXITS_ZIP_NAME
7za x $URL -r -o./$EXITS_ZIP_NAME
echo 解压完毕
chmod -R 777 $EXITS_ZIP_NAME 
cd $EXITS_ZIP_NAME
br=$(ls *.br)
for a in $br
do
HEAD_BR_NAME=$(echo ${a%%.*})
chmod 777 $PROJECT_DIR/tools/brotli
chmod 777 $PROJECT_DIR/tools/sdat2img.py
echo 正在将br转换为dat
$PROJECT_DIR/tools/brotli -d $HEAD_BR_NAME.new.dat.br
echo 正在将dat转化为img
$PROJECT_DIR/tools/sdat2img.py $HEAD_BR_NAME.transfer.list $HEAD_BR_NAME.new.dat $HEAD_BR_NAME.img
rm -rf $HEAD_BR_NAME.new.dat.br
rm -rf $HEAD_BR_NAME.new.dat
rm -rf $HEAD_BR_NAME.patch.dat
rm -rf $HEAD_BR_NAME.transfer.list
done
mkdir -p $PROJECT_DIR/tmp/system
mount -t ext4 system.img $PROJECT_DIR/tmp/system
cp -r $PROJECT_DIR/tmp/system $PROJECT_DIR/$EXITS_ZIP_NAME
umount -l $PROJECT_DIR/tmp/system
mkdir -p $PROJECT_DIR/tmp/vendor
mount -t ext4 vendor.img $PROJECT_DIR/tmp/vendor
cp -r $PROJECT_DIR/tmp/vendor $PROJECT_DIR/$EXITS_ZIP_NAME
umount -l $PROJECT_DIR/tmp/vendor
rm -rf $PROJECT_DIR/tmp
fi
