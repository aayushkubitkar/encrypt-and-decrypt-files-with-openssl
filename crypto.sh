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
}

if [[ $# -eq 5 ]]; then
  while getopts "he:d:" options; do
    case ${options} in
	 	e) 
	 	  encrypt $2 $3 $4 $5
		  ;;
		d) 
	      decrypt $2 $3 $4 $5 
		  ;;
		*) 
		  usage
		  ;;
	esac
  done
else
	usage
fi

