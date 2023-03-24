#!/bin/bash

show_menu(){
    normal=`echo "\033[m"`
    menu=`echo "\033[36m"` #Blue
    ##number=`echo "\033[36m"` #Blue
	#number=`echo "\033[33m"` #yellow
    fgred=`echo "\033[31m"` #Red
    printf "\n${menu}*********************************************${normal}\n"
    printf "${menu}**${menu} 1)${menu} DEV ${normal}\n"
    printf "${menu}**${menu} 2)${menu} SIT ${normal}\n"
    printf "${menu}**${menu} 3)${menu} Pre-Production Montreal ${normal}\n"
    printf "${menu}**${menu} 4)${menu} Pre-Production Oregon ${normal}\n"
    printf "${menu}**${menu} 5)${menu} Production Montreal ${normal}\n"
    printf "${menu}**${menu} 6)${menu} Production Oregon ${normal}\n"
    printf "${menu}*********************************************${normal}\n"
    printf "Please enter an environment option and enter or ${fgred}x to exit. ${normal}"
    read opt
}

menu_option(){
    msgcolor=`echo "\033[01;31m"` # bold red
    normal=`echo "\033[00;00m"` # normal white
    message=${@:-"${normal}Error: No message passed"}
    printf "${msgcolor}${message}${normal}\n"
}

show_menu

if [ $opt != '' ];
then
    if [ $opt = '' ]; then
      exit;
    else
        case $opt in
            1)  menu_option "Connecting to GKE in DEV"
        	    gcloud container clusters get-credentials opus-avs-gke-we1-dv --region us-west1 --project cto-opus-middleware-dv-77ef40
                ;;
             
            2)  menu_option "Connecting to GKE in SIT"
        	    gcloud container clusters get-credentials opus-avs-gke-we1-sit --region us-west1 --project cto-middleware-sit-f4b01c
                ;;
             
            3)  menu_option "Connecting to GKE in Pre-Production (Montreal)"
        	    gcloud container clusters get-credentials opus-avs-gke-ne1-preprod --region northamerica-northeast1 --project cto-opus-middleware-np-acce16
                ;;
        		
            4)  menu_option "Connecting to GKE in Pre-Production (Oregon)"
        	    gcloud container clusters get-credentials opus-avs-gke-we1-preprod --region us-west1 --project cto-middleware-oregon-np-9c44
                ;;
        		
            5)  menu_option "Connecting to GKE in Production (Montreal)"
        	    gcloud container clusters get-credentials opus-avs-gke-ne1-prod --region northamerica-northeast1 --project cto-opus-middleware-pr-6c2537
                ;;
        		
            6)  menu_option "Connecting to GKE in Production (Oregon)"
        	    gcloud container clusters get-credentials opus-avs-gke-we1-prod --region us-west1 --project cto-middleware-oregon-pr-252a
                ;;
        		
            x)exit;
                ;;
            \n) exit;
                ;;
            *) menu_option "Choose an option from the menu";
               show_menu; 
        esac
	fi
fi
