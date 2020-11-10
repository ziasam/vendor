devices=('fajita' )
devices=('guacamoleb' )
devices=('guacamole' )

function lunch_devices() {
    add_lunch_combo kangos_${device}-user
    add_lunch_combo kangos_${device}-userdebug
}

for device in ${devices[@]}; do
    lunch_devices
done
