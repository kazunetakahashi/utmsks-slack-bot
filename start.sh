ARRAY = (airi akari nene)

for item in ${ARRAY[@]}; do
    cd $item
    nohup slappy start &
done
