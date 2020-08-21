# https://github.com/suntong/html2md

ex=		https://www.cleanenergywire.org/factsheets/germanys-national-hydrogen-strategy
ex1=	https://www.cleanenergywire.org/factsheets/making-climate-chancellor-angela-merkel
ex2=	https://www.cleanenergywire.org/factsheets/geothermal-energy-germanys-largely-untapped-renewable-heat-source

ex-new1=	https://www.cleanenergywire.org/news/germany-bets-green-hydrogen-quest-climate-neutrality
# Issues:
# the freaking node ID's for title keep changing !

print: 

dep:
	go install github.com/suntong/html2md

run:
	# simple
	html2md -i https://github.com/suntong/html2md | head -3

	# with goquery
	html2md -i https://github.com/JohannesKaufmann/html-to-markdown -s "div.BorderGrid-row.hide-sm.hide-md > div"

run-ex:
	# nid
	html2md -i $(ex) -s "#block-system-main > div" | tee ex.md

	html2md -i $(ex-new1) -s "#block-system-main > div" | tee ex-new1.md


	# title
	#html2md -i $(ex) -s "#node-6513 > div.m-node--factsheet--full__content_main > header > h1"
	


run-ex-other:
	

	# tags
	html2md -i $(ex) -s "#node-6513 > div.m-node--factsheet--full__content_main > header > div.m-node--article--full__tags-socials > div.m-node--factsheet--full__tags > div"

	# splash
	html2md -i $(ex) -s "#node-6513 > div.m-node--factsheet--full__content_main > div.m-node--factsheet--full__teaser > div > div > div"
	

run-ex1:
	# title
	html2md -i $(ex1) -s "#node-1203 > div.m-node--factsheet--full__content_main > header > h1"

run-ex2:
	# title
	html2md -i $(ex2) -s "#node-6506 > div.m-node--factsheet--full__content_main > header > h1"

	# tags
	html2md -i $(ex2) -s "#node-6506 > div.m-node--factsheet--full__content_main > header > div.m-node--article--full__tags-socials > div.m-node--factsheet--full__tags > div"
	