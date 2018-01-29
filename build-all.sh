# Initialise

# Create a directory to do all of the building work in
mkdir working

# Create a directory to store all the juicy packages that will be built
mkdir built

# Now get to work
cd working

# android-pico

sudo apt install openjdk-8-jdk git ant wget android-tools-adb lib32stdc++6 lib32z1
git clone git@github.com:mypico/android-pico.git
cd android-pico
git submodule init
git submodule update
wget --output-document=android-sdk.tgz https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
tar --extract --gzip --file=android-sdk.tgz
android-sdk-linux/tools/android update sdk --no-ui --all --filter platform-tools,tools,build-tools-25.0.2,android-23,extra-android-m2repository,extra-google-m2repository
export ANDROID_HOME=$PWD/android-sdk-linux 
export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8
./gradlew assembleDebug
./gradlew javadoc

cp android-pico/build/outputs/apk/android-pico-debug.apk ../../built/
cd ..

# libpicobt

sudo apt install libbluetooth3-dev libc6 cmake git gcc make pkg-config dh-exec doxygen graphviz
git clone git@github.com:mypico/libpicobt.git
cd libpicobt
cmake .
make package
sudo dpkg -i packages/libpicobt_0.0.1_amd64-dev.run
sudo dpkg -i packages/libpicobt_0.0.1_amd64-dev.deb

cp packages/libpicobt_0.0.1_amd64-run.deb ../../built/
cp packages/libpicobt_0.0.1_amd64-dev.deb ../../built/
cd ..

# libpico

sudo apt install \
  libssl-dev libcurl4-openssl-dev libqrencode-dev libbluetooth-dev liburl-dispatcher1-dev \
  pkg-config autotools-dev devscripts debhelper dh-systemd dh-exec \
  git gcc make check openssh-client doxygen graphviz
git clone git@github.com:mypico/libpico.git
cd libpico
./configure
make
make check
debuild -us -uc -b --lintian-opts -X changes-file
sudo dpkg -i ../libpico1_0.0.2-1_amd64.deb
sudo dpkg -i ../libpico1-dev_0.0.2-1_amd64.deb

cp ../libpico1_0.0.2-1_amd64.deb ../../built/
cp ../libpico1-dev_0.0.2-1_amd64.deb ../../built/
cd ..

# pam_pico

sudo apt install \
  libssl-dev libcurl4-openssl-dev libqrencode-dev libbluetooth-dev liburl-dispatcher1-dev \
  pkg-config autotools-dev devscripts debhelper dh-systemd dh-exec \
  git gcc make check openssh-client doxygen graphviz
git clone git@github.com:mypico/pam_pico.git
cd pam_pico
./configure
make
make check
debuild -us -uc -b --lintian-opts -X changes-file
sudo dpkg -i ../libpam-pico_0.0.2-1_amd64.deb

cp ../libpam-pico_0.0.2-1_amd64.deb ../../built/
cd ..

# Finalise

cd ..
ls built

