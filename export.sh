cd src
find components -iname '*.scad' -exec sh -c 'mkdir -p "../stl/$(dirname "$1")"; openscad "$1" -o "../stl/$(dirname "$1")/$(basename "$1" .scad).stl"' _ {} \;