##
# xml2rfc makefile
##

XML2RFC := xml2rfc
DRAFT := draft

all: README.md draft.html

%.txt: %.xml
	$(XML2RFC) $< -o $@ --text

%.html: %.xml
	$(XML2RFC) $< -o $@ --html

README.md: $(DRAFT).txt readme-header.md
	cat readme-header.md > $@
	echo \`\`\` >> README.md
	cat $(DRAFT).txt >> README.md
	echo \`\`\` >> README.md
