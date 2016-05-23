SERVICE_PATH=~/.config/systemd/user/
SYSTEM=$(shell uname -s)
CHROME_BIN=/usr/bin/google-chrome

.PHONY: help
help:
	# SuperLimitBreak system setup
	#  - install          - Install and setup all repos
	#  - systemd	 	  - Setup systemd services to start on boot (Linux only)
	#  - start            - Start all services manually
	#  - stop             - Stop all services manually
	#  - pull             - Update all repos
	#  - clean            - Delete all repos
	# (Dependencys 'apt-get install wget git make python3 virtualenv systemd')
	# (edit displayTrigger/server/production.inidiff to point at absolute eventassets folder)


# Install ----------------------------------------------------------------------

.PHONY: install
install: clone $(SYSTEM)_install

.PHONY: Linux_install
Linux_install:

.PHONY: Darwin_install
Darwin_install:

.PHONY: clone
clone: libs pentatonicHero lightingAutomation webMidiTools displayTrigger voteBattle


# Repos ------------------------------------------------------------------------

libs:
	git clone https://github.com/calaldees/libs.git

pentatonicHero:
	git clone https://github.com/SuperLimitBreak/pentatonicHero.git

lightingAutomation:
	git clone https://github.com/SuperLimitBreak/lightingAutomation.git
	cd lightingAutomation ; make install

webMidiTools:
	git clone https://github.com/SuperLimitBreak/webMidiTools.git

displayTrigger:
	git clone https://github.com/SuperLimitBreak/displayTrigger.git
	cd displayTrigger ; make install

voteBattle:
	git clone https://github.com/SuperLimitBreak/voteBattle.git
	cd voteBattle/server; make install


# Sytemd services -------------------------------------------------------------
# Having "AUTO_ENABLE" as a comment in the service file will cause make to enable said unit

.PHONY: systemd
systemd: systemd_services

.PHONY: systemd_services
systemd_services: $(SERVICE_PATH)displayTrigger.service $(SERVICE_PATH)lightingAutomation.service $(SERVICE_PATH)voteBattle.service $(SERVICE_PATH)displayTriggerHTML5Client.service

systemd_reenable:
	for SERVICE in *.service;\
		do systemctl --user reenable $(SERVICE);\
	done

$(SERVICE_PATH)%.service:
	mkdir -p $(SERVICE_PATH)
	cp $*.service $(SERVICE_PATH)
	PWD=$$(pwd) && sed -i.bak -e "s,PWD,$${PWD},g" -e "s,CHROME_BIN,${CHROME_BIN},g" $(SERVICE_PATH)$*.service
	if grep "AUTO_ENABLE" $(SERVICE_PATH)$*.service;\
	then\
		systemctl --user enable $(SERVICE_PATH)$*.service;\
	fi
	systemctl --user daemon-reload;


# Pull Updates -----------------------------------------------------------------

.PHONY: pull
pull: clone
	cd libs              ; git pull
	cd pentatonicHero    ; git pull
	cd lightingAutomation; git pull
	cd webMidiTools      ; git pull
	cd displayTrigger    ; git pull
	cd voteBattle        ; git pull


# Run --------------------------------------------------------------------------

RUN_PATH_displayTrigger=server
RUN_PATH_lightingAutomation=.
RUN_PATH_voteBattle=server
MAKE_TARGET=run_production

.PHONY: start
start: start_displayTrigger start_voteBattle start_lightingAutomation

.PHONY: stop
stop: stop_displayTrigger stop_voteBattle stop_lightingAutomation

# $(CURDIR) can be replaced with $(pwd) to run in shell
# RUN_PATH_ is because the makefile may not be in the root of the project folder
# All subprojects should have a run_production target
start_%:
	nohup /usr/bin/make --directory "$(CURDIR)/$*/$(RUN_PATH_$*)" $(MAKE_TARGET) &

stop_%:
	kill $$(ps -ef | grep $* | grep -v grep | grep -v make | awk '{print $$2}')

.PHONY: tail
tail:
	tail -f -n 20 nohup.out
	#journalctl -f --user-unit lightingAutomation

# Clean ------------------------------------------------------------------------

.PHONY: clean
clean: $(SYSTEM)_clean
	rm -rf libs displayTrigger lightingAutomation voteBattle pentatonicHero nohup.out

.PHONY: Linux_clean
Linux_clean:
	for SERVICE in *.service; \
	do \
		systemctl --user disable $$SERVICE; \
		rm -rf $(SERVICE_PATH)$$SERVICE*; \
	done
	systemctl --user daemon-reload;

.PHONY: Darwin_clean
Darwin_clean:


# Shortcut because I'm lazy
.PHONY: shutdown
shutdown:
	sudo shutdown -h now
