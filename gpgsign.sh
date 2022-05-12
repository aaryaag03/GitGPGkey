#!/bin/bash
echo "SET 
1.Use existing GPG key to change
2.Generate new GPG key"
read n
if [[ $n -eq 1 ]]
then 

declare -a key=()
declare -a name=()
j=0

sec=$(gpg --list-secret-keys --keyid-format=long | awk '/sec/{if (length($2)>0) print $2}')
uid=$(gpg --list-secret-keys --keyid-format=long | awk '/uid/')
n1=${#sec}
n2=${#uid}


for((i=0;i<$n1;i++));
do
    if [[ ${sec:$i:1} == "/" ]]
    then 
        key[$j]=${sec:$i+1:16} 
        ((j++))
        echo ${key[$j-1]}
        
    fi
done


j=0
index=0

for((i=0;i<$n2;i++));
do
    if [[ ${uid:$i:1} == ")" ]]
    then 
        name[$j]=${uid:$index:$i-$index+1}
        ((index=i+2))
        ((j++))
    fi
done

echo "Choose one key:"

for((i=0;i<$j;i++));
do
    echo "$((i+1)) ${name[$i]}"
done
read x

if [[ $x -le $j ]]
then
    c="gpg --armor --export "${key[$x-1]}""
    $c
 

else
    echo "invalid input"

fi
cc="git config --global user.signingkey "${key[$x-1]}""
    $cc
elif [[ $n -eq 2 ]]
then 
    gpg --full-generate-key
    echo "your key has been generated"
    bash gpgsign.sh

else
    echo "Please enter a valid number"

fi

