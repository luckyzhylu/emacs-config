# Automatically Generated Makefile by EDE.
# For use with: make
#
# DO NOT MODIFY THIS FILE OR YOUR CHANGES MAY BE LOST.
# EDE is the Emacs Development Environment.
# http://cedet.sourceforge.net/ede.shtml
#

top=
ede_FILES=Project.ede Makefile

Lisp_LISP=cedet-integ-test.el cit-cpp.el cit-el.el cit-texi.el cit-load.el cit-srec.el cit-gnustep.el cit-uml.el cit-dist.el cit-symref.el cit-externaldb.el cit-android.el cit-arduino.el cit-projvar.el
EMACS=emacs
EMACSFLAGS=-batch --no-site-file
LOADPATH= ../speedbar/ ../cogre/ ../contrib/ ../ede/ ../srecode/ ../semantic/wisent/ ../semantic/bovine/ ../semantic/ ../eieio/ ../common/
ELISPPRELOAD= cedet-compat
templates_MISC=cit-extra-cpp.srt
scripts_MISC=cit-test.sh
Misc_MISC=README ChangeLog cit-uml.cgr
VERSION=1.0
DISTDIR=$(top)cit-$(VERSION)



all: Lisp templates scripts Misc

.PHONY: Lisp
Lisp: $(Lisp_LISP)
	@echo "(add-to-list 'load-path nil)" > $@-compile-script
	for loadpath in . ${LOADPATH}; do \
	   echo "(add-to-list 'load-path \"$$loadpath\")" >> $@-compile-script; \
	done;
	for preload in ${ELISPPRELOAD}; do \
	   echo "(load \"$$preload\")" >> $@-compile-script; \
	done;
	@echo "(setq debug-on-error t)" >> $@-compile-script
	"$(EMACS)" $(EMACSFLAGS) -l $@-compile-script -f batch-byte-compile $^

templates: 
	@

scripts: 
	@

Misc: 
	@

tags: 


clean:
	rm -f *.elc

.PHONY: dist

dist:
	mkdir $(DISTDIR)
	cp $(Lisp_LISP) $(templates_MISC) $(scripts_MISC) $(Misc_MISC) $(ede_FILES) $(DISTDIR)

Makefile: Project.ede
	@echo Makefile is out of date!  It needs to be regenerated by EDE.
	@echo If you have not modified Project.ede, you can use 'touch' to update the Makefile time stamp.
	@false



# End of Makefile
