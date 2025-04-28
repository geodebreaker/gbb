#!/bin/bash

main() {
	if [ "$#" != "1" ]; then
		echo "use while connected to chromebook flash to overwrite gbb flags"
		echo "by geodebreaker - 2025"
	  echo "usage: $0 <flash_programmer_name>"
		echo "example: $0 ch341a_spi"
	  exit 1
	fi
	
	package
	
	if ! sudo flashrom -p "$1" | grep -q "Found"; then
	  echo "No chip found. Exiting."
	  exit 1
	fi
	
	image_file="$(mktemp)"
	trap 'rm -f "$image_file"; exit' EXIT
	
	sudo flashrom -p "$1" -i GBB -r "$image_file" | tail -n +4
	sudo futility gbb -s --flags="0x8031" "$image_file"
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
		echo "The following packages are missing: ${missing[*]}"
	  read -p "Do you want to install them? [Y/n]: " answer
		answer=${answer:-Y}
	  if [[ "$answer" =~ ^[Nn]$ ]]; then
			echo "Exiting..."
	    exit 0
	  else
	    sudo apt update
	    sudo apt install -y "${missing[@]}"
	  fi
	fi
}

main "$@"