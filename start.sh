ARRAY=(airi akari nene yoko futaba teru kirin kurumi asami)

cur_dir=`pwd`

for item in ${ARRAY[@]}; do
    cd $cur_dir/$item
    nohup slappy start &
done
