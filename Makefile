
.PHONY: help
help:
	# SuperLimitBreak system setup
	#  - install - Install all repos and build docker host
	#  - pull    - Update all repos
	#  - clean   - Delete all repos
	# (Requires docker/git to be installed)

.PHONY: install
install: clone build

.PHONY: clone
clone: libs displayTrigger lightingAutomation voteBattle pentatonicHero

libs:
	git clone https://github.com/calaldees/libs.git

displayTrigger:
	git clone https://github.com/SuperLimitBreak/displayTrigger.git
	#cd displayTrigger; make libs

lightingAutomation:
	git clone https://github.com/SuperLimitBreak/lightingAutomation.git
	cd lightingAutomation ; make libs

voteBattle:
	git clone https://github.com/SuperLimitBreak/voteBattle.git

pentatonicHero:
	git clone https://github.com/SuperLimitBreak/pentatonicHero.git
	cd pentatonicHero ; make libs

.PHONY: pull
pull: clone
	cd libs              ; git pull
	cd displayTrigger    ; git pull
	cd lightingAutomation; git pull
	cd voteBattle        ; git pull
	cd pentatonicHero    ; git pull

requirements.pip:
	cat $(find . -name requirements.pip) > requirements.pip

.PHONY: build
build: requirements.pip
	docker build -t python --file python.Dockerfile .
	#TODO: docker run with names

.PHONY: up
up:
	docker-compose up

.PHONY: clean
clean:
	rm -rf libs displayTrigger lightingAutomation voteBattle pentatonicHero
