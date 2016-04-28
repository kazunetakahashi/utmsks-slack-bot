ARRAY=(airi akari nene yoko futaba teru kirin kurumi)

cur_dir=`pwd`

for item in ${ARRAY[@]}; do
    cd $cur_dir/$item
    nohup slappy start &
done
