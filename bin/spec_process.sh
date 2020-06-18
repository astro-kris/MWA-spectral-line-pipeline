#! /bin/bash

#! /bin/bash

usage()
{
echo "spec_process.sh [-p project] [-a account] obsnum
  -a account : computing account, default pawsey0280
  -p project : project, (must be specified, no default)
  obsnum     : the obsid to spec_process" 1>&2;
exit 1;
}

scratch="/astro"
group="/group"

# parse args and set options
while getopts ':p:a:' OPTION
do
    case "$OPTION" in
    a)
        account=${OPTARG}
        ;;
    p)
        project=${OPTARG}
        ;;
    ? | : | h)
        usage
        ;;
  esac
done
# set the obsid to be the first non option
shift  "$(($OPTIND -1))"
obsnum=$1

if [[ -z ${obsnum} ]] || [[ -z $project ]]
then
    usage
fi

if [[ -z ${account} ]]
then
    account=pawsey0280
fi

base="$scratch/mwasci/$USER/$project/"
code="$group/mwasci/$USER/MWA-spectral-line-pipeline/"
script="${code}queue/spec_process_${obsnum}.sh"

cat ${code}/bin/chain.tmpl | sed -e "s:OBSNUM:${obsnum}:g" \
                                 -e "s:PROJECT:${project}:g" \
                                 -e "s:ACCOUNT:${account}:g" \
                                  > ${script}

chmod +x ${script}
${script}
