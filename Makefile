APIHOST = http\:\/\/10\.15\.144\.101
REPLACESTR = \$$APIHOST\\$$

md: 
	find ./src -name "*.md" -exec sed "s/$(REPLACESTR)/$(APIHOST)/" {} \;> all.md
html:md


pdf:md