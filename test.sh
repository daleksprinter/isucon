function get_few_columns() {
  local query="select id, name from image limit 2"

  local resutl
  result=$(mysql -B --user=isucon --password=isucon --database=isubata -N -e "${query}")
  if [[ $? -eq 0 ]]; then
    local org_ifs=$IFS
    IFS=$'\n'; for row in ${result}
    do
      declare -a columns
      IFS=$'\t' read -ra columns <<< "${row}"
      id=${columns[0]}
      name=${columns[1]}
echo ${id} - ${name}
    done
    IFS=$org_ifs
  else
    echo "fail to select from mysql." 1>&2
  fi

}

get_few_columns
