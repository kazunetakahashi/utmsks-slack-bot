ARRAY=(airi akari yoko futaba teru kirin kurumi asami ako umatan wakaba mizuki)

cur_dir=`pwd`

for item in ${ARRAY[@]}; do
    cd $cur_dir/$item
    nohup slappy start &
done
