APIHOST = http\:\/\/10\.15\.144\.101
REPLACESTR = \$$APIHOST\\$$

md: 
	find ./src -name "*.md" -exec sed "s/$(REPLACESTR)/$(APIHOST)/" {} \;> all.md

pub-md:
	rm -f public.md
	for line in `cat filelist`; \
	do \
	sed "s/$(REPLACESTR)/$(APIHOST)/" ./src/$$line >> public.md; \
	done
html:md


pdf:md


pub-html:pub-md


pub-pdf:pub-md