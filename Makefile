#!/usr/bin/make -f

# BASENAME ?= liox-$(shell git describe --tags)-$(LIOX_ARCH)$(LIOX_CONTEST)
BASENAME := liox-test-build
QEMU ?= qemu-system-x86_64 -enable-kvm -cpu host

.PHONY: clean vm iso

iso: $(BASENAME).iso

$(BASENAME).iso:
	lb config --archive-areas "main contrib non-free non-free-firmware"
	mkdir -p config/includes.chroot/etc
	echo $(BASENAME) > config/includes.chroot/etc/liox_version
	lb build
	mv live-image-*.hybrid.iso $@

$(BASENAME).raw:
	qemu-img create -f raw $@ 20G

clean:
	lb clean

AUTO := preseed/file=/cdrom/preseed/auto.cfg
DBG := DEBCONF_DEBUG=5
vm:
	$(QEMU) -no-reboot -smp 2 \
		-m 1G \
		-monitor stdio \
		-display gtk \
		-cdrom $(BASENAME).iso \
		-drive file=$(BASENAME).raw,format=raw \
		-kernel binary/install/vmlinuz \
		-initrd binary/install/initrd.gz \
		-append "auto=true priority=critical keymap=us $(AUTO) $(DBG)"

run-vm:
	$(QEMU) -enable-kvm -no-reboot -smp 2 \
		-cpu host \
		-m 4G \
		-monitor stdio \
		-display gtk \
		-drive file=$(BASENAME).raw,format=raw
