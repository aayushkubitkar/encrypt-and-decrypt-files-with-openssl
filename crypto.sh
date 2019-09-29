#!/bin/bash
set -e
encrypt()
{
	 r_pub_key=$1
	 s_priv_key=$2
	 p_file=$3
	 e_file=$4
	 #echo "In encrypt function"
	 
	 workdir=`pwd`
	 touch rand.session.key
	 # generate 32 bit random session key
	 openssl rand -base64 32 > rand.session.key

	 touch file.enc
	 #symmetric encryption using AES 256
	 openssl enc -aes-256-cbc -A -in $3 -out file.enc -pass file:./rand.session.key -salt

	 touch session.key.enc
	 #Asymmetric encryption session key with receiver's public key
	 openssl rsautl -encrypt -pubin -inkey $1 -in rand.session.key -out session.key.enc
	 rm rand.session.key

	 #zip the session key and encryted file
	 tar -czvf file.tar.gz session.key.enc file.enc
	 rm session.key.enc file.enc

	 touch file.dgst
	 #Sign the tar file with senders public key using sha256 
	 openssl dgst -sha256 -sign $2 -out file.dgst file.tar.gz

	 #zip the digest and the original message
	 tar -czvf $4 file.dgst file.tar.gz
	 rm file.dgst file.tar.gz

}
decrypt()
{
	 r_priv_key=$1
	 s_pub_key=$2
	 e_file=$3
	 p_file=$4
	 #echo "in decrypt function"
	 touch ver_status
	 tar -xvf $3
	 #verify the digest with the original message
	 openssl dgst -sha256 -verify $2 -signature file.dgst file.tar.gz  > ver_status
	 #check if the file was successfullly verified
	 if grep -Fiq "OK" ver_status ; then
	  	#echo "verified"
	  	tar -xvf file.tar.gz
	  	touch decrypted.session.key
	  	#decrypt the session key with the receivers private key
      	openssl rsautl -decrypt -inkey $1 -in session.key.enc -out decrypted.session.key
      	#decrypt the encrypted file with session key
	  	openssl enc -aes-256-cbc -d -A -in file.enc -out $4 -pass file:./decrypted.session.key -salt
	  	rm file.tar.gz file.dgst file.enc session.key.enc decrypted.session.key ver_status
	 else
	 	echo "signature not verified"
	 	echo "Original message and the digest do not match"
	 fi
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
    if [ -f "$1" -a -f "$2" -a -f "$3" ]; then #checking if the files passed as argument exists or not
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

