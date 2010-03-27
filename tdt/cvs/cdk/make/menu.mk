.PHONY: menu menu-clean menu-distclean help

menu:
	@if [ -z "@DIALOG@" ]; then \ 
		${MAKE} -s help; \
	else \
		tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$$$; \
		@DIALOG@ --title "Make target Selection" \
			--menu "\nWhat do you want to make?\n " 18 40 8 \
			"1" "Neutrino" \
			"2" "Enigma2" \
			"3" "Enigma2-nightly" \
			"4" "VDR" \
			"5" "Enigma1-HD" \
			"" "" \
			"6" "clean" \
			"7" "distclean" \	
			2> $${tempfile}; \
		if [ "$$?" -eq "0" ]; then \
			clear; \
			case `cat $${tempfile}` in \
				1) ${MAKE} yaud-neutrino;; \
				2) ${MAKE} yaud-enigma2;; \
				3) ${MAKE} yaud-enigma2-nightly;; \
				4) ${MAKE} yaud-vdr;; \
				5) ${MAKE} enigma1-hd.do_compile;; \
				"") ;; \
				6) ${MAKE} menu-clean;; \
				7) ${MAKE} menu-distclean;; \
				*) echo "This should not happen" 1>&2 && false;; \
			esac; \
		else \
			clear; \
		fi; \
	fi

menu-clean:
	-@@DIALOG@ --title "make clean" --clear --defaultno \
		--yesno "\nAre you really sure?\n " 7 40; \
	[ "$$?" -eq "0" ] && clear && ${MAKE} clean || clear

menu-distclean:
	-@@DIALOG@ --title "make distclean" --clear --defaultno \
		--yesno "\nAre you really sure?\n " 7 40; \
	[ "$$?" -eq "0" ] && clear && ${MAKE} distclean || clear

help:
	@echo -e "\nPossible make targets include:\n \
		yaud-neutrino\n \
		yaud-enigma2\n \
		yaud-enigma2-nightly\n \
		yaud-vdr\n \
		enigma1-hd.do_compile\n" 
	@echo -e "Further the following clean-up targets are available:\n \
		clean\n \
		distclean\n\n"

