# Automatically Generated Makefile by EDE.
# For use with: make
#
# DO NOT MODIFY THIS FILE OR YOUR CHANGES MAY BE LOST.
# EDE is the Emacs Development Environment.
# http://cedet.sourceforge.net/ede.shtml
#

top=../
ede_FILES=Project.ede Makefile

tools_LISP=bison-wisent.el
EMACS=emacs
EMACSFLAGS=-batch --no-site-file
wisent_LISP=wisent.el semantic-wisent.el wisent-comp.el wisent-expr.el wisent-grammar.el wisent-debug.el wisent-grammar-macros.el
LOADPATH= ../../speedbar/ ../../common/ ../bovine/ ../\
    ../../ede/ ../../eieio/
wy_SEMANTIC_GRAMMAR=wisent-java-tags.wy wisent-awk.wy wisent-calc.wy wisent-cim.wy wisent-java.wy wisent-python.wy wisent-javascript-jv.wy
wy_SEMANTIC_GRAMMAR_EL=wisent-java-tags-wy.el wisent-awk-wy.el wisent-calc-wy.el wisent-cim-wy.el wisent-java-wy.el wisent-python-wy.el wisent-javascript-jv-wy.el
languages_LISP=wisent-calc.el wisent-java.el wisent-java-tags.el wisent-python.el wisent-javascript.el
VERSION=2.1
DISTDIR=$(top)semantic-$(VERSION)/wisent



all: tools wisent wy languages

.PHONY: tools
tools: $(tools_LISP)
	@echo "(add-to-list 'load-path nil)" > $@-compile-script
	for loadpath in . ${LOADPATH}; do \
	   echo "(add-to-list 'load-path \"$$loadpath\")" >> $@-compile-script; \
	done;
	@echo "(setq debug-on-error t)" >> $@-compile-script
	"$(EMACS)" $(EMACSFLAGS) -l $@-compile-script -f batch-byte-compile $^

.PHONY: wisent
wisent: $(wisent_LISP)
	@echo "(add-to-list 'load-path nil)" > $@-compile-script
	for loadpath in . ${LOADPATH}; do \
	   echo "(add-to-list 'load-path \"$$loadpath\")" >> $@-compile-script; \
	done;
	@echo "(setq debug-on-error t)" >> $@-compile-script
	"$(EMACS)" $(EMACSFLAGS) -l $@-compile-script -f batch-byte-compile $^

.PHONY: wy
wy: $(wy_SEMANTIC_GRAMMAR)
	@echo "(add-to-list 'load-path nil)" > grammar-make-script
	@for loadpath in . ${LOADPATH}; do \
	   echo "(add-to-list 'load-path \"$$loadpath\")" >> grammar-make-script; \
	done;
	@echo "(require 'semantic-load)" >> grammar-make-script
	@echo "(require 'semantic-grammar)" >> grammar-make-script
	"$(EMACS)" -batch --no-site-file -l grammar-make-script -f semantic-grammar-batch-build-packages $^

.PHONY: languages
languages: $(languages_LISP)
	@echo "(add-to-list 'load-path nil)" > $@-compile-script
	for loadpath in . ${LOADPATH}; do \
	   echo "(add-to-list 'load-path \"$$loadpath\")" >> $@-compile-script; \
	done;
	@echo "(setq debug-on-error t)" >> $@-compile-script
	"$(EMACS)" $(EMACSFLAGS) -l $@-compile-script -f batch-byte-compile $^

tags: 


clean:
	rm -f *.elc

.PHONY: dist

dist: $(wy_SEMANTIC_GRAMMAR_EL)
	mkdir $(DISTDIR)
	cp $(tools_LISP) $(wisent_LISP) $(wy_SEMANTIC_GRAMMAR) $(wy_SEMANTIC_GRAMMAR_EL) $(languages_LISP) $(ede_FILES) $(DISTDIR)

Makefile: Project.ede
	@echo Makefile is out of date!  It needs to be regenerated by EDE.
	@echo If you have not modified Project.ede, you can use 'touch' to update the Makefile time stamp.
	@false



# End of Makefile
