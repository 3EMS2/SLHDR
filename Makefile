include config.mak

CFLAGS:=$(CFLAGS) -I$(AVX_INCDIR)
LD_FLAGS:=$(AVX2_LD_PATH) $(AVX2_LD_FLAGS)

INSTALL=cp -p
MKDIR=mkdir -p
LN=ln -sf

.PHONY: install clean all

all: pp_slhdr$(SUFFIX).so

pp_slhdr$(SUFFIX).so: pp_wrapper_slhdr.o
	$(CC) -shared $^ -o $@ $(LD_FLAGS)

%.o: %.cpp config.mak
	$(CXX) -std=c++11 -c $< -o $@ -MMD -MF $(@:.o=.d) -MT $@ $(CFLAGS)

slhdr_cwrap.pc:
	./genpkgcfg.sh

install: install_headers install_lib install_pkgcfg

install_headers: pp_wrapper_slhdr.h
	$(MKDIR) $(INCDIR)
	$(INSTALL) $< $(INCDIR)/

install_lib: pp_slhdr$(SUFFIX).so
	$(MKDIR) $(LIBDIR)
	$(INSTALL) $< $(LIBDIR)/
	$(LN) $< $(LIBDIR)/libslhdr_cwrap.so

install_pkgcfg: slhdr_cwrap.pc
	$(MKDIR) $(PKGDIR)
	$(INSTALL) $< $(PKGDIR)/

clean:
	$(RM) *.so *.o *.d *.pc
