ARRAY=(airi akari nene)

cur_dir=`pwd`

for item in ${ARRAY[@]}; do
    cd $cur_dir/$item
    nohup slappy start &
done
