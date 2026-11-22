#!/usr/bin/env sh


#// set variables

export scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"
export thmbDir
export dcolDir

[ -d "${hydeThemeDir}" ] && cacheIn="${hydeThemeDir}" || exit 1
[ -d "${thmbDir}" ] || mkdir -p "${thmbDir}"
[ -d "${dcolDir}" ] || mkdir -p "${dcolDir}"
[ -d "${cacheDir}/landing" ] || mkdir -p "${cacheDir}/landing"

if [ ! -z "${wallbashCustomCurve}" ] && [[ "${wallbashCustomCurve}" =~ ^([0-9]+[[:space:]][0-9]+\\n){8}[0-9]+[[:space:]][0-9]+$ ]] ; then
    export wallbashCustomCurve
    echo ":: wallbash --custom \"${wallbashCustomCurve}\""
else
    export wallbashCustomCurve="32 50\n42 46\n49 40\n56 39\n64 38\n76 37\n90 33\n94 29\n100 20"
fi


#// define functions

# Thumbnails are always written as PNG (the png: prefix). Some ImageMagick
# 7.1.2 builds write unreadable JPEGs, and .thmb kept the input's format, so
# every .jpg wallpaper silently lost its colours. Unreadable thumbnails and
# missing/incomplete colour files are rebuilt; wallbash errors go to
# ~/.cache/hyde/wallbash.log instead of being thrown away.

fn_img_ok()
{
    [ -s "${1}" ] && magick identify -quiet "${1}" > /dev/null 2>&1
}

fn_wallcache()
{
    local x_hash="${1}"
    local x_wall="${2}"
    local force="${3:-}"
    local t="${thmbDir}/${x_hash}"
    local d="${dcolDir}/${x_hash}"
    local log="${cacheDir}/wallbash.log"

    { [ -n "${force}" ] || ! fn_img_ok "${t}.thmb" ;} && magick "${x_wall}"[0] -strip -resize 1000 -gravity center -extent 1000 png:"${t}.thmb"
    { [ -n "${force}" ] || ! fn_img_ok "${t}.sqre" ;} && magick "${x_wall}"[0] -strip -thumbnail 500x500^ -gravity center -extent 500x500 png:"${t}.sqre"
    { [ -n "${force}" ] || ! fn_img_ok "${t}.blur" ;} && magick "${x_wall}"[0] -strip -scale 10% -blur 0x3 -resize 100% png:"${t}.blur"
    { [ -n "${force}" ] || ! fn_img_ok "${t}.quad" ;} && magick "${t}.sqre" \( -size 500x500 xc:white -fill "rgba(0,0,0,0.7)" -draw "polygon 400,500 500,500 500,0 450,0" -fill black -draw "polygon 500,500 500,0 450,500" \) -alpha Off -compose CopyOpacity -composite png:"${t}.png" && mv "${t}.png" "${t}.quad"

    if [ -n "${force}" ] || [ ! -e "${d}.dcol" ] || [ "$(wc -l < "${d}.dcol")" -ne 89 ] ; then
        echo "== $(date '+%F %T') ${x_wall}" >> "${log}"
        "${scrDir}/wallbash.sh" --custom "${wallbashCustomCurve}" "${t}.thmb" "${d}" >> "${log}" 2>&1
        # fall back to the original image if the thumbnail didn't work
        if [ ! -e "${d}.dcol" ] || [ "$(wc -l < "${d}.dcol")" -ne 89 ] ; then
            echo "   retrying with the original image" >> "${log}"
            "${scrDir}/wallbash.sh" --custom "${wallbashCustomCurve}" "${x_wall}" "${d}" >> "${log}" 2>&1
        fi
    fi
}

fn_wallcache_force()
{
    fn_wallcache "${1}" "${2}" force
}

export -f fn_img_ok
export -f fn_wallcache
export -f fn_wallcache_force


#// evaluate options

while getopts "w:t:f" option ; do
    case $option in
    w ) # generate cache for input wallpaper
        if [ -z "${OPTARG}" ] || [ ! -f "${OPTARG}" ] ; then
            echo "Error: Input wallpaper \"${OPTARG}\" not found!"
            exit 1
        fi
        cacheIn="${OPTARG}"
        ;;
    t ) # generate cache for input theme
        cacheIn="$(dirname "${hydeThemeDir}")/${OPTARG}"
        if [ ! -d "${cacheIn}" ] ; then
            echo "Error: Input theme \"${OPTARG}\" not found!"
            exit 1
        fi
        ;;
    f ) # full cache rebuild
        cacheIn="$(dirname "${hydeThemeDir}")"
        mode="_force"
        ;;
    * ) # invalid option
        echo "... invalid option ..."
        echo "$(basename "${0}") -[option]"
        echo "w : generate cache for input wallpaper"
        echo "t : generate cache for input theme"
        echo "f : full cache rebuild"
        exit 1 ;;
    esac
done


#// generate cache

wallPathArray=("${cacheIn}")
wallPathArray+=("${wallAddCustomPath[@]}")
get_hashmap "${wallPathArray[@]}"
parallel --bar --link "fn_wallcache${mode}" ::: "${wallHash[@]}" ::: "${wallList[@]}"
exit 0
