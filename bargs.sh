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

hint_msg(){
    local msg=$1
    echo -e "[HINT] $msg"
}


export_env_var(){
    local var_name=$1
    local var_value=$2
    export "${var_name}=${var_value}"
    export "${var_name^^}=${var_value}"
}

check_options(){
    local options=$1
    local var_name=$2
    local var_value=$3
    local allow_empty=$4
    local valid=false
    if [[ -n $options ]]; then
        for o in $options; do
            [[ $o = "$var_value" ]] && valid=true
        done
    elif [[ -z $var_value && -n $allow_empty ]]; then
        valid=true
    elif [[ -n $var_value ]]; then
        valid=true
    fi
    echo $valid
}

usage (){
    local usage_msg=
    local i=0
    while [[ $i -lt $num_of_dicts ]]; do
        eval "d=(${dict[$i]})"
        if [[ ${d[name]} = "bargs" ]]; then
            echo -e "\nUsage: ${d[description]}\n"
        elif [[ -n ${d[name]} ]]; then
            usage_msg+="\n\t--${d[name]}~|~-${d[short]}"
            if [[ -n ${d[flag]} ]]; then
                usage_msg+="~[FLAG]"
            elif [[ -n ${d[allow_empty]} ]]; then
                usage_msg+="~[]"
            elif [[ -n ${d[default]} ]]; then
                usage_msg+="~[${d[default]}]" 
            else
                 usage_msg+="~[REQUIRED]"
            fi
            if [[ -n ${d[description]} ]]; then
                usage_msg+="~${d[description]}"
            fi
            usage_msg="$usage_msg\n"
        fi
        i=$((i+1))
    done

    echo -e "$usage_msg" | column -t -s "~"
}


check_bargs_vars(){
    bargs_vars_path=$(dirname "${BASH_SOURCE[0]}")/bargs_vars
    [[ ! -f $bargs_vars_path ]] && error_msg "Make sure bargs_vars is in the same folder as bargs.sh" no_usage
}


### Read bargs_vars
# Reads the file, saving each arg as one string in the string ${args}
# The arguments are separated with "~"
check_bargs_vars
delimiter="---"
while read -r line; do
    if [[ $line != "$delimiter" ]]; then
        arg_name=$(echo "$line"  | cut -f1 -d "=")
        arg_value=$(echo "$line" | cut -f2 -d "=" | sed "s~\"~~g" | sed "s~'~~g")
        [[ -z $str ]] && \
            str="[${arg_name}]=\"${arg_value}\"" || \
            str="${str} [${arg_name}]=\"${arg_value}\""

    elif [[ $line = "$delimiter" ]]; then
        num_of_args=$((num_of_args+1))
        [[ -n $str ]] && args="$args~$str"
        unset str
    fi        
done < "$bargs_vars_path"


### args to list of dictionaries
cut_num=1
num_of_dicts=0
declare -A dict
while [[ $cut_num -le $((num_of_args+1)) ]]; do
    arg=$(echo "${args[@]}" | cut -d "~" -f $cut_num)
    if [[ ${#arg} -gt 0 ]]; then
        dict[$num_of_dicts]=$arg
        num_of_dicts=$((num_of_dicts+1))
    fi
    cut_num=$((cut_num+1))
done


### Set arguments
# The good old 'while case shift'
declare -A d
while [[ -n $1 ]]; do
    i=0
    found=
    while [[ $i -lt $num_of_dicts ]]; do
        eval "d=(${dict[$i]})"
        case "$1" in
            -h | --help )
                usage
                export DEBUG=0
                exit 0
            ;;
            -"${d[short]}" | --"${d[name]}" )
                if [[ -z ${d[flag]} ]]; then
                    shift
                fi

                if [[ -z $1 && -z ${d[default]} ]]; then
                    # arg is empty and default is empty
                    error_msg "Empty argument \"${d[name]}\""
                elif [[ -z $1 && -n ${d[default]} ]]; then
                    # arg is empty and default is not empty
                    export_env_var "${d[name]}" "${d[default]}"
                    found=${d[name]}
                elif [[ -n $1 ]]; then
                    # arg is not empty
                    if [[ -n ${d[flag]} ]]; then
                    # it's a flag
                        export_env_var "${d[name]}" true
                    else
                    # not a flag, regular argument
                        export_env_var "${d[name]}" "$1"
                    fi
                    found=${d[name]}
                fi
            ;;
        esac
        i=$((i+1))
    done
    if [[ -z $found ]]; then
        error_msg "Unknown argument \"$1\""
    fi
    shift
done


### Final check
# If empty, use default value, otherwise arg is required
i=0
while [[ $i -lt $num_of_dicts ]]; do
    eval "d=(${dict[$i]})"
    result=$(printenv | grep "${d[name]}" | cut -f2 -d "=")
    if [[ -z $result ]]; then
        default=${d[default]}
        if [[ -n ${d[allow_empty]} || -n ${d[flag]} ]]; then
            export_env_var "${d[name]}" ""
        elif [[ -n $default ]]; then
            export_env_var "${d[name]}" "${default}"
        elif [[ -n ${d[prompt]} ]]; then
            # will not prompt if default is not empty
            hidden=
            [[ -n ${d[hidden]} ]] && hidden=s
            prompt_value=
            while :; do
                echo -n "${d[name]^^}: "
                read -re${hidden} prompt_value
                [[ -n $hidden ]] && echo ""
                if [[ -n ${d[confirmation]} ]]; then
                    while :; do
                        confirm_value=
                        echo -n "${d[name]^^} Confirmation: "
                        read -re${hidden} confirm_value
                        [[ -n $hidden ]] && echo ""
                        [[ $prompt_value = "$confirm_value" ]] && break
                    done
                fi
                valid=$(check_options "${d[options]}" "${d[name]}" "$prompt_value" "${d[allow_empty]}")
                if [[ $valid = "true" ]]; then
                    [[ -n ${d[hidden]} ]] && echo ""
                    break
                else
                    [[ -n ${d[options]} ]] && hint_msg "Valid options: ${d[options]}"
                fi
            done
            export_env_var "${d[name]}" "${prompt_value}"
        elif [[ -z $default ]]; then
            error_msg "Required argument: ${d[name]}"
        fi
    elif [[ -n $result ]]; then
        valid=$(check_options "${d[options]}" "${d[name]}" "$result" "${d[allow_empty]}")
        if [[ $valid != "true" ]]; then
            hint_msg "Valid options: ${d[options]}" 
            error_msg "Invalid value \"${result}\" for the argument \"${d[name]}\""
        fi
        : # argument is valid
    fi
    i=$((i+1))
done
