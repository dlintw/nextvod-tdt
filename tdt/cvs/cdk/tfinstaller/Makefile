LINDIR = ../linux-sh4

# To generate an image with initramfs containing the installer the
# following steps have to be executed:
# - remove the original (empty) initramfs file
# - generate and compress new initramfs
# - make a uImage containing the new initramfs
all:
	mv $(LINDIR)/arch/sh/boot/uImage.gz uImage.gz.org

	cp initramfs_list $(LINDIR)/initramfs_list

#CONFIG_INITRAMFS_SOURCE="initramfs_list"
#CONFIG_INITRAMFS_ROOT_UID=0
#CONFIG_INITRAMFS_ROOT_GID=0
## CONFIG_INITRAMFS_COMPRESSION_NONE is not set
#CONFIG_INITRAMFS_COMPRESSION_GZIP=y

	cp $(LINDIR)/.config .config.org
	sed -i 's/CONFIG_INITRAMFS_SOURCE=""/CONFIG_INITRAMFS_SOURCE="initramfs_list"/g' $(LINDIR)/.config
	echo "CONFIG_INITRAMFS_ROOT_UID=0" >> $(LINDIR)/.config
	echo "CONFIG_INITRAMFS_ROOT_GID=0" >> $(LINDIR)/.config
	echo "# CONFIG_INITRAMFS_COMPRESSION_NONE is not set" >> $(LINDIR)/.config
	echo "CONFIG_INITRAMFS_COMPRESSION_GZIP=y" >> $(LINDIR)/.config

	#Build Kernel containing initramfs
	$(MAKE) -C $(LINDIR) ARCH=sh TF7700=y uImage
	rm $(LINDIR)/initramfs_list
	rm $(LINDIR)/.config
	mv .config.org $(LINDIR)/.config

	mv $(LINDIR)/arch/sh/boot/uImage.gz uImage
	mv uImage.gz.org $(LINDIR)/arch/sh/boot/uImage.gz

TFP_OBJS = io.o encode.o decode.o maketree.o maketbl.o huf.o

tfpacker: $(TFP_OBJS)
	gcc -o $@ $(TFP_OBJS)

clean:
	rm -f $(TFP_OBJS)
	rm -f uImage

.c.o:
	gcc -c $< -Wall

$(TFP_OBJS): ar.h

