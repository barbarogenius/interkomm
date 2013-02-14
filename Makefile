#
# Makefile
#
#
#

VERSION=0.4.6.3
PACKAGE_VERSION=1
PROG=dpkg
SOURCE=./build
FLAGS=-b
ARCH=i686
TARGET=interkomm_$(VERSION)-$(PACKAGE_VERSION)_$(ARCH).deb
SNAP=28_06_2011
TMP=./build

package:
	make -C external/yaml-0.2/
	cp external/yaml-0.2/yaml.so lib/
	mkdir -p $(TMP)/deb
	mkdir -p $(TMP)/etc/interkomm
	mkdir -p $(TMP)/DEBIAN
	mkdir -p $(TMP)/etc/init.d
	mkdir -p $(TMP)/var/lib/interkomm/db
	mkdir -p $(TMP)/var/lib/interkomm/public/admin
	mkdir -p $(TMP)/var/lib/interkomm/app
	mkdir -p $(TMP)/var/lib/interkomm/projects
	mkdir -p $(TMP)/var/log/interkomm
	mkdir -p $(TMP)/var/run/interkomm
	mkdir -p $(TMP)/usr/sbin
	mkdir -p $(TMP)/usr/share/lua/5.1/ikm
	mkdir -p $(TMP)/usr/lib/lua/5.1
	mkdir -p $(TMP)/usr/share/interkomm
	mkdir -p $(TMP)/usr/share/man/man8
	mkdir -p $(TMP)/usr/share/doc/interkomm
	cp debian/* $(TMP)/DEBIAN/
	chmod 0555 $(TMP)/DEBIAN/*
	cp src/ikm $(TMP)/usr/sbin/
	cp src/ikmd $(TMP)/usr/sbin/
	cp src/ikmeventd $(TMP)/usr/sbin/
	cp src/ikm-worker $(TMP)/usr/sbin/
	cp lib/ikm.lua $(TMP)/usr/share/lua/5.1/
	cp lib/yaml.so $(TMP)/usr/lib/lua/5.1/
	cp lib/ikm/* $(TMP)/usr/share/lua/5.1/ikm/ 
	cp src/interkomm.init $(TMP)/etc/init.d/interkomm
	cp config/*.yml $(TMP)/etc/interkomm/
	cp src/bootstrap.lua $(TMP)/etc/interkomm/
	cp -R app/* $(TMP)/var/lib/interkomm/app/
	cp doc/interkomm.vhost $(TMP)/usr/share/doc/interkomm/
	cp -R public/* $(TMP)/var/lib/interkomm/public/
	cp doc/ikm.8 $(TMP)/usr/share/man/man8/ikm.8
	find $(TMP)/ -name .svn -print0 | xargs -0 rm -rf
	$(PROG) $(FLAGS) $(SOURCE) $(TARGET)

build_external:
	make -C external/yaml-0.2/
	cp external/yaml-0.2/yaml.so lib/

snapshot:
	tar cvvf interkomm-$(SNAP).tar $(TMP)
	gzip interkomm-$(SNAP).tar

luadoc:
	/usr/local/bin/luadoc -d doc/luadoc/ lib/ikm

clean:
	make -C external/yaml-0.2/ clean
	rm lib/yaml.so
	rm -Rf $(TMP)/*
