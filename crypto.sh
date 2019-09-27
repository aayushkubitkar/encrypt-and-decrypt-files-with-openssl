#!/bin/bash

encrypt()
{
	 r_pub_key=$1
	 s_priv_key=$2
	 p_file=$3
	 e_file=$4
	 echo "in encrypt function $r_pub_key, $s_priv_key, $p_file, $e_file"

}
decrypt()
{
	 r_priv_key=$1
	 s_pub_key=$2
	 e_file=$3
	 p_file=$4
	 echo "in decrypt function"
}
usage()
{
	err=$1
	if [ "$err" == "help" ]; then 
		echo -e "Usage: \n Encryption:"
		echo "  ./crypto.sh [-e] [receiver_public_key_file] [sender_private_key_file] [plaintext_file] [encrypted_file]"
		echo " Decryption: "
		echo "  ./crypto.sh [-d] [receiver_private_key_file[ [sender_public_key_file] [encrypted_file] [decrypted_file]"
	elif  [ "$err" == "number of args" ]; then
		args=$2
		echo "Arguments found $args : Arguments required 4"
	elif [ "$err" == "invalid file" ]; then
		echo "File does not exist"
	elif [ "$err" == "invalid option" ]; then
		echo -e "Invalid option used! \n Usage : script [-e] | [-d]"
	elif [ "$err" == "no option" ]; then
		echo -e "No option specified! \n Usage : script [-e] | [-d]"
	fi
	exit 1;
}

operation=""
  while getopts ":hed" options; do
    case ${options} in
	 	e ) 
	 	  operation="e"
	 	  ;;
		d ) 
	 	  operation="d"
		  ;;
		h ) 
		  usage "help"
		  ;;
		? )
		  usage "invalid option" 
		  ;;
	esac
  done
if [ $((OPTIND-1)) -eq 0 ]; then
	usage "no option"
fi  
shift "$((OPTIND -1))"
if [ "$#" -eq 4 ]; then #checking the number of arguments 
    if [ -f $1 -a -f $2 -a -f $3 -a -f $4 ]; then #checking if all the files passed as argument exists or not
       if [ "$operation" == "e" ]; then
       	encrypt $1 $2 $3 $4
       elif [ "$operation" == "d" ]; then
       	decrypt $1 $2 $3 $4
       fi
	else
		usage "invalid file"
	fi
else
    usage "number of args" "$#"
fi

