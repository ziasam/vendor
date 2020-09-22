function __print_extra_functions_help() {
cat <<EOF
Additional functions:
- repopick:        Utility to fetch changes from Gerrit.
EOF
}

function breakfast()
{
    target=$1
    unset LUNCH_MENU_CHOICES
    add_lunch_combo full-eng
    for f in `/bin/ls vendor/kangos/vendorsetup.sh 2> /dev/null`
        do
            echo "including $f"
            . $f
        done
    unset f

    if [ $# -eq 0 ]; then
        # No arguments, so let's have the full menu
        echo "Nothing to eat for breakfast?"
        lunch
    else
        echo "z$target" | grep -q "-"
        if [ $? -eq 0 ]; then
            # A buildtype was specified, assume a full device name
            lunch $target
        else
            # This is probably just the KangOS model name
            lunch kangos_$target-userdebug
        fi
    fi
    return $?
}

alias bib=breakfast

function brunch()
{
    breakfast $*
    if [ $? -eq 0 ]; then
        time m bacon
    else
        echo "No such item in brunch menu. Try 'breakfast'"
        return 1
    fi
    return $?
}

function repopick() {
    set_stuff_for_environment
    T=$(gettop)
    $T/vendor/kangos/build/tools/repopick.py $@
}

# check and set ccache path on envsetup
if [ -z ${CCACHE_EXEC} ]; then
    ccache_path=$(which ccache)
    if [ ! -z "$ccache_path" ]; then
        export CCACHE_EXEC="$ccache_path"
        echo "ccache found and CCACHE_EXEC has been set to : $ccache_path"
    else
        echo "ccache not found/installed!"
    fi
fi

function push_update(){(
    set -e
    a=()
    devices_dir=$(pwd)/official_devices

    if [ ! -f "$(pwd)/changelog.txt" ]; then
        echo "Create changelog.txt file in build directory"
        echo "Aborting..."
        return 0
    fi

    # Ask the maintainer for login details
    read -p 'ODSN Username: ' uservar
    read -p 'Zip name: ' zipvar

    for s in $(echo $zipvar | tr "-" "\n")
    do
        a+=("$s")
    done

    target_device=${a[4]}
    out_dir=$(pwd)/out/target/product/$target_device/
    version=${a[1]}
    size=$(stat -c%s "$out_dir$zipvar")
    md5=$(md5sum "$out_dir$zipvar")

    echo "Uploading build to ODSN"

    scp $out_dir/$zipvar ${uservar}@storage.osdn.net:/storage/groups/r/re/revengeos/$target_device

    echo "Generating json"

    python3 $(pwd)/vendor/kangos/build/tools/generatejson.py $target_device $zipvar $version $size $md5

    if [ -d "$devices_dir" ]; then
        rm -rf $devices_dir
    fi

    git clone https://github.com/KangOS-Devices/official_devices.git $devices_dir

    if [ -d "$devices_dir/$target_device" ]; then
        mv $(pwd)/device.json $devices_dir/$target_device
        mv $(pwd)/changelog.txt $devices_dir/$target_device
    else
        mkdir $devices_dir/$target_device
        mv $(pwd)/device.json $devices_dir/$target_device
        mv $(pwd)/changelog.txt $devices_dir/$target_device
    fi

    echo "Pushing to Official devices"

    cd $devices_dir
    git add $target_device && git commit -m "Update $target_device"
    git push https://github.com/KangOS-Devices/official_devices.git HEAD:eleven
    rm -rf $devices_dir
)}


function xda_push(){(
    if [ ! -f "$(pwd)/changelog.txt" ]; then
        echo "Create changelog.txt file in build directory"
        echo "Aborting..."
        return 0
    fi

   if [ ! -f "$(pwd)/vendor/build/config.env" ]; then
       echo "config.env files not found in vendor/build/tools please enter details"
   else
    # Ask the maintainer for login details
    read -p 'XDA_USERNAME: ' xdauser
    read -p 'XDA_PASSWORD: ' xdapass
    echo "For XDA_THREAD_ID goto your thread link and grab the integers after t"
    echo "For eg: https://forum.xda-developers.com/lenovo-z6-pro/development/android-10-revengeos-3-1-lenovo-z6-pro-t4030703 Thread ID:4030703"
    read -p 'XDA_THREAD_ID: ' xdaid
  fi

    export XDA_USERNAME=$xdauser
    export XDA_PASSWORD=$xdapass
    export XDA_THREAD_ID=$xdaid
    export FILE=$(pwd)/changelog.txt

    python3 $(pwd)/vendor/kangos/build/tools/xdakey.py
    python3 $(pwd)/vendor/kangos/build/tools/xdapost.py
)}

# Allow GCC 4.9
export TEMPORARY_DISABLE_PATH_RESTRICTIONS=true
