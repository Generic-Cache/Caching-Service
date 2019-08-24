#! /bin/bash

clear

# RED = MISS
# YELLOW = BYPASS 
# ORNAGE = EXPIRED
# GRAY = STALE
# BLUE = UPDATING
# CYAN = REVALIDATED
# GREEN = HIT
# NC = NO COLOUR

RED='\033[31m';
GREEN='\033[32m';
YELLOW='\033[33m';
ORANGE='\033[33m';
GRAY='\033[30m';
BLUE='\033[34m';
CYAN='\033[36m';
NC='\033[0;0m';

BOLD='\e[1m';
NORMAL='\e[0m';

# tasks to do after the program is killed.

function _upon_termination {

	clear
	echo -e "${NORMAL}${YELLOW}========================================================="
	echo -e "${BOLD}${YELLOW}The Final Statictics"
	echo -e "${NORMAL}${YELLOW}========================================================="

	if [[ "$total" -ne 0 ]]
	then
		echo -ne "\n\n${BOLD}${NC} Total no. of requests = " $(echo "${total}");

		# printf "\n\n${BOLD}${RED} Miss ratio = ";
		echo -ne "\n\n${BOLD}${RED} No. of Misses = " $(echo "${miss}");
		echo -ne "\n${BOLD}${RED} Miss ratio = " $(echo "scale=3; ${miss} * 100 / ${total}" | bc);

		# printf "\n${BOLD}${GREEN} Hit ratio = ";
		echo -ne "\n\n${BOLD}${GREEN} No. of Hits = " $(echo "${hit}");
		echo -ne "\n${BOLD}${GREEN} Hit ratio = " $(echo "scale=3; ${hit} * 100 / ${total}" | bc);

		# printf "\n${BOLD}${YELLOW} Bypass ratio = ";
		echo -ne "\n\n${BOLD}${YELLOW} No. of Bypasses = " $(echo "${bypass}");
		echo -ne "\n${BOLD}${YELLOW} Bypass ratio = " $(echo "scale=3; ${bypass} * 100 / ${total}" | bc);

		# printf "\n${BOLD}${ORANGE} Exipred ratio = ";
		echo -ne "\n\n${BOLD}${ORANGE} No. of Expired records = " $(echo "${expired}");
		echo -ne "\n${BOLD}${ORANGE} Exipred ratio = " $(echo "scale=3; ${expired} * 100 / ${total}" | bc);

		# printf "\n${BOLD}${BLUE} Updating ratio = ";
		echo -ne "\n\n${BOLD}${BLUE} No. of Updated records = " $(echo "${updating}");
		echo -ne "\n${BOLD}${BLUE} Updating ratio = " $(echo "scale=3; ${updating} * 100 / ${total}" | bc);

		# printf "\n${BOLD}${CYAN} Revalidated ratio = ";
		echo -ne "\n\n${BOLD}${CYAN} No. of Revalidated records = " $(echo "${revalidated}");
		echo -ne "\n${BOLD}${CYAN} Revalidated ratio = " $(echo "scale=3; ${revalidated} * 100 / ${total}" | bc);

		# printf "\n${BOLD}${GRAY} Stale ratio = ";
		echo -ne "\n\n${BOLD}${GRAY} No. of Stale records = " $(echo "${stale}");
		echo -ne "\n${BOLD}${GRAY} Stale ratio = " $(echo "scale=3; ${stale} * 100 / ${total}" | bc);

	else
		echo -e "\n\n${BOLD}${CYAN}Number of requests recieved = 0";
	fi

	echo -e ${NC}"\n\nClosing program";
	exit 0;
}


trap _upon_termination SIGINT SIGTERM SIGKILL

#necessary variables

miss="$(grep -c "ucs=\"MISS\"" /data/logs/access.log)";
hit="$(grep -c "ucs=\"HIT\"" /data/logs/access.log)";
stale="$(grep -c "ucs=\"STALE\"" /data/logs/access.log)";
bypass="$(grep -c "ucs=\"BYPASS\"" /data/logs/access.log)";
expired="$(grep -c "ucs=\"EXPIRED\"" /data/logs/access.log)";
updating="$(grep -c "ucs=\"UPDATING\"" /data/logs/access.log)";
revalidated="$(grep -c "ucs=\"REVALIDATED\"" /data/logs/access.log)";
total="$(grep -c "rid=" /data/logs/access.log)";

_upon_termination
