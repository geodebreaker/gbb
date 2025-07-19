#!/bin/bash

main() {
	if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
	  echo "usage: $0 <flash_programmer_name> [flags]"
		echo "example: $0 ch341a_spi"
  	echo "example: $0 ch341a_spi 0x84b7"
		echo "use while connected to chromebook firmware to overwrite gbb flags"
		echo "by geodebreaker - 7/19/25"
	  exit 1
	fi
	
	package
	
	if ! sudo flashrom -p "$1" 2>&1 | grep -q "Found"; then
	  echo "no flash programmer with that name found."
	  exit 1
	fi

	image_file="$(mktemp)"
	trap 'rm -f "$image_file"; exit' EXIT
	sudo flashrom -p "$1" -i GBB -r "$image_file" | tail -n +4
	value=${2:-"0x84b7"}
	sudo futility gbb -s --flags="$value" "$image_file"
	sudo flashrom -p "$1" -i GBB -w "$image_file" | tail -n +4
	echo "Done"
}

package() {
	missing=()
	for pkg in vboot-kernel-utils flashrom; do
	  if ! dpkg -s "$pkg" >/dev/null 2>&1; then
	    missing+=("$pkg")
	  fi
	done
	if [ ${#missing[@]} -ne 0 ]; then
		echo "the following packages are missing: ${missing[*]}"
	  read -p "do you want to install them? [Y/n]: " answer
		answer=${answer:-Y}
	  if [[ "$answer" =~ ^[Nn]$ ]]; then
			echo "exiting..."
	    exit 0
	  else
			if command -v apt &> /dev/null; then
		    sudo apt update
		    sudo apt install -y "${missing[@]}"
			else
				echo "cannot find package manager"
				exit 1
		 	fi
	  fi
	fi
}

main "$@"
