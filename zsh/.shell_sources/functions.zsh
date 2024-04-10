# do a exec zsh to re-source this file
swap(){
    local TMPFILE=tmp.$$
    sudo mv "$1" $TMPFILE
    sudo mv "$2" "$1"
    sudo mv $TMPFILE "$2"
}

sizeof(){
    sudo du -h -c "$1" | grep "total"
}

mkcdir(){
    mkdir -p -- "$1" &&
      cd -P -- "$1" }

nojobs(){
    kill $(jobs -p)
	len=$(jobs | wc -l)

	while ((len > 0)); do
		echo $len
		fg %$len
		((len--))
	done

	reset
}

getline(){
    grep -n $1 $2 | head -n 1 | cut -d: -f1
}

getlines(){
    local next=$(($2+1))
    sed -n "$1, $2p; $nextq" $3
}

chxtouch(){
    sudo touch $1
    sudo chmod +x $1
}

maths(){
    python -c "print($1)"
}


allfiles(){
    if [[ -z $1 ]];then
        find . -maxdepth 1 -type f | sed 's/.\///g'
    else
        find $1 -maxdepth 1 -type f | sed 's/.\///g'
    fi
}

alldirs(){
    if [[ -z $1 ]];then
        local dirs=$(find . -maxdepth 1 -type d | sed 's/.\///g')
    else
        local dirs=$(find $1 -maxdepth 1 -type d)
    fi

    local OLDIFS=$IFS

    IFS=$'\n'
    for dir in ${dirs[@]}; do
        if [[ $dir != "." ]] && [[ ${dir##*/} != "${1##*/}" ]];then
            echo -e "${dir##*/}"
        fi
    done
    IFS=$OLDIFS
}

alllinks(){
    if [[ -z $1 ]];then
        local links=$(find . -maxdepth 1 -type l | sed 's/.\///g')
    else
        local links=$(find $1 -maxdepth 1 -type l)
    fi

    local OLDIFS=$IFS

    IFS=$'\n'
    for link in ${links[@]}; do
        if [[ $link != "." ]] && [[ ${link##*/} != "${1##*/}" ]];then
            echo -e "${link##*/}"
        fi
    done
    IFS=$OLDIFS

}

ffuz() {
	winid=$(xdotool getwindowfocus)
	# input=$(echo -e "$(find $1 -type f,d)" | dmenu -fn "monospace:size=12" -b -l $(($LINES - 11)) -sb "#427b58" -w $winid)
	input=$(echo -e "$(find $1 -type f,d)" | dmenu -fn "monospace:size=12" -l $(($LINES - 7)) -sb "#427b58" -w $winid)
	# input=$(echo -e "$(find $1 -type f,d)" | dmenu -fn "Dejavu Sans Mono:pixelsize=12" -l $(($LINES + 1)) -sb "#427b58" -w $winid)
	# input=$(echo -e "$(find $1 -type f,d)" | dmenu -fn "Dejavu Sans Mono:pixelsize=12" -l $(($LINES + 1)) -sb "#427b58")
	# echo $value
	[[ -d $input ]] && cd $input
	[[ -f $input ]] && sudo vim $input
}

vman(){
	export PAGER="/bin/sh -c \"unset PAGER;col -b -x | \
	 nvim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
		-c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
			-c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""

	/usr/bin/man $1
	export PAGER=
}

ffsrec(){
	# https://girishjoshi.io/post/screen-recording-with-webcam-overlay-using-ffmpeg/
	# https://trac.ffmpeg.org/wiki/Capture/ALSA

	local today=$(date +"%Y-%m-%d")

	# ffmpeg \
	# 	-f x11grab \
	# 	-video_size 2560x1080 \
	# 	-framerate 25 \
	# 	-i $DISPLAY \
	# 	-f alsa \
	# 	-i hw:3 \
	# 	-c:v libx264 \
	# 	-preset ultrafast \
	# 	-c:a aac "${today}--${1:-VID}.mp4"

	# echo -n "path: "
	# read dir
	# local path="~/Videos/casts/${dir}/"
	# echo $path

	local monofile="mono.mp4"

	rm -rf /tmp/${monofile}

	# ffmpeg \
	# 	-f x11grab \
	# 	-video_size 2560x1080 \
	# 	-framerate 25 \
	# 	-i $DISPLAY \
	# 	-f alsa \
	# 	-i default:2 \
	# 	-c:v libx264 \
	# 	-preset ultrafast \
	# 	-c:a aac "/tmp/${monofile}"

	# ffmpeg \
	# 	-f x11grab \
	# 	-video_size 2560x1080 \
	# 	-framerate 25 \
	# 	-i $DISPLAY \
	# 	-f alsa \
	# 	-i default \
	# 	-c:v libx264 \
	# 	-preset ultrafast \
	# 	-c:a aac "/tmp/${monofile}"
	ffmpeg \
		-f x11grab \
		-video_size $2 \
		-framerate 25 \
		-i $DISPLAY \
		-f alsa \
		-i default \
		-c:v libx264 \
		-preset ultrafast \
		-c:a aac "/tmp/${monofile}"

	ffmpeg -i "/tmp/${monofile}" -af "pan=stereo|c0=c0|c1=c0" "/home/nyquist/Videos/casts/youtube/${today}--${1:-VID}.mp4"
	rm -rf $monofile

	# ffmpeg -f x11grab -video_size 1366x768 -framerate 30 -i :0.0 \
	# -f v4l2 -video_size 320x180 -framerate 30 -i /dev/video0 \
	# -filter_complex 'overlay=main_w-overlay_w:main_h-overlay_h:format=yuv444' \
	# -vcodec libx264 -preset ultrafast -qp 0 -pix_fmt yuv444p video.mp4

	# ffmpeg \
	# 	-f x11grab \
	# 	-video_size 2560x1080 \
	# 	-framerate 25 \
	# 	-i $DISPLAY \
	# 	-f v4l2 \
	# 	-video_size 320x1080 \
	# 	-framerate 25 \
	# 	-i /dev/video0 \
	# 	-filter_complex 'overlay=main_w-overlay_w:main_h-overlay_h:format=yuv444' \
	# 	-f alsa \
	# 	-i hw:3 \
	# 	-c:v libx264 \
	# 	-preset ultrafast \
	# 	-c:a aac "${today}--${1:-VID}.mp4"
		# -c:a aac "what.mp4"
}


winmount() {
    sudo ntfsfix $1
    sudo mount -t ntfs-3g $1 /mnt/windows
}

mkdate () {
    mkdir $(date +"%d-%m-%Y")
}
