function get_few_columns() {
	local query="select name, data from image where id = $1"
	result=$(mysql -B --user=isucon --password=isucon --database=isubata -N -e "${query}")
	IFS=$'\n'; 
	for row in ${result}
	do
		declare -a columns
		IFS=$'\t' read -ra columns <<< "${row}"
        	name=${columns[0]}
	        data=${columns[1]}
		echo ${data} > ${PWD}/images/${name}
	done
}

for ((i = 1; i < 1004; i++))
do
	get_few_columns ${i}
done
