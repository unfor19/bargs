#!/bin/bash
error_msg(){
    local msg=$1
    echo -e "[ERROR] $1"
    usage
}

delimiter="---"
while read -r line; do
    if [[ "$line" != "${delimiter}" ]]; then
        arg_name=$(echo "$line"  | cut -f1 -d "=")
        arg_value=$(echo "$line" | cut -f2 -d "=")
        [[ -z $str ]] && \
            str="[${arg_name}]=\"${arg_value}\"" || \
            str="${str} [${arg_name}]=\"${arg_value}\""

    elif [[ "$line" == "${delimiter}" ]]; then
        num_of_args=$((num_of_args+1))
        [[ ! -z $str ]] && args="$args~$str"
        unset str
    fi        
done < variables

cut_num=1
num_of_dicts=0
declare -A dict
while [ $cut_num -le $(($num_of_args+1)) ]; do
    arg=$(echo "${args[@]}" | cut -d "~" -f $cut_num)
    if [[ ${#arg} -gt 0 ]]; then
        dict[$num_of_dicts]="$arg"
        num_of_dicts=$(($num_of_dicts+1))
    fi
    cut_num=$((cut_num+1))
done

usage (){
    local usage_msg=
    local i=0
    while [ $i -lt $num_of_dicts ]; do
        eval "d=(${dict[$i]})"
        if [[ "${d[name]}" == "bargs" ]]; then
            echo -e "\nUsage: ${d[description]}\n"
            # echo -e "Long~|~Short~|~Default~|~Description" | column -t -s "~"
        elif [[ ! -z "${d[name]}" ]]; then
            usage_msg="$usage_msg\n--${d[name]}~|~-${d[short]}"
            [[ ! -z "${d[default]}" ]] && \
                usage_msg="$usage_msg~[${d[default]}]" \
                || usage_msg="$usage_msg~[Required]"
            [[ ! -z "${d[description]}" ]] && \
                usage_msg="$usage_msg~${d[description]}"
            
            usage_msg="$usage_msg\n"
        fi
        i=$((i+1))
    done

    echo -e "$usage_msg" | column -t -s "~"
    exit 0
}


declare -A d
i=0
if [[ -z "$1" ]]; then
    while [ $i -lt $num_of_dicts ]; do
        eval "d=(${dict[$i]})"
        eval "export ${d[name]}=${d[default]}"
        i=$((i+1))
    done
fi
while [ "$1" != "" ]; do
    i=0
    found=
    while [ $i -lt $num_of_dicts ]; do
        eval "d=(${dict[$i]})"
        case "$1" in
            -${d[short]} | --${d[name]} )
                shift
                if [[ -z "$1" && -z "${d[default]}" ]]; then
                    error_msg "Empty argument: ${d[name]}"
                    usage
                elif [[ -z "$1" ]]; then
                    eval "export ${d[name]}=${d[default]}"
                    found="${d[name]}"
                else
                    eval "export ${d[name]}=$1"
                    found="${d[name]}"
                fi
            ;;
            -h | --help )
                usage
            ;;
        esac
        i=$((i+1))
    done
    if [[ -z $found ]]; then
        echo -e "[ERROR] Unknown argument: $1"
        usage
    fi    
    shift
done
