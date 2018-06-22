ROOT_FOLDER=..

REPOS=libs stageOrchestration stageViewer webMidiTools displayTrigger
#pentatonicHero voteBattle

.PHONY: help
help:
	# superLimitBreak system setup
	#  - install          - Install and setup all repos
	#  - run              - Use docker-compose to run all containers
	#  - pull             - Update all repos
	#  - clean            - Delete all repos

# Install ----------------------------------------------------------------------

.PHONY: install
install: clone

.PHONY: clone
clone: ${ROOT_FOLDER}/libs ${ROOT_FOLDER}/stageOrchestration ${ROOT_FOLDER}/stageViewer ${ROOT_FOLDER}/webMidiTools ${ROOT_FOLDER}/displayTrigger


# Repos ------------------------------------------------------------------------

${ROOT_FOLDER}/libs:
	cd ${ROOT_FOLDER} ; git clone https://github.com/calaldees/$@.git

${ROOT_FOLDER}/stageOrchestration:
	cd ${ROOT_FOLDER} ; git clone https://github.com/SuperLimitBreak/$@.git
	make install --directory ${ROOT_FOLDER}/$@

${ROOT_FOLDER}/stageViewer:
	cd ${ROOT_FOLDER} ; git clone https://github.com/SuperLimitBreak/$@.git
	make install --directory ${ROOT_FOLDER}/$@

${ROOT_FOLDER}/webMidiTools:
	cd ${ROOT_FOLDER} ; git clone https://github.com/SuperLimitBreak/$@.git

${ROOT_FOLDER}/displayTrigger:
	cd ${ROOT_FOLDER} ; git clone https://github.com/SuperLimitBreak/$@.git
	make install --directory ${ROOT_FOLDER}/$@

#pentatonicHero:
#	git clone https://github.com/SuperLimitBreak/pentatonicHero.git

#voteBattle:
#	git clone https://github.com/SuperLimitBreak/voteBattle.git
#	cd voteBattle/server; make install

run: install
	docker-compose --file ${ROOT_FOLDER}/displayTrigger/server/docker-compose.yml --file ${ROOT_FOLDER}/stageOrchistration/docker-compose.yml --file ${ROOT_FOLDER}/stageViewer/docker-compose.yml up


# Pull Updates -----------------------------------------------------------------

.PHONY: pull
pull: clone
	for REPO in ${REPOS}; do\
		cd ${ROOT_FOLDER}/${REPO} ; git pull;\
	done


# Clean ------------------------------------------------------------------------

.PHONY: clean
clean:
	for REPO in ${REPOS}; do\
		rm -rf ${ROOT_FOLDER}/${REPO} ;\
	done
