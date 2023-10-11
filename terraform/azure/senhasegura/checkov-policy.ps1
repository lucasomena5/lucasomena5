Param ([switch]$interactive)



$currentRelease = (Invoke-RestMethod https://api.github.com/repos/bridgecrewio/checkov/releases)[0].tag_name

$version = $currentRelease

$appname=(dir)[0].Parent

$appdir="/tmp/"+$appname

$reportpath="/tmp/"+$appname+"/checkov"

$reportname = "checkov"



if ($interactive) {

    docker run -it --rm -v ${pwd}:${appdir} --workdir ${appdir} --entrypoint /bin/bash bridgecrew/checkov:${version}

}

else {

    echo "docker run --rm -v ${pwd}:${appdir} --workdir ${appdir}  bridgecrew/checkov:${version} -d ${appdir} -o cli -o json --output-file-path ${reportname} --quiet"

    docker run --rm -v ${pwd}:${appdir} --workdir ${appdir} bridgecrew/checkov:${version} -d ${appdir} -o cli -o json --output-file-path ${reportname} --quiet

    echo "docker run --rm -v ${pwd}:${appdir} --workdir ${appdir} bridgecrew/checkov:${version} -d ${appdir} -o cli -o json --output-file-path ${reportname} --quiet"

}