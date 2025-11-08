#!make
ifeq ($(OS),Windows_NT)
SHELL := cmd
else
SHELL := /bin/bash
endif

# Generate documentation for test XSD files
TESTSRC := $(wildcard tests/*.xsd)
TESTDOC := $(patsubst tests/%.xsd,doc/tests/%/index.html,$(TESTSRC))

XSDVIPATH := ${CURDIR}/xsdvi/xsdvi.jar
XSLT_FILE := ${CURDIR}/xsl/xs3p.xsl

# Default target: generate documentation for test XSD files
all: $(TESTDOC)

# Setup target: download xsdvi jar if needed
setup: $(XSDVIPATH)

xsdvi/xsdvi.zip:
	mkdir -p $(dir $@)
	curl -sSL https://sourceforge.net/projects/xsdvi/files/latest/download > $@

$(XSDVIPATH): xsdvi/xercesImpl.jar
	curl -sSL https://github.com/metanorma/xsdvi/releases/download/v1.0/xsdvi-1.0.jar > $@

xsdvi/xercesImpl.jar: xsdvi/xsdvi.zip
	unzip -p $< dist/lib/xercesImpl.jar > $@

# Generate HTML documentation for each XSD file
doc/tests/%/index.html: tests/%.xsd $(XSDVIPATH)
	mkdir -p $(dir $@)diagrams; \
	java -jar $(XSDVIPATH) $(CURDIR)/$< -rootNodeName all -oneNodeOnly -outputPath $(dir $@)diagrams; \
	xsltproc --nonet --param title "'XSD Schema Documentation for $(notdir $*)'" \
		--output $@ $(XSLT_FILE) $<

# Test target: run Ruby test suite
test:
	bundle exec rspec

# Clean generated documentation
clean:
	rm -rf doc

# Clean everything including downloaded dependencies
distclean: clean
	rm -rf xsdvi

.PHONY: all clean setup distclean test
