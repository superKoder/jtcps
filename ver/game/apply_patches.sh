#!/bin/bash

function make_main {
    # Binary ROM file has bytes swapped because bin2hex 
    # has fixed endianness
    dd if=rom.bin conv=swab | bin2hex  > $1.hex || exit 1
    # Fill the rest of the space
    hexlen=$(wc -l $1.hex | cut -f 1 -d " ")
    yes FFFF | head -n $((4194304-hexlen)) >> $1.hex
}

function apply_patch {
    echo "Creating $2"
    cp $1.hex $2.hex
    patch $2.hex $2.patch
}

make_main ghouls
apply_patch ghouls ghouls_game
apply_patch ghouls ghouls_romtest