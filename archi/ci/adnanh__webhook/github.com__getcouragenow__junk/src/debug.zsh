echo Hello from src dir

echo

## Args Count
echo -- Count of ARGS --
echo "The number of arguments is: $#"
a=${@}
echo "The total length of all arguments is: ${#a}: "
count=0
for var in "$@"
do
    echo "The length of argument '$var' is: ${#var}"
    (( count++ ))
    (( accum += ${#var} ))
done
echo "The counted number of arguments is: $count"
echo "The accumulated length of all arguments is: $accum"

echo

echo -- All ARGS --
for i in $*; do 
	echo $i 
done

echo

echo -- Specific ARGS --
## Spefic args
#"source": "payload",
#"name": "head_commit.id"
echo 1: $1
echo 2: $2

echo