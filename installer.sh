#!/bin/bash
YES_ANSWER=1
NO_ANSWER=2
QUIT_ANSWER=3
parse_user_input()
{
  if [ "$1" = "0" ] && [ "$2" = "0" ] && [ "$3" = "0" ]; then
    return
  fi
  while [ true ]; do
    Options="["
    if [ "$1" = "1" ]; then
      Options="${Options}y"
      if [ "$2" = "1" ] || [ "$3" = "1" ]; then
        Options="$Options/"
      fi
    fi
    if [ "$2" = "1" ]; then
      Options="${Options}n"
      if [ "$3" = "1" ]; then
        Options="$Options/"
      fi
    fi
    if [ "$3" = "1" ]; then
      Options="${Options}quit"
    fi
    Options="$Options]"
    read -p "$Options >> " USER_RESPONSE
    USER_RESPONSE=$(echo $USER_RESPONSE | awk '{print tolower($0)}')
    if [ "$USER_RESPONSE" = "y" ] && [ "$1" = "1" ]; then
      return $YES_ANSWER
    else
      if [ "$USER_RESPONSE" = "n" ] && [ "$2" = "1" ]; then
        return $NO_ANSWER
      else
        if [ "$USER_RESPONSE" = "quit" ] && [ "$3" = "1" ]; then
          printf "\nGoodbye.\n\n"
          exit
        fi
      fi
    fi
    printf "Please enter a valid response.\n"
  done
}

select_option()
{
  local _result=$1
  local ARGS=("$@")
  if [ "$#" -gt 0 ]; then
    while [ true ]; do
      local count=1
      for option in "${ARGS[@]:1}"; do
        echo "$count) $option"
        ((count+=1))
      done
      echo ""
      local USER_RESPONSE
      read -p "Please select an option [1-$(($#-1))] " USER_RESPONSE
      case $USER_RESPONSE in
        ''|*[!0-9]*) echo "Please provide a valid number"
        continue
        ;;
        *) if [[ "$USER_RESPONSE" -gt 0 && $((USER_RESPONSE+1)) -le "$#" ]]; then
          local SELECTION=${ARGS[($USER_RESPONSE)]}
          echo "Selection: $SELECTION"
          eval $_result=\$SELECTION
          return
        else
          clear
          echo "Please select a valid option"
        fi
        ;;
      esac
    done
  fi
}

clear
echo "=============Starting Assistant Installer=============="
echo ""
echo "From the list below, choose your option for installation: "
select_option assistants Google-Assistant Alexa Both
echo ""
if [ "$assistants" = "Both" ]; then
  echo "You have chosen to install both Google Assistant and Alexa"
else
  echo "You have chosen to install $assistants"
fi

case $assistants in
  Alexa)
    git clone https://github.com/shivasiddharth/alexa-avs-sample-app
    echo ""
    echo ""
    read -r -p "Enter the Product Id given in the Amazon Developer portal: " productid
    echo ""
    read -r -p "Enter the Client Id given in the Amazon Developer portal: " clientid
    echo ""
    read -r -p "Enter the Client Secret given in the Amazon Developer portal: " clientsecret
    echo ""

    ProductID=$productid
    ClientID=$clientid
    ClientSecret=$clientsecret
    
    # Select a Locale
    clear
    echo "==== Setting Locale ====="
    echo ""
    echo ""
    echo "Which locale would you like to use?"
    echo ""
    echo ""
    echo "======================================================="
    echo ""
    echo ""
    select_option Locale "en-US" "en-GB" "de-DE" "en-CA" "en-IN" "ja-JP"
   
    echo '*****************************'
    echo '========= Finished Installing Alexa =========='
    echo '*****************************'
    echo '============================='
    echo ""
    echo ""
    Number_Terminals=2
    if [ "$Wake_Word_Detection_Enabled" = "true" ]; then
      Number_Terminals=3
    fi
    echo "================Run the Alexa demo to authenticate============"
    echo "To run the demo, do the following in $Number_Terminals seperate terminals:"
    echo "Run the companion service: cd $Companion_Service_Loc && sudo npm start"
    echo "Run the AVS Java Client: cd $Java_Client_Loc && sudo mvn exec:exec"
    if [ "$Wake_Word_Detection_Enabled" = "true" ]; then
      echo "Run the wake word agent: "
      echo "  KITT_AI: cd $Wake_Word_Agent_Loc/src && sudo ./wakeWordAgent -e kitt_ai"
    fi
    echo ""
    echo "After that, proceed to step-9 mentioned in the README doc to set the assitsants to auto start on boot."
    exit
    ;;
  Google-Assistant)
  echo "Have you downloaded the credentials file, and placed it in /home/pi/ directory?"
  parse_user_input 1 1 0
  USER_RESPONSE=$?
  if [ "$USER_RESPONSE" = "$YES_ANSWER" ]; then
    echo "=============Starting Google Assistant Installer============="
    git clone https://github.com/shivasiddharth/GassistPi -b Gassistant-RPi
    if [[ "$(uname -m)" == "armv7l" ]] ; then
      sudo chmod +x /home/pi/Assistants-Pi/scripts/gassist-installer-pi3.sh
      sudo /home/pi/Assistants-Pi/scripts/gassist-installer-pi3.sh
    else
      sudo chmod +x /home/pi/Assistants-Pi/scripts/gassist-installer-pi-zero.sh
      sudo /home/pi/Assistants-Pi/scripts/gassist-installer-pi-zero.sh
    fi
    sudo apt-get install npm -y
    echo ""
    echo "Finished installing Google Assistant....."
  elif ["$USER_RESPONSE" = "$NO_ANSWER" ]; then
    echo "Download the credentials file, , place it in /home/pi/ directory and start the installer again.."
    exit
  fi

  echo ""
  echo "===============Run Google Assistant demo==========="
  echo "To run the google assistant demo"
  echo "Open a new terminal and execute: "
  echo "source env/bin/activate"
  echo "Test the installed google assistant using the following syntax. Replace 'project-id' and 'model-id'with your respective ids "
  echo ""
  echo "=============================For Pi 2B and Pi 3B======================================"
  echo "googlesamples-assistant-hotword --project_id 'project-id' --device_model_id 'model-id'"
  echo ""
  echo "=================================For Pi Zero=========================================="
  echo "googlesamples-assistant-pushtotalk --project_id 'project-id' --device_model_id 'project-id'"
  echo ""
  echo "After that, proceed to step-9 mentioned in the README doc to set the assitsants to auto start on boot."
  exit
    ;;
  Both)
    git clone https://github.com/shivasiddharth/alexa-avs-sample-app
    echo ""
    echo ""
    read -r -p "Enter the Product Id given in the Amazon Developer portal: " productid
    echo ""
    read -r -p "Enter the Client Id given in the Amazon Developer portal: " clientid
    echo ""
    read -r -p "Enter the Client Secret given in the Amazon Developer portal: " clientsecret
    echo ""

    ProductID=$productid
    ClientID=$clientid
    ClientSecret=$clientsecret
    
    # Select a Locale
    clear
    echo "==== Setting Locale ====="
    echo ""
    echo ""
    echo "Which locale would you like to use?"
    echo ""
    echo ""
    echo "======================================================="
    echo ""
    echo ""
    select_option Locale "en-US" "en-GB" "de-DE" "en-CA" "en-IN" "ja-JP"
    
    echo '============================='
    echo '*****************************'
    echo '========= Finished Installing Alexa =========='
    echo '*****************************'
    echo '============================='
    echo ""
    Number_Terminals=2
    if [ "$Wake_Word_Detection_Enabled" = "true" ]; then
      Number_Terminals=3
    fi
    echo "Have you downloaded the credentials file, and placed it in /home/pi/ directory?"
    parse_user_input 1 1 0
    USER_RESPONSE=$?
    if [ "$USER_RESPONSE" = "$YES_ANSWER" ]; then
      echo "=============Starting Google Assistant Installer============="
      git clone https://github.com/shivasiddharth/GassistPi -b Gassistant-RPi
      if [[ "$(uname -m)" == "armv7l" ]] ; then
        sudo chmod +x /home/pi/Assistants-Pi/scripts/gassist-installer-pi3.sh
        sudo /home/pi/Assistants-Pi/scripts/gassist-installer-pi3.sh
      else
        sudo chmod +x /home/pi/Assistants-Pi/scripts/gassist-installer-pi-zero.sh
        sudo /home/pi/Assistants-Pi/scripts/gassist-installer-pi-zero.sh
      fi
      sudo apt-get install npm -y
      echo ""
      echo "Finished installing Google Assistant....."
    elif ["$USER_RESPONSE" = "$NO_ANSWER" ]; then
      echo "Download the credentials file, , place it in /home/pi/ directory and start the installer again.."
      exit
    fi

    echo ""
    echo ""
    echo "================Run the Alexa demo to authenticate============"
    echo "To run the demo, do the following in $Number_Terminals seperate terminals:"
    echo "Run the companion service: cd $Companion_Service_Loc && sudo npm start"
    echo "Run the AVS Java Client: cd $Java_Client_Loc && sudo mvn exec:exec"
    if [ "$Wake_Word_Detection_Enabled" = "true" ]; then
      echo "Run the wake word agent: "
      echo "  KITT_AI: cd $Wake_Word_Agent_Loc/src && sudo ./wakeWordAgent -e kitt_ai"
    fi
    echo ""
    echo ""
    echo "===============Run Google Assistant demo==========="
    echo "To run the google assistant demo"
    echo "Open a new terminal and execute: "
    echo "source env/bin/activate"
    echo "Test the installed google assistant using the following syntax. Replace 'project-id' and 'model-id'with your respective ids "
    echo ""
    echo "=============================For Pi 2B and Pi 3B======================================"
    echo "googlesamples-assistant-hotword --project_id 'project-id' --device_model_id 'model-id'"
    echo ""
    echo "=================================For Pi Zero=========================================="
    echo "googlesamples-assistant-pushtotalk --project_id 'project-id' --device_model_id 'project-id'"
    echo ""
    echo "After that, proceed to step-9 mentioned in the README doc to set the assitsants to auto start on boot."
    exit
    ;;
esac
