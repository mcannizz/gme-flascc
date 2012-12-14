#Set these to the paths to your FlasCC and Flex installs
flascc=~/flascc/sdk/
flex=~/flex

all:
	$(flascc)/usr/bin/swig -as3 gme.i
	$(flascc)/usr/bin/genfs --type=embed testfiles testfs
	java -jar $(flascc)/usr/lib/asc2.jar -merge -md -import \
		$(flascc)/usr/lib/InMemoryBackingStore.abc \
		-import $(flascc)/usr/lib/builtin.abc \
		-import $(flascc)/usr/lib/playerglobal.abc \
		-import $(flascc)/usr/lib/BinaryData.abc \
		testfs*.as
	$(flascc)/usr/bin/g++ gme_wrap.c gme/*.cpp libgme.as testfs*.abc \
		main.cpp demo/Wave_Writer.cpp -emit-swc=sample.libgme -o libgme.swc
	rm -f libgme.as
	$(flex)/bin/mxmlc -static-link-runtime-shared-libraries \
		-compiler.omit-trace-statements=false -library-path=libgme.swc \
		-debug=false demo.as -o demo.swf


clean:
	rm -f libgme.swc gme_wrap.c gme_wrap.o libgme.as demo.swf testfs* \

