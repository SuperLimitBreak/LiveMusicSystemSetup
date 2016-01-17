SERVICE_PATH=~/.config/systemd/user/

.PHONY: help
help:
	# SuperLimitBreak system setup
	#  - install - Install and setup all repos
	#  - pull    - Update all repos
	#  - clean   - Delete all repos
	# (Requires docker/git to be installed)


# Install ----------------------------------------------------------------------

.PHONY: install
install: clone services build

.PHONY: clone
clone: libs pentatonicHero displayTrigger lightingAutomation voteBattle


# Repos ------------------------------------------------------------------------

libs:
	git clone https://github.com/calaldees/libs.git

pentatonicHero:
	git clone https://github.com/SuperLimitBreak/pentatonicHero.git

displayTrigger:
	git clone https://github.com/SuperLimitBreak/displayTrigger.git
	cd displayTrigger/server; make install

lightingAutomation:
	git clone https://github.com/SuperLimitBreak/lightingAutomation.git
	cd lightingAutomation ; make install

voteBattle:
	git clone https://github.com/SuperLimitBreak/voteBattle.git
	cd voteBattle/server; make install


# Sytemd services --------------------------------------------------------------

.PHONY: services
services: $(SERVICE_PATH)displayTrigger.service $(SERVICE_PATH)lightingAutomation.service $(SERVICE_PATH)voteBattle.service
	if [ hash systemctl 2>/dev/null ] ; then \
		systemctl --user daemon-reload ;\
	fi

$(SERVICE_PATH)%.service:
	mkdir -p $(SERVICE_PATH)
	cp $*.service $(SERVICE_PATH)
	#printf "\nHi\nthis_PATH\nYep" > test.txt  && p=$(pwd|sed 's/\//\\\//g') && echo $p && echo $p && sed -i.bak "s/PATH/${p}/g" test.txt && cat test.txt


# Pull Updates -----------------------------------------------------------------

.PHONY: pull
pull: clone
	cd libs              ; git pull
	cd pentatonicHero    ; git pull
	cd displayTrigger    ; git pull
	cd lightingAutomation; git pull
	cd voteBattle        ; git pull


# Build ------------------------------------------------------------------------

requirements.pip:
	cat $$(find . -name requirements.pip) > requirements.pip

.PHONY: build
build: requirements.pip
	pip3 install --upgrade pip
	pip3 install -r requirements.pip
	#docker build -t python --file python.Dockerfile .
	#TODO: docker run with names?
	# Unsure if docker is the correct tool.
	# Consider local machine with systemd or docker contaner with systemd
	# Either way the current plan is to configure systemd services


# Run --------------------------------------------------------------------------

.PHONY: start
start:
	#docker-compose up


# Clean ------------------------------------------------------------------------

.PHONY: clean
clean:
	rm -rf libs displayTrigger lightingAutomation voteBattle pentatonicHero
	for SERVICE in displayTrigger lightingAutomation voteBattle ; do \
		rm -rf $(SERVICE_PATH)$$SERVICE.service ;\
	done
