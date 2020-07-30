#!/bin/bash

### Functions
error_msg(){
    local msg=$1
    local no_usage=$2
    echo -e "[ERROR] $msg"
    [[ -z $no_usage ]] && usage
    export DEBUG=1
    exit 1
}


usage (){
    local usage_msg=
    local i=0
    while [ $i -lt "$num_of_dicts" ]; do
        eval "d=(${dict[$i]})"
        if [[ "${d[name]}" == "bargs" ]]; then
            echo -e "\nUsage: ${d[description]}\n"
        elif [[ -n "${d[name]}" ]]; then
            usage_msg="$usage_msg\n\t--${d[name]}~|~-${d[short]}"
            [[ -n "${d[default]}" ]] && \
                usage_msg="$usage_msg~[${d[default]}]" \
                || usage_msg="$usage_msg~[Required]"
            [[ -n "${d[description]}" ]] && \
                usage_msg="$usage_msg~${d[description]}"
            
            usage_msg="$usage_msg\n"
        fi
        i=$((i+1))
    done

    echo -e "$usage_msg" | column -t -s "~"
}

check_bargs_vars(){
    bargs_vars_path="$(dirname "${BASH_SOURCE[0]}")"/bargs_vars
    [[ ! -f "$bargs_vars_path" ]] && error_msg "Make sure bargs_vars is in the same folder as bargs.sh" no_usage
}


### Read bargs_vars
# Reads the file, saving each arg as one string in the string ${args}
# The arguments are separated with "~"
check_bargs_vars
delimiter="---"
while read -r line; do
    if [[ "$line" != "${delimiter}" ]]; then
        arg_name=$(echo "$line"  | cut -f1 -d "=")
        arg_value=$(echo "$line" | cut -f2 -d "=" | sed "s~\"~~g" | sed "s~'~~g")
        [[ -z $str ]] && \
            str="[${arg_name}]=\"${arg_value}\"" || \
            str="${str} [${arg_name}]=\"${arg_value}\""

    elif [[ "$line" == "${delimiter}" ]]; then
        num_of_args=$((num_of_args+1))
        [[ -n $str ]] && args="$args~$str"
        unset str
    fi        
done < "$bargs_vars_path"


### args to list of dictionaries
cut_num=1
num_of_dicts=0
declare -A dict
while [ $cut_num -le $((num_of_args+1)) ]; do
    arg=$(echo "${args[@]}" | cut -d "~" -f $cut_num)
    if [[ ${#arg} -gt 0 ]]; then
        dict[$num_of_dicts]="$arg"
        num_of_dicts=$((num_of_dicts+1))
    fi
    cut_num=$((cut_num+1))
done


### Set arguments
# The good old 'while case shift'
declare -A d
while [ "$1" != "" ]; do
    i=0
    found=
    while [ $i -lt $num_of_dicts ]; do
        eval "d=(${dict[$i]})"
        case "$1" in
            -h | --help )
                usage
                export DEBUG=0
                exit 0
            ;;        
            -"${d[short]}" | --"${d[name]}" )
                shift
                if [[ -z "$1" && -z "${d[default]}" ]]; then
                    # arg is empty and default is empty
                    error_msg "Empty argument: ${d[name]}"
                elif [[ -z "$1" && -n "${d[default]}" ]]; then
                    # arg is empty and default is not empty
                    export "${d[name]}"="${d[default]}"
                    export "${d[name]^^}"="${d[default]}"
                    found="${d[name]}"
                elif [[ -n "$1" ]]; then
                    # arg is not empty, validating value
                    if [[  -n ${d[options]} ]]; then
                        valid=
                        for o in ${d[options]}; do
                            [[ "$o" == "$1" ]] && valid=true
                        done
                        [[ $valid != true ]] && error_msg "Invalid value for argument: ${d[name]}"
                    fi
                    export "${d[name]}"="$1"
                    export "${d[name]^^}"="$1"
                    found="${d[name]}"
                fi
            ;;
        esac
        i=$((i+1))
    done
    if [[ -z $found ]]; then
        error_msg "Unknown argument: $1"
    fi
    shift
done

### Final check
# If empty, use default value, otherwise arg is required
i=0
while [ $i -lt $num_of_dicts ]; do
    eval "d=(${dict[$i]})"
    result=$(printenv | grep "${d[name]}" | cut -f2 -d "=")
    default="${d[default]}"
    if [[ -z $result && -z $default ]]; then
        error_msg "Required argument: ${d[name]}"
    elif [[ -z $result && -n $default ]]; then
        export "${d[name]}"="${d[default]}"
        export "${d[name]^^}"="${d[default]}"
    fi
    i=$((i+1))
done
