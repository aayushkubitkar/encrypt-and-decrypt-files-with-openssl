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
	echo -e "Usage: \n Encryption:"
	echo "  ./crypto.sh -e <receiver_public_key_file> <sender_private_key_file> <plaintext_file> <encrypted_file>"
	echo " Decryption: "
	echo "  ./crypto.sh -d <receiver_private_key_file> <sender_public_key_file> <encrypted_file> <decrypted_file>"
	exit 1;
}

if [[ $# -eq 5 ]]; then
  while getopts "he:d:" options; do
    case ${options} in
	 	e) 
	 	  if [ -f $2 -a -f $3 -a -f $4 -a -f $5 ]; then
	 	   encrypt $2 $3 $4 $5
          else
          	echo "argument passed is not a file!"
          fi
		  ;;
		d) 
	      if [ -f $2 -a -f $3 -a -f $4 -a -f $5 ]; then
	       decrypt $2 $3 $4 $5
	      else
	       echo "argument passed is not a file!" 
	      fi 
		  ;;
		h | *) 
		  usage
		  ;;
	esac
  done
else
	usage
fi

