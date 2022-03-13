#pandoc : https://pandoc.org/installing.html
#pip3 install asciidoc
asciidoc -b docbook foo.adoc
dos2unix foo.xml
pandoc -f docbook -t markdown_strict foo.xml -o foo.md
#iconv -t utf-8 foo.xml | pandoc -f docbook -t markdown_strict | iconv -f utf-8 > foo.md
#iconv -t utf-8 foo.xml | pandoc -f docbook -t markdown_strict --wrap=none | iconv -f utf-8 > foo.md
