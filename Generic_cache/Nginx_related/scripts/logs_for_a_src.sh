#! /bin/bash

# set -e

clear

# RED = MISS
# YELLOW = BYPASS 
# ORNAGE = EXPIRED
# GRAY = STALE
# BLUE = UPDATING
# CYAN = REVALIDATED
# GREEN = HIT
#NC = NO COLOUR

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



# necessary variables

temp="#$%!@#!@#!!%!#!!";

miss=0;
hit=0;
stale=0;
bypass=0;
expired=0;
updating=0;
revalidated=0;
total=0;




# tasks to do after the program is killed.

function _upon_termination {

        clear
        echo -e "${NORMAL}${YELLOW}=========================================================" >> $IP.log
        echo -e "${BOLD}${YELLOW}The Final Statictics" >> $IP.log
        echo -e "${NORMAL}${YELLOW}=========================================================" >> $IP.log

                                                                                                                                                                                          37,9          Top
        if [[ "$total" -ne 0 ]]
        then
                echo -ne "\n\n${BOLD}${NC} Total no. of requests = " $(echo "${total}") >> $IP.log;

                # printf "\n\n${BOLD}${RED} Miss ratio = "; 
                echo -ne "\n\n${BOLD}${RED} No. of Misses = " $(echo "${miss}") >> $IP.log;
                echo -ne "\n${BOLD}${RED} Miss ratio = " $(echo "scale=3; ${miss} * 100 / ${total}" | bc) >> $IP.log;

                # printf "\n${BOLD}${GREEN} Hit ratio = ";
                echo -ne "\n\n${BOLD}${GREEN} No. of Hits = " $(echo "${hit}") >> $IP.log;
                echo -ne "\n${BOLD}${GREEN} Hit ratio = " $(echo "scale=3; ${hit} * 100 / ${total}" | bc) >> $IP.log;

                # printf "\n${BOLD}${YELLOW} Bypass ratio = ";
                echo -ne "\n\n${BOLD}${YELLOW} No. of Bypasses = " $(echo "${bypass}") >> $IP.log;
                echo -ne "\n${BOLD}${YELLOW} Bypass ratio = " $(echo "scale=3; ${bypass} * 100 / ${total}" | bc) >> $IP.log;

                # printf "\n${BOLD}${ORANGE} Exipred ratio = ";
                echo -ne "\n\n${BOLD}${ORANGE} No. of Expired records = " $(echo "${expired}") >> $IP.log;
                echo -ne "\n${BOLD}${ORANGE} Exipred ratio = " $(echo "scale=3; ${expired} * 100 / ${total}" | bc) >> $IP.log;

                # printf "\n${BOLD}${BLUE} Updating ratio = ";
                echo -ne "\n\n${BOLD}${BLUE} No. of Updated records = " $(echo "${updating}") >> $IP.log;
                echo -ne "\n${BOLD}${BLUE} Updating ratio = " $(echo "scale=3; ${updating} * 100 / ${total}" | bc) >> $IP.log;

                # printf "\n${BOLD}${CYAN} Revalidated ratio = ";             
                echo -ne "\n\n${BOLD}${CYAN} No. of Revalidated records = " $(echo "${revalidated}") >> $IP.log;
                echo -ne "\n${BOLD}${CYAN} Revalidated ratio = " $(echo "scale=3; ${revalidated} * 100 / ${total}" | bc) >> $IP.log;

                # printf "\n${BOLD}${GRAY} Stale ratio = ";
                echo -ne "\n\n${BOLD}${GRAY} No. of Stale records = " $(echo "${stale}") >> $IP.log;
                echo -ne "\n${BOLD}${GRAY} Stale ratio = " $(echo "scale=3; ${stale} * 100 / ${total}" | bc) >> $IP.log;

        else
                echo -e "\n\n${BOLD}${CYAN}Number of requests recieved = 0"  >> $IP.log;
        fi

        echo -e ${NC}"\n\nClosing program";
        exit 0;
}


trap _upon_termination SIGINT SIGTERM SIGKILL

# getting the IP for which the logs need to obtained
echo -n "The IP for which logs are required: "
read IP

# creating a new log file
> $IP.log

while read line
do

        # temp - rid
        # temp2 - actual log data
        # temp3 - ucs
        # temp4 - source IP

        temp="$(echo ${line} | sed -e 's/.*rid=\(.*\)pck=.*/\1/')";
        temp2="${line}";
        temp3="$(echo ${line} | sed -e 's/.*ucs=\(.*\)site=.*/\1/')";
        temp4="$(echo ${line} | sed -e 's/.*src_ip=\(.*\)user=.*/\1/')";

        # converting quoted string to unquoted string -- important for comparision with strings
        temp3=$(eval printf %s $temp3);
        temp4=$(eval printf %s $temp4);

        if [ "$temp4" = "$IP" ]
        then
            
            total=$((total + 1));

            if [ "$temp3" = "MISS" ]
            then
                    miss=$((miss + 1));
                    #echo -e ${RED}$temp2;
            elif [ "$temp3" = "HIT" ]
            then
                    hit=$((hit + 1));
                    #echo -e ${GREEN}${temp2};
            elif [ "$temp3" = "BYPASS" ]
            then
                    bypass=$((bypass + 1));
                    #echo -e ${YELLOW}${temp2};
            elif [ "$temp3" = "STALE" ]
            then
                    stale=$((stale + 1));
                    #echo -e ${GRAY}${temp2};
            elif [ "$temp3" = "EXPIRED" ]
            then
                    expired=$((expired + 1));
                    #echo -e ${ORANGE}${temp2};
            elif [ "$temp3" = "REVALIDATED" ]
            then
                    revalidated=$((revalidated + 1));
                    #echo -e ${CYAN}${temp2};
            elif [ "$temp3" = "UPDATING" ]
            then
                    updating=$((updating + 1));
                    #echo -e ${BLUE}${temp2};
            fi

            echo $temp2 >> $IP.log
        fi

    echo $total. $temp

done < /data/logs/access.log

_upon_termination
                                                                                                                                                                                          154,17        Bot

