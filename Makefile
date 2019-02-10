clang.tar.xz :
	wget -c https://releases.llvm.org/7.0.1/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-18.04.tar.xz \
		-O clang.tar.xz

clang : clang.tar.xz
	mkdir clang
	tar -xf clang.tar.xz --directory clang --strip-components=1

musl.tar.xz :
	wget -c https://www.musl-libc.org/releases/musl-1.1.21.tar.gz \
		-O musl.tar.xz

musl : musl.tar.xz
	mkdir musl
	tar -xf musl.tar.xz --directory musl --strip-components=1
	cd musl && ./configure --prefix=root && make install

helloc.i : helloc.c musl clang
	./clang/bin/clang \
		-std=c11 \
		-nostdinc \
		-isystem ./musl/root/include \
		-E helloc.c \
		-o helloc.i

helloc.o : helloc.i clang
	./clang/bin/clang \
		-std=c11 \
		-nostdlib \
		-nostdinc \
		-c helloc.i \
		-o helloc.o

helloc : helloc.o clang musl
	./clang/bin/ld.lld \
		helloc.o \
		-nostdlib \
		-L musl/root/lib \
		-lc \
		-ldl \
		-lm \
		-lutil \
		-lrt \
		-e main \
		-o helloc

clean:
	rm -f hellocpp.ii helloc.i hellocpp.o helloc.o hellocpp helloc
