query='select id, name from image limit 2'
cmd="mysql -B -u isucon -pisucon -D isubata -N -e '${query}'"
rows=(`eval $cmd`)
echo ${rows[@]}

IFS=$'\n'
for row in "${rows[@]}"
do
	echo "${row} hoge"
	declare -a columns
	read -ra columns <<< "${row}"
done
