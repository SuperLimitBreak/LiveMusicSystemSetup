SERVICE_PATH=~/.config/systemd/user/
SYSTEM=$(shell uname -s)

ifeq ($(SYSTEM), Linux)
	CHROME_BIN=google-chrome
else
	CHROME_BIN=chrome
endif

.PHONY: help
help:
	# SuperLimitBreak system setup
	#  - install - Install and setup all repos
	#  - pull    - Update all repos
	#  - clean   - Delete all repos
	# (Requires git to be installed)


# Install ----------------------------------------------------------------------

.PHONY: install
install: clone services
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
services: $(SERVICE_PATH)displayTrigger.service $(SERVICE_PATH)lightingAutomation.service $(SERVICE_PATH)voteBattle.service $(SERVICE_PATH)displayTriggerHTML5Client.service
	if [ hash systemctl 2>/dev/null ] ; then \
		systemctl --user daemon-reload ;\
	fi

$(SERVICE_PATH)%.service:
	mkdir -p $(SERVICE_PATH)
	cp $*.service $(SERVICE_PATH)
	PWD=$$(pwd|sed 's/\//\\\//g') && sed -i.bak -e "s/PWD/$${PWD}/g" -e "s/CHROME_BIN/${CHROME_BIN}/g" $(SERVICE_PATH)$*.service


# Pull Updates -----------------------------------------------------------------

.PHONY: pull
pull: clone
	cd libs              ; git pull
	cd pentatonicHero    ; git pull
	cd displayTrigger    ; git pull
	cd lightingAutomation; git pull
	cd voteBattle        ; git pull


# Run --------------------------------------------------------------------------

%.pid:
	# Unfinished experiment
	start-stop-daemon --start --pidfile $@ --name $* --make-pidfile --background --exec /usr/bin/make --directory "$(CURDIR)/$*/server/" run_production

.PHONY: 
start: displayTrigger.pid lightingAutomation.pid voteBattle.pid
.PHONY: stop
stop:
	for PID in $$(ls *.pid) ; do \
		start-stop-daemon --stop  --pidfile $$PID && rm $$PID ;\
	done
	rm -rf *.pid


# Clean ------------------------------------------------------------------------

.PHONY: clean
clean: stop
	rm -rf libs displayTrigger lightingAutomation voteBattle pentatonicHero
	for SERVICE in displayTrigger lightingAutomation voteBattle ; do \
		rm -rf $(SERVICE_PATH)$$SERVICE.service ;\
	done
